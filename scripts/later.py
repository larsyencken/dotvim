from pathlib import Path
import hashlib
import datetime as dt

import blessed
from collections import defaultdict
import sh

from wiki import WikiFile, _norm_name

MARKDOWN_DIR = Path(__file__).parent.parent / "diary"


def list_topic_dates(names, all_dates=False):
    topics = detect_topics()
    term = blessed.Terminal()

    for name in names:
        name = _norm_name(name)

        dates = sorted(topics[name], reverse=True)
        if not all_dates:
            dates = dates[:5]

        print(term.bold(name))
        for date in dates:
            print(f"    {term.bright_red(str(date))}")
        print()


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
