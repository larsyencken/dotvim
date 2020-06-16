#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  test_wiki.py
#  notes
#

import datetime as dt

import pytest

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


def test_date_prefixed_header():
    filename = "a/b/2020-04-26 Frankish.md"
    header = wiki.gen_header(filename)
    expected = "# 2020-04-26 Frankish\n\n[[../Frankish]] | [[2020-04-26]]\n\n"
    assert header == expected


def test_year_header():
    filename = "a/b/2020.md"
    header = wiki.gen_header(filename)
    expected = "# 2020\n\n[[2019]] | [[Home]] | [[2021]]\n\n## Major life events\n"
    assert header == expected


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
    expected = "# 2019-01-17 W3 Thursday\n\n[[2019-01-16]] | [[2019 W3]] | [[2019-01-18]]\n\n## Agenda\n\n\n\n## Tasks"
    assert header == expected


def test_gen_today_header_from_filename():
    filename = "a/b/2019-01-17.md"
    header = wiki.gen_header(filename)
    expected = "# 2019-01-17 W3 Thursday\n\n[[2019-01-16]] | [[2019 W3]] | [[2019-01-18]]\n\n## Agenda\n\n\n\n## Tasks"
    assert header == expected


def test_gen_week_header_from_filename():
    filename = "a/b/2020-W19.md"
    header = wiki.gen_header(filename)
    expected = (
        "# 2020 W19\n\n"
        "[[2020 W18]] | [[2020 Q2]] | [[2020 W20]]\n\n"
        "## Days\n\n"
        "- [[2020-05-04]]\n"
        "- [[2020-05-05]]\n"
        "- [[2020-05-06]]\n"
        "- [[2020-05-07]]\n"
        "- [[2020-05-08]]"
    )
    assert header == expected


def test_generic_header_malformed():
    filename = "a/b/2020-04-Sheep like that.md"
    header = wiki.gen_header(filename)
    expected = "# 2020 04 Sheep Like That\n\n"
    assert header == expected


def test_non_markdown_file():
    filename = "a/b/sheep"
    with pytest.raises(wiki.NotMarkdownFile):
        wiki.gen_header(filename)


def test_gen_quarter_header_from_filename():
    filename = "a/b/2020-Q1.md"
    header = wiki.gen_header(filename)
    expected = (
        "# 2020 Q1\n\n"
        "[[2019 Q4]] | [[2020]] | [[2020 Q2]]\n\n"
        "## Weeks\n\n"
        "- [[2020 W1]]\n"
        "- [[2020 W2]]\n"
        "- [[2020 W3]]\n"
        "- [[2020 W4]]\n"
        "- [[2020 W5]]\n"
        "- [[2020 W6]]\n"
        "- [[2020 W7]]\n"
        "- [[2020 W8]]\n"
        "- [[2020 W9]]\n"
        "- [[2020 W10]]\n"
        "- [[2020 W11]]\n"
        "- [[2020 W12]]\n"
        "- [[2020 W13]]\n"
        "- [[2020 W14]]"
    )
    assert header == expected
