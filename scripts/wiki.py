# -*- coding: utf-8 -*-
#
#  wiki.py
#  notes
#

import re
from collections import defaultdict
from pathlib import Path
import datetime as dt
import hashlib
import calendar
from dataclasses import dataclass
from typing import List

import blessed
import sh
import isoweek


MARKDOWN_DIR = Path(__file__).parent.parent / "diary"
MONDAY = 0
FRIDAY = 4


@dataclass(eq=True, order=True, frozen=True)
class Week:
    year: int
    week_no: int

    def working_days(self) -> List[dt.date]:
        days = []
        for i in range(1, 6):
            days.append(self[i])

        return days

    def __getitem__(self, i):
        return dt.datetime.strptime(
            f"{self.year}-W{self.week_no}-{i}", "%G-W%V-%u"
        ).date()

    def quarter(self) -> "Quarter":
        return Quarter.from_date(self[1])

    def __str__(self):
        return f"{self.year} W{self.week_no}"

    @staticmethod
    def from_string(s: str) -> "Week":
        year = int(s[:4])
        week_no = int(s.split("W", 1)[-1])
        return Week(year, week_no)

    @staticmethod
    def from_date(d: dt.date) -> "Week":
        w = isoweek.Week.withdate(d)
        return Week(w.year, w.week)


@dataclass(eq=True, order=True, frozen=True)
class Quarter:
    year: int
    quarter: int

    def __str__(self):
        return f"{self.year} Q{self.quarter}"

    @staticmethod
    def from_date(date: dt.date) -> "Quarter":
        year = date.year

        if date < dt.date(year, 4, 1):
            return Quarter(year, 1)

        elif date < dt.date(year, 7, 1):
            return Quarter(year, 2)

        elif date < dt.date(year, 10, 1):
            return Quarter(year, 3)

        return Quarter(year, 4)

    def prev(self):
        if self.quarter == 1:
            return Quarter(self.year - 1, 4)

        return Quarter(self.year, self.quarter - 1)

    def next(self):
        if self.quarter == 4:
            return Quarter(self.year + 1, 1)

        return Quarter(self.year, self.quarter + 1)

    def first_day(self) -> dt.date:
        return dt.date(self.year, 1 + 3 * (self.quarter - 1), 1)

    def last_day(self) -> dt.date:
        return self.next().first_day() - dt.timedelta(days=1)

    def weeks(self) -> List[Week]:
        return sorted(
            set(
                Week.from_date(d) for d in iter_dates(self.first_day(), self.last_day())
            )
        )

    @staticmethod
    def from_string(s: str) -> "Quarter":
        year = int(s[:4])
        quarter = int(s.split("Q", 1)[-1])
        return Quarter(year, quarter)


def list_recent_topics(all_topics=False):
    term = blessed.Terminal()
    topics = detect_topics()

    included = []
    for t, dates in sorted(topics.items()):
        max_date = max(dates)

        if len(dates) > 1:
            if all_topics or (dt.date.today() - max_date).days <= 90:
                included.append((max_date, t))

    for max_date, t in sorted(included, reverse=True):
        print(f"{term.bold(t):35s} {term.red(str(max_date))}")


def norm_name(n):
    return n.replace("-", " ").title()


def edit_file(filename, temp_file=False):
    before = checksum(filename)
    sh.nvim(filename, _fg=True, _cwd=MARKDOWN_DIR)
    after = checksum(filename)

    has_changes = before != after
    return has_changes


def checksum(filename):
    with open(filename, "rb") as istream:
        data = istream.read()

    return hashlib.md5(data).hexdigest()


def gen_topic_header(name, date, existing_notes):
    date_s = render_date(date)
    name_s = name.replace("-", " ")

    prev_dates = [d for d in existing_notes if d < date]
    if prev_dates:
        prev_date = render_date(max(prev_dates))
        prev_link = f"[[{prev_date} {name_s}]] | "
    else:
        prev_link = ""

    next_dates = [d for d in existing_notes if d > date]
    if next_dates:
        next_date = render_date(min(next_dates))
        next_link = f" | [[{next_date} {name_s}]]"

    else:
        next_link = ""

    parent_name, parent_link = gen_parent_link(name, date)

    lines = [
        f"# {date} {name}",
        "",
        f"{prev_link}" f"[[{date_s}]] | " f"[[{parent_link}]]" f"{next_link}",
    ]

    return "\n".join(lines) + "\n"


def gen_today_header(date):
    if date.weekday() != MONDAY:
        lhs_date = date - dt.timedelta(days=1)
    else:
        lhs_date = date - dt.timedelta(days=3)

    if date.weekday() != FRIDAY:
        rhs_date = date + dt.timedelta(days=1)
    else:
        rhs_date = date + dt.timedelta(days=3)

    week_no = date.isocalendar()[1]
    year = date.year
    week_wiki = f"{year} W{week_no}"

    day_of_week = calendar.day_name[date.weekday()]
    agenda = get_agenda(date)

    return (
        f"# {date} {day_of_week}\n\n"
        f"[[{lhs_date}]] | [[{week_wiki}]] | [[{rhs_date}]]\n\n"
        f"## Agenda\n\n"
        f"{agenda}\n\n"
        f"## Tasks"
    )


def get_agenda(date):
    return ""


def gen_parent_link(name, date):
    if name == "Today":
        week_no = get_week_number(date)
        parent = f"{date.year} W{week_no}"

    else:
        parent = name

    return parent, parent


def get_week_number(date):
    return date.isocalendar()[1]


def render_date(d):
    return str(d)


def render_name(name):
    return name.replace(" ", "-")


def make_topic_file(name, date):
    date_s = render_date(date)
    name_s = render_name(name)
    return MARKDOWN_DIR / f"{date_s}-{name_s}.md"


def detect_topics():
    "Return the set of topics that have been observed."
    mkd_files = MARKDOWN_DIR.glob("*.md")

    topics = defaultdict(dict)
    for path in mkd_files:
        f = path.name
        if is_date_prefixed(f):
            date, name = parse_date_prefix(f)
            topics[name][date] = f

    return topics


def iter_dates(start_date: dt.date, end_date: dt.date):
    d = start_date
    while d < end_date:
        yield d
        d += dt.timedelta(days=1)


class NotDatePrefixed(Exception):
    pass


def is_date_prefixed(s):
    try:
        parse_date_prefix(s)

    except NotDatePrefixed:
        return False

    return True


def parse_date_prefix(s):
    assert s.endswith(".md")
    s = s[:-3]

    if "-" in s[:8]:
        s = s[:10].replace("-", "") + s[10:]

    if len(s) < 8:
        raise NotDatePrefixed()

    try:
        year = int(s[:4])
        month = int(s[4:6])
        day = int(s[6:8])

        rest = s[9:].replace("-", " ").title()

        date = dt.date(year, month, day)

    except ValueError:
        raise NotDatePrefixed()

    return date, rest


def write_header(filename, header):
    if Path(filename).exists():
        lines = list(open(filename, "r"))
    else:
        lines = []

    if lines:
        if "|" in lines[0]:
            lines[0] = header
        else:
            lines = [header] + lines
    else:
        lines = [header]

    print("".join(lines), end="")


def write_empty_file(name, date, existing_notes, filename):
    header = gen_header_for_day(name, date, existing_notes)
    with open(filename, "w") as ostream:
        print(header, file=ostream)


def gen_header(filename):
    "Generate a heading for the given filename and return it to stdout."
    filename = Path(filename).name
    if is_date_prefixed(filename):
        date, rest = parse_date_prefix(filename)

        if rest:
            name = norm_name(rest)
            existing = detect_topics()[name]
            header = gen_header_for_day(name, date, existing)
        else:
            header = gen_today_header(date)

    elif is_week_prefixed(filename):
        header = gen_week_header(filename)

    elif is_quarter_prefixed(filename):
        header = gen_quarter_header(filename)

    else:
        header = "[[Home]]"

    return header


def is_week_prefixed(filename):
    return bool(re.match("20[0-9]{2}-W[0-9]{1,2}.md", Path(filename).name))


def is_quarter_prefixed(filename):
    return bool(re.match("20[0-9]{2}-Q[1-4].md", Path(filename).name))


def list_topic_dates(names, all_dates=False):
    topics = detect_topics()
    term = blessed.Terminal()

    for name in names:
        name = resolve_name(name)

        dates = sorted(topics[name], reverse=True)
        if not all_dates:
            dates = dates[:5]

        print(term.bold(name))
        for date in dates:
            print(f"    {term.bright_red(str(date))}")
        print()


def gen_header_for_day(name, date, existing_notes):
    if name == "Today":
        return gen_today_header(date)

    return gen_topic_header(name, date, existing_notes)


def gen_week_header(filename):
    week = Week.from_string(Path(filename).name[:-3])
    year = week.year
    week_no = week.week_no

    last_week = f"{year} W{week_no - 1}"
    next_week = f"{year} W{week_no + 1}"
    parts = [
        f"# {week}",
        "",
        f"[[{last_week}]] | [[{week.quarter()}]] | [[{next_week}]]",
        "",
        "## Days",
        "",
    ]

    for day in week.working_days():
        parts.append(f"- [[{day}]]")

    return "\n".join(parts)


def gen_quarter_header(filename: str) -> str:
    quarter = Quarter.from_string(Path(filename).name[:-3])

    parts = [
        f"# {quarter}",
        "",
        f"[[{quarter.prev()}]] | [[{quarter.year}]] | [[{quarter.next()}]]",
        "",
        "## Weeks",
        "",
    ]

    for week in quarter.weeks():
        parts.append(f"- [[{week}]]")

    return "\n".join(parts)


def prev_working_day(date: dt.date) -> dt.date:
    if date.weekday() != MONDAY:
        return date - dt.timedelta(days=1)

    return date - dt.timedelta(days=3)


def next_working_day(date: dt.date) -> dt.date:
    if date.weekday() != FRIDAY:
        return date + dt.timedelta(days=1)

    # XXX what about Saturday and Sunday?
    return date + dt.timedelta(days=3)


def resolve_name(name):
    return norm_name(name)
