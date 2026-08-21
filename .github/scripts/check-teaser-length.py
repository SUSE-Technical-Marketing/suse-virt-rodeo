#!/usr/bin/env python3
"""Fail if any chapter's teaser frontmatter field exceeds Instruqt's 255-byte limit.

`instruqt track validate` doesn't catch this — it only surfaces at `track push`, as
"challenges: (teaser: the length must be no more than 255.)", well after validation has
already passed. Run this first so a too-long teaser fails fast with the offending file
and length, instead of a bare server-side error during push.

The limit is enforced server-side on the UTF-8 byte length, not the character count —
confirmed by chapter 2's Japanese teaser passing a 255-*character* check (149 chars)
and still getting rejected by `track push` (343 bytes). A non-Latin character is
multiple bytes in UTF-8 (Japanese is typically 3), so measuring by len() badly
undercounts non-English teasers; measuring bytes matches what Instruqt actually checks
regardless of language.

`teaser` is pulled out with a targeted line scan instead of `yaml.safe_load()`-ing the
whole frontmatter block. Several chapters' `title` fields contain markup baked in by the
rmstory tagging tool that isn't strictly valid YAML (a stray backslash / unescaped inner
quotes, e.g. `title: "\\<span id="..." lang="ja" ...>第2章:...</span>"`), in both the
English and Japanese content — a full-document parse throws on those before it ever gets
to `teaser`, even though `teaser` itself is fine. Scanning just for the `teaser:` key
keeps this check working regardless of language or what shape the rest of the
frontmatter is in.
"""
import glob
import re
import sys

LIMIT = 255


def extract_teaser(frontmatter):
    lines = frontmatter.splitlines()
    for i, line in enumerate(lines):
        if not line.startswith("teaser:"):
            continue
        value = line[len("teaser:") :].strip()
        parts = [value] if value else []
        for cont in lines[i + 1 :]:
            if not cont[:1].isspace():
                break
            parts.append(cont.strip())
        return " ".join(p for p in parts if p)
    return None


def main() -> int:
    failed = False
    for path in sorted(glob.glob("[0-9]*/assignment.md")):
        text = open(path, encoding="utf-8").read()
        match = re.match(r"^---\n(.*?)\n---\n", text, re.S)
        if not match:
            continue
        teaser = extract_teaser(match.group(1))
        if teaser is None:
            continue
        length = len(teaser.encode("utf-8"))
        if length > LIMIT:
            print(
                f"{path}: teaser is {length} bytes, over the {LIMIT}-byte Instruqt limit",
                file=sys.stderr,
            )
            failed = True
        else:
            print(f"{path}: teaser is {length}/{LIMIT} bytes, OK")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
