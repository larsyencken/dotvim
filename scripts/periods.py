# -*- coding: utf-8 -*-
#
#  periods.py
#

import datetime as dt
from dataclasses import dataclass
from typing import List, Iterator

import isoweek

MONDAY = 0
FRIDAY = 4


@dataclass(eq=True, order=True, frozen=True)
class Week:
    year: int
    week_no: int

    @property
    def working_days(self) -> List[dt.date]:
        days = []
        for i in range(0, 5):
            days.append(self[i])

        return days

    def __getitem__(self, i):
        "Return 0-indexed dates of the week."
        return dt.datetime.strptime(
            f"{self.year}-W{self.week_no}-{i + 1}", "%G-W%V-%u"
        ).date()

    @property
    def quarter(self) -> "Quarter":
        q = Quarter.from_date(self[0])

        # bump edge-case weeks into more suitable quarters
        if q.year < self.year:
            return q.next

        return q

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

    @property
    def next(self):
        return Week.from_date(self.last_day + dt.timedelta(days=1))

    @property
    def prev(self):
        return Week.from_date(self.first_day - dt.timedelta(days=1))

    @property
    def first_day(self) -> dt.date:
        return self[0]

    @property
    def last_day(self) -> dt.date:
        return self[6]

    @property
    def days(self) -> List[dt.date]:
        return [self[i] for i in range(7)]


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

    @property
    def prev(self):
        if self.quarter == 1:
            return Quarter(self.year - 1, 4)

        return Quarter(self.year, self.quarter - 1)

    @property
    def next(self):
        if self.quarter == 4:
            return Quarter(self.year + 1, 1)

        return Quarter(self.year, self.quarter + 1)

    @property
    def first_day(self) -> dt.date:
        return dt.date(self.year, 1 + 3 * (self.quarter - 1), 1)

    @property
    def last_day(self) -> dt.date:
        return self.next.first_day - dt.timedelta(days=1)

    @property
    def weeks(self) -> List[Week]:
        return sorted(
            set(Week.from_date(d) for d in iter_dates(self.first_day, self.last_day))
        )

    @staticmethod
    def from_string(s: str) -> "Quarter":
        year = int(s[:4])
        quarter = int(s.split("Q", 1)[-1])
        return Quarter(year, quarter)


def iter_dates(start_date: dt.date, end_date: dt.date) -> Iterator[dt.date]:
    """
    Iterates over all dates from start date up to but not including end date.
    """
    d = start_date
    while d < end_date:
        yield d
        d += dt.timedelta(days=1)


def prev_working_day(date: dt.date) -> dt.date:
    if date.weekday() != MONDAY:
        return date - dt.timedelta(days=1)

    return date - dt.timedelta(days=3)


def next_working_day(date: dt.date) -> dt.date:
    if date.weekday() != FRIDAY:
        return date + dt.timedelta(days=1)

    # XXX what about Saturday and Sunday?
    return date + dt.timedelta(days=3)
