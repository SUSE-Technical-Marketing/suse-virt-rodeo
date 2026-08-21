#!/usr/bin/env python3
"""Strip rmstory tagging spans from chapter files before pushing to Instruqt.

Chapter content is tagged for the separate rmstory translation/story-variant tool with
`<span lang="...">`, `<span hist="...">`, and `<span ... no>` wrappers (see the repo's
rmstory tooling). Instruqt's renderer doesn't understand these custom attributes and
renders some of the tags as literal visible text instead of invisible wrappers. Instruqt
itself has no use for this metadata, so it's stripped from the CI runner's working tree
right before validate/push — the git-tracked files keep their tags untouched, since
rmstory still needs them.

Only the tag markup is removed (opening and closing `<span>`/`</span>`), not the content
inside — this is a stack-based unwrap so it's correct for nested spans (e.g. a `no` span
inside a `hist` span), unlike a naive non-greedy regex which would close on the first
`</span>` it sees regardless of nesting depth.
"""
import glob
import re
import sys

OPEN_RE = re.compile(r"<span\b([^>]*)>")
CLOSE_RE = re.compile(r"</span>")
STRIP_ATTR_RE = re.compile(r'\blang\s*=|\bhist\s*=|\bno\b')


def strip_spans(text: str) -> str:
    out = []
    stack = []  # True = this span is being stripped, False = left as-is
    pos = 0
    while pos < len(text):
        open_m = OPEN_RE.match(text, pos)
        close_m = CLOSE_RE.match(text, pos)
        if open_m:
            strip = bool(STRIP_ATTR_RE.search(open_m.group(1)))
            stack.append(strip)
            if not strip:
                out.append(open_m.group(0))
            pos = open_m.end()
        elif close_m:
            strip = stack.pop() if stack else False
            if not strip:
                out.append(close_m.group(0))
            pos = close_m.end()
        else:
            out.append(text[pos])
            pos += 1
    return "".join(out)


def main() -> int:
    for path in sorted(glob.glob("[0-9]*/assignment.md")):
        text = open(path, encoding="utf-8").read()
        stripped = strip_spans(text)
        if stripped != text:
            open(path, "w", encoding="utf-8").write(stripped)
        print(f"{path}: stripped")
    return 0


if __name__ == "__main__":
    sys.exit(main())
