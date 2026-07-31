# Changelog

## [1.0.3](https://github.com/SUSE-Technical-Marketing/suse-virt-rodeo/compare/v1.0.2...v1.0.3) (2026-07-31)

Fixed chapter 5's Drill 2 (bonus): Kube-OVN `Subnet` manifests were missing the
required `provider` field, and the "same CIDR on two zones" premise was wrong
(Kube-OVN enforces CIDR uniqueness per-VPC, not per-provider). Each zone now
creates its own `NetworkAttachmentDefinition` first; `forensics-zone` uses a
distinct CIDR. Live-tested against a running instance before merging.

## [1.0.2](https://github.com/SUSE-Technical-Marketing/suse-virt-rodeo/compare/v1.0.1...v1.0.2) (2026-07-30)

UI branding switched from the SUSE wordmark to the Geeko mascot (private label text
now reads "SUSE Virtualization" to compensate, since the mascot carries no text).
Also: dropped release-please in favor of manual tagging, added CODEOWNERS-gated
review for external PRs, and simplified CONTRIBUTING.md.

## [1.0.1](https://github.com/SUSE-Technical-Marketing/suse-virt-rodeo/compare/v1.0.0...v1.0.1) (2026-07-30)


### Documentation

* add CONTRIBUTING.md and fix stale publish-workflow references ([24858cf](https://github.com/SUSE-Technical-Marketing/suse-virt-rodeo/commit/24858cfbd7c69f345a9e86f33da307c83a12c9ba))
* add CONTRIBUTING.md and fix stale publish-workflow references ([f51c552](https://github.com/SUSE-Technical-Marketing/suse-virt-rodeo/commit/f51c55211fd05b88d853584e6345ffb113c832b7))

## 1.0.0

Baseline release. Nine-chapter SUSE Virtualization Rodeo track (Vertex Trust Bank
story), SUSE Virtualization/Rancher Prime UI rebranding, and check/solve script
coverage across all chapters.
