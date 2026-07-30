# Contributing to SUSE Virtualization Rodeo

Thanks for helping improve the rodeo. This repo is lab content only — if your change
is about the host, the nested Harvester/Rancher stack, iPXE, or the Instruqt image
itself, it belongs in [rodeo-cli](https://github.com/avaleror/rodeo-cli), not here.

## Branches

- **`dev`** — where all day-to-day work lands first.
- **`main`** — the stable branch. It's what gets manually pushed to the live Instruqt
  track (`instruqt track push`) and manually tagged for releases. It only receives
  changes that have already been merged and settled on `dev`, via a periodic
  `dev` → `main` sync.

**Andres and Raul can push directly to either branch** — no PR required for small
changes. Use a PR anyway for anything sizeable (a new chapter, a change touching
several chapters, anything you'd want a second pair of eyes on) — it's optional, not
enforced by GitHub, so it's a judgment call each time.

Everyone else: every change goes through a PR (branch off `dev`, open the PR against
`dev`). PRs don't require an approval to merge, but the PR title lint must pass.

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

**PR titles should follow [Conventional Commits](https://www.conventionalcommits.org/)** —
a GitHub Action lints this automatically. It's informational (not a merge-blocking
check), but keeping it consistent makes `git log` and the PR history easy to scan.

```
<type>: <short description>
```

Allowed types:

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

- The **PR title lint** runs on every PR but does not block merge.
- **No approval is required to merge.**
- Merges into `dev` are squash-merged (one clean commit per PR). The periodic
  `dev` → `main` sync is a regular merge, so individual commits stay visible in history.

## Versioning and releases

**Tags are created manually** — there is no automated versioning (we tried
release-please; it bumps the version for *any* commit, including docs-only changes,
with no way to exclude specific types, so we dropped it). After pushing a meaningful
batch of changes to `main`, a maintainer decides major/minor/patch by eye based on the
size and nature of the change, then:

```bash
git checkout main && git pull
git tag -a vX.Y.Z -m "vX.Y.Z — short summary of what changed"
git push origin vX.Y.Z
```

Follow standard [semver](https://semver.org/): major for breaking changes (a renamed
chapter dependency, a changed agent variable), minor for new content (a new chapter or
task), patch for fixes and docs. `CHANGELOG.md` can be updated by hand alongside the
tag if the change is worth calling out.

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
