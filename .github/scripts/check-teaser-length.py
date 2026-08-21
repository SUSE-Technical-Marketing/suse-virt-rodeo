#!/usr/bin/env python3
"""Fail if any chapter's teaser frontmatter field exceeds Instruqt's 255-char limit.

`instruqt track validate` doesn't catch this — it only surfaces at `track push`, as
"challenges: (teaser: the length must be no more than 255.)", well after validation has
already passed. Run this first so a too-long teaser fails fast with the offending file
and length, instead of a bare server-side error during push.
"""
import glob
import re
import sys

import yaml

LIMIT = 255


def main() -> int:
    failed = False
    for path in sorted(glob.glob("[0-9]*/assignment.md")):
        text = open(path, encoding="utf-8").read()
        match = re.match(r"^---\n(.*?)\n---\n", text, re.S)
        if not match:
            continue
        frontmatter = yaml.safe_load(match.group(1))
        teaser = frontmatter.get("teaser")
        if teaser is None:
            continue
        length = len(teaser)
        if length > LIMIT:
            print(
                f"{path}: teaser is {length} chars, over the {LIMIT}-char Instruqt limit",
                file=sys.stderr,
            )
            failed = True
        else:
            print(f"{path}: teaser is {length}/{LIMIT} chars, OK")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
