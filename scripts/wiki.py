# -*- coding: utf-8 -*-
#
#  wiki.py
#  notes
#

import re
from pathlib import Path
import datetime as dt
import calendar
from typing import Tuple, Optional

from periods import Week, Quarter, prev_working_day, next_working_day

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

    elif f.is_year():
        return _gen_year_header(f.year)

    return _gen_generic_header(f.normed_base)


class NotMarkdownFile(Exception):
    pass


class WikiFile:
    def __init__(self, filename: str):
        if not filename.endswith(".md"):
            raise NotMarkdownFile(filename)

        self.filename = filename
        self.base = Path(filename).stem

    def is_date_prefixed(self) -> bool:
        try:
            self.parse_date()
        except NotDatePrefixed:
            return False

        return True

    def is_week_prefixed(self) -> bool:
        return bool(re.match("^20[0-9]{2}-W[0-9]{1,2}", self.base))

    def is_quarter_prefixed(self) -> bool:
        return bool(re.match("^20[0-9]{2}-Q[1-4]", self.base))

    def is_year(self) -> bool:
        return bool(re.match("^(19|20)[0-9]{2}$", self.base))

    @property
    def week(self) -> Week:
        return Week.from_string(self.base)

    @property
    def normed_base(self) -> str:
        return _norm_name(self.base)

    @property
    def quarter(self) -> Quarter:
        return Quarter.from_string(self.base)

    @property
    def year(self) -> int:
        return int(self.base)

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
    return f"# {date} {title.title()}\n\n[[{title.title()}]]\n\n"


def _gen_daily_journal_header(date: dt.date) -> str:
    lhs_date = prev_working_day(date)
    rhs_date = next_working_day(date)

    week_no = date.isocalendar()[1]
    year = date.year
    week_wiki = f"{year} W{week_no}"

    day_of_week = calendar.day_name[date.weekday()]

    return (
        f"# {date} W{week_no} {day_of_week}\n\n"
        f"[[{lhs_date}]] | [[{week_wiki}]] | [[{rhs_date}]]\n\n"
        f"## Agenda\n\n\n\n"
        f"## Tasks"
    )


def _gen_week_header(week: Week) -> str:
    parts = [
        f"# {week}",
        "",
        f"[[{week.prev}]] | [[{week.quarter}]] | [[{week.next}]]",
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
        f"[[{quarter.prev}]] | [[{quarter.year}]] | [[{quarter.next}]]",
        "",
        "## Weeks",
        "",
    ]

    for week in quarter.weeks:
        parts.append(f"- [[{week}]]")

    return "\n".join(parts)


def _gen_year_header(year: int) -> str:
    parts = [
        f"# {year}",
        "",
        f"[[{year - 1}]] | [[Home]] | [[{year + 1}]]",
        "",
        "## Major life events",
        "",
    ]

    return "\n".join(parts)


def _gen_generic_header(title: str) -> str:
    return f"# {title}\n\n"


def _norm_name(n):
    return n.replace("-", " ").title()


class NotDatePrefixed(Exception):
    pass
