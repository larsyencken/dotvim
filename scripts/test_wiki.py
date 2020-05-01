#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  test_wiki.py
#  notes
#

import datetime as dt

import wiki


def test_gen_today_header_from_date():
    date = dt.date(2019, 1, 17)
    header = wiki.gen_today_header(date)
    expected = "# 2019-01-17 Thursday\n\n[[2019-01-16]] | [[2019 W3]] | [[2019-01-18]]\n\n## Agenda\n\n\n\n## Tasks"
    assert header == expected


def test_gen_today_header_from_filename():
    filename = "a/b/2019-01-17.md"
    header = wiki.gen_header(filename)
    expected = "# 2019-01-17 Thursday\n\n[[2019-01-16]] | [[2019 W3]] | [[2019-01-18]]\n\n## Agenda\n\n\n\n## Tasks"
    assert header == expected
