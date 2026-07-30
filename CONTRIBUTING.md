# Contributing to SUSE Virtualization Rodeo

Thanks for helping improve the rodeo. This repo is lab content only — if your change
is about the host, the nested Harvester/Rancher stack, iPXE, or the Instruqt image
itself, it belongs in [rodeo-cli](https://github.com/avaleror/rodeo-cli), not here.

## How to contribute

1. Branch off `dev`:
   ```bash
   git checkout dev && git pull
   git checkout -b feat/short-description
   ```
2. Make your change. If you're touching a chapter, check whether it needs a matching
   update to that chapter's `check-kvm-host` / `solve-kvm-host` — see
   [Repository layout](README.md#repository-layout) in the README.
3. Open a PR against `dev`.
4. A maintainer (Andres Valero or Raul Mahiques) reviews and approves before merge —
   this is required, GitHub won't let a PR merge without it.

### PR title format

**PR titles should follow [Conventional Commits](https://www.conventionalcommits.org/)**
— a GitHub Action lints this automatically. Keeping it consistent makes `git log` and
the PR history easy to scan.

```
<type>: <short description>
```

| Type | Use for |
|------|---------|
| `feat` | a new chapter, task, or capability |
| `fix` | a bug in a script, a broken check, wrong content |
| `perf` | making something faster (e.g. faster VM boot) |
| `refactor` | restructuring without changing behavior |
| `docs` | README, assignment wording, comments |
| `build` | tooling, CI, dependency changes |
| `ci` | GitHub Actions workflow changes |
| `test` | test-only changes |
| `chore` | anything else (bumps, cleanup) |

Add a `!` after the type (e.g. `feat!:`) for a breaking change — one that would make an
in-progress student session behave incorrectly (renamed VM/network another chapter
depends on, changed chapter order, removed agent variable, etc.).

Examples:
```
feat: add chapter 10 covering vGPU passthrough
fix(chapter5): secure-loop-dev subnet was missing DHCP
docs: correct Rancher Prime version in README
```

## Publishing to the live Instruqt track

Merging a PR doesn't automatically publish anything — a maintainer pushes `main` to
Instruqt manually once changes have settled there. See
[Where the lab runs](README.md#where-the-lab-runs) for how the underlying
infrastructure is built.

## Questions

Open an issue, or reach out to andres.valero@suse.com · raul.mahiques@suse.com.
