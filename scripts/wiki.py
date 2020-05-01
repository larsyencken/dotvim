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
from typing import Tuple, Optional

import blessed
import sh
import arrow

from periods import Week, Quarter, prev_working_day, next_working_day


MARKDOWN_DIR = Path(__file__).parent.parent / "diary"


DAILY_HEADER = """# {year} W{week_no} {day}

[[{prev_date}]] | [[{year} W{week_no}]] | [[{next_date}]]

## Agenda

## Tasks
"""

WEEK_HEADER = """# {year} W{week_no}

[[{prev_week}]] | [[{year}]] | [[{next_week}]]

"""


def gen_header(filename: str) -> str:
    "Generate a heading for the given filename and return it to stdout."
    f = WikiFile(filename)

    if f.is_date_prefixed():
        date, title = f.parse_date()
        return _gen_day_header(date, title)

    elif f.is_week_prefixed():
        return _gen_week_header(f.week)

    elif f.is_quarter_prefixed():
        return _gen_quarter_header(f.quarter)

    return _gen_generic_header(f.base)


def list_recent_topics(all_topics: bool = False) -> None:
    """
    Print all topic files with recent entries.
    """
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


class WikiFile:
    def __init__(self, filename: str):
        if not filename.endswith(".md"):
            raise ValueError(filename)

        self.filename = filename
        self.base = Path(filename).stem

    def is_date_prefixed(self) -> bool:
        try:
            self.parse_date()
        except NotDatePrefixed:
            return False

        return True

    def is_week_prefixed(self) -> bool:
        return bool(re.match("20[0-9]{2}-W[0-9]{1,2}", self.base))

    def is_quarter_prefixed(self) -> bool:
        return bool(re.match("20[0-9]{2}-Q[1-4]", self.base))

    @property
    def week(self) -> Week:
        return Week.from_string(self.base)

    @property
    def quarter(self) -> Quarter:
        return Quarter.from_string(self.base)

    def parse_date(self) -> Tuple[dt.date, Optional[str]]:
        s = self.base
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

        return date, (rest or None)


def _gen_day_header(date: dt.date, title: Optional[str]) -> str:
    if title:
        return _gen_topic_header(date, title)

    return _gen_daily_journal_header(date)


def _gen_topic_header(date: dt.date, title: str) -> str:
    return ""


def _gen_daily_journal_header(date: dt.date) -> str:
    lhs_date = prev_working_day(date)
    rhs_date = next_working_day(date)

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


def _gen_week_header(week: Week) -> str:
    year = week.year
    week_no = week.week_no

    last_week = f"{year} W{week_no - 1}"
    next_week = f"{year} W{week_no + 1}"
    parts = [
        f"# {week}",
        "",
        f"[[{last_week}]] | [[{week.quarter}]] | [[{next_week}]]",
        "",
        "## Days",
        "",
    ]

    for day in week.working_days:
        parts.append(f"- [[{day}]]")

    return "\n".join(parts)


def _gen_quarter_header(quarter: Quarter) -> str:
    parts = [
        f"# {quarter}",
        "",
        f"[[{quarter.prev()}]] | [[{quarter.year}]] | [[{quarter.next()}]]",
        "",
        "## Weeks",
        "",
    ]

    for week in quarter.weeks:
        parts.append(f"- [[{week}]]")

    return "\n".join(parts)


def _gen_generic_header(title: str) -> str:
    return ""


def _norm_name(n):
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
        f = WikiFile(path)
        if f.is_date_prefixed():
            date, name = f.parse_date()
            topics[name][date] = f

    return topics


class NotDatePrefixed(Exception):
    pass


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


def resolve_name(name):
    return _norm_name(name)


def _date_header(name: str) -> str:
    date = parse_date(name)
    week_no = get_week_no(date)
    day = calendar.day_name[date.weekday()]
    prev_date = date - dt.timedelta(days=1)
    next_date = date + dt.timedelta(days=1)
    return DAILY_HEADER.format(
        year=date.year,
        week_no=week_no,
        day=day,
        prev_date=prev_date,
        next_date=next_date,
    )


def week_header(name: str):
    year = int(name.split("-")[0])
    week_no = int(name.split("W")[1])
    prev_week = f"{year} W{week_no - 1}" if week_no > 1 else f"{year - 1} W52"
    next_week = f"{year} W{week_no + 1}" if week_no < 52 else f"{year + 1} W1"
    return WEEK_HEADER.format(
        week_no=week_no, year=year, prev_week=prev_week, next_week=next_week
    )


def is_date(s: str) -> bool:
    return bool(re.match("[0-9]{4}-[0-9]{2}-[0-9]{2}", s))


def is_week(s: str) -> bool:
    return bool(re.match("[0-9]{4}-W[0-9]{1,2}", s))


def parse_date(s: str) -> dt.date:
    return arrow.get(s).date()


def get_week_no(date: dt.date) -> int:
    return date.isocalendar()[1]
