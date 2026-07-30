# Contributing to SUSE Virtualization Rodeo

Thanks for helping improve the rodeo. This repo is lab content only — if your change
is about the host, the nested Harvester/Rancher stack, iPXE, or the Instruqt image
itself, it belongs in [rodeo-cli](https://github.com/avaleror/rodeo-cli), not here.

## Branches

- **`dev`** — where all day-to-day work lands first. Open your PR against this branch.
- **`main`** — the stable branch. It's what gets manually pushed to the live Instruqt
  track (`instruqt track push`), and what release-please tags. It only receives
  changes that have already been merged and settled on `dev`, via a `dev` → `main` PR
  opened periodically by a maintainer.

Both branches are protected: no direct pushes, every change goes through a PR.

## Opening a PR

1. Branch off `dev`:
   ```bash
   git checkout dev && git pull
   git checkout -b feat/short-description
   ```
2. Make your change. If you're touching a chapter, check whether it needs a matching
   update to that chapter's `check-kvm-host` / `solve-kvm-host` — see
   [Repository layout](README.md#repository-layout) in the README.
3. Open the PR against `dev`.

### PR title format

**PR titles must follow [Conventional Commits](https://www.conventionalcommits.org/)** —
a GitHub Action lints this automatically and blocks merge if the title doesn't match.
Since PRs are squash-merged, the title becomes the commit message that release-please
later reads to work out the next version number.

```
<type>: <short description>
```

Allowed types (keep in sync with `release-please-config.json`):

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

### Checks and review

- The **PR title lint** must pass.
- **PRs need one approval before merge**, from andres.valero@suse.com or
  raul.mahiques@suse.com.
- Merges into `dev` are squash-merged (one clean commit per PR). The periodic
  `dev` → `main` sync is a regular merge, so individual commits stay visible to
  release-please.

## Versioning and releases

Releases are automated with [release-please](https://github.com/googleapis/release-please).
Every push to `main` re-evaluates the Conventional Commit history since the last
release; when there's something to release, release-please opens (or updates) a
release PR that bumps the version and updates `CHANGELOG.md`. Merging that PR cuts the
git tag automatically. You never hand-pick a version number.

## Publishing to the live Instruqt track

Not automated. A maintainer runs, from a clean `main` checkout:

```bash
git checkout main && git pull
instruqt track validate
instruqt track push
```

See [Where the lab runs](README.md#where-the-lab-runs) for how the underlying
infrastructure is built.

## Questions

Open an issue, or reach out to andres.valero@suse.com · raul.mahiques@suse.com.
