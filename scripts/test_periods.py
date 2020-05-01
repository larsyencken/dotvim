# -*- coding: utf-8 -*-
#
#  test_periods.py
#

import datetime as dt

from periods import Week, Quarter, iter_dates, next_working_day, prev_working_day


def test_week_str():
    w = Week(2020, 1)
    assert str(w) == "2020 W1"


def test_week_from_str():
    assert Week.from_string("2020 W1") == Week(2020, 1)


def test_week_to_quarter():
    w = Week(2020, 4)
    assert w.quarter == Quarter(2020, 1)


def test_week_to_quarter_boundary():
    w = Week(2020, 1)
    assert w.quarter == Quarter(2020, 1)


def test_days_in_week():
    w = Week(2020, 1)
    start_date = dt.date(2019, 12, 30)
    days = list(iter_dates(start_date, start_date + dt.timedelta(days=7)))
    assert w.days == days


def test_quarter_str():
    q = Quarter(2020, 1)
    assert str(q) == "2020 Q1"


def test_iter_dates():
    start_date = dt.date(2020, 1, 1)
    end_date = dt.date(2020, 1, 2)
    ds = list(iter_dates(start_date, end_date))

    assert ds == [start_date]


def test_prev_working_day():
    # friday → thursday
    d1 = dt.date(2020, 5, 1)
    assert prev_working_day(d1) == dt.date(2020, 4, 30)

    # monday → friday
    d2 = dt.date(2020, 5, 4)
    assert prev_working_day(d2) == dt.date(2020, 5, 1)


def test_next_working_day():
    # friday → monday
    d1 = dt.date(2020, 5, 1)
    assert next_working_day(d1) == dt.date(2020, 5, 4)

    # monday → tuesday
    d2 = dt.date(2020, 5, 4)
    assert next_working_day(d2) == dt.date(2020, 5, 5)
