#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  test_wiki.py
#  notes
#

import datetime as dt

import wiki
from periods import Week, Quarter


def test_date_prefixed_file():
    filename = "a/b/2020-04-26 Frankish.md"
    f = wiki.WikiFile(filename)

    assert f.is_date_prefixed()
    assert not f.is_week_prefixed()
    assert not f.is_quarter_prefixed()

    date, title = f.parse_date()
    assert date == dt.date(2020, 4, 26)
    assert title == "Frankish"


def test_week_prefixed_file():
    filename = "a/b/2020-W12.md"
    f = wiki.WikiFile(filename)

    assert not f.is_date_prefixed()
    assert f.is_week_prefixed()
    assert not f.is_quarter_prefixed()

    assert f.week == Week(2020, 12)


def test_quarter_prefixed_file():
    filename = "a/b/2020-Q4.md"
    f = wiki.WikiFile(filename)

    assert not f.is_date_prefixed()
    assert not f.is_week_prefixed()
    assert f.is_quarter_prefixed()

    assert f.quarter == Quarter(2020, 4)


def test_gen_today_header_from_date():
    date = dt.date(2019, 1, 17)
    header = wiki._gen_daily_journal_header(date)
    expected = "# 2019-01-17 Thursday\n\n[[2019-01-16]] | [[2019 W3]] | [[2019-01-18]]\n\n## Agenda\n\n\n\n## Tasks"
    assert header == expected


def test_gen_today_header_from_filename():
    filename = "a/b/2019-01-17.md"
    header = wiki.gen_header(filename)
    expected = "# 2019-01-17 Thursday\n\n[[2019-01-16]] | [[2019 W3]] | [[2019-01-18]]\n\n## Agenda\n\n\n\n## Tasks"
    assert header == expected
