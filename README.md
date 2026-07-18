# SUSE Virtualization Rodeo

An Instruqt interactive lab. Participants play the new infrastructure engineer at
**Vertex Trust Bank**, moving the bank off an expensive legacy hypervisor and onto
**SUSE Virtualization** (Harvester HCI) managed by **Rancher Prime**.

The lab runs on a pre-built Instruqt image that already contains a live 3-node
Harvester cluster plus Rancher. There is no install wait during the session, so
students spend their time on the tasks, not on cluster bring-up.

**Versions:** Harvester 1.8.1 · Rancher Prime 2.14.1 · K3s v1.35 · SLES 16 host
**Duration:** ~3 hours
**Audience:** DevOps engineers, SREs, platform teams looking at SUSE Virtualization

> **This repo is the lab content only.** The infrastructure it runs on (the nested
> Harvester + Rancher stack) is built and owned by **rodeo-cli**, not by this repo.
> See [Where the lab runs](#where-the-lab-runs) below.

---

## The story

Vertex Trust Bank is drowning in legacy hypervisor renewal costs. Sarah, the CTO,
hands you the keys to a fresh SUSE Virtualization platform and a list of problems that
will not wait. Each chapter is a crisis that maps to a real task in a hypervisor
migration: bring the cluster online, ship a VM under pressure, dodge a hardware
failure with live migration, wall off a sensitive database, recover a deleted record,
scale a fleet, and pull the last workload off the old vendor.

By the end the bank runs entirely on SUSE Virtualization, and the student has done
every core operation by hand.

---

## The chapters

Nine story chapters, run in order. Each is an Instruqt challenge with its own
`assignment.md` and, where there is something to grade, a `check-kvm-host` and
`solve-kvm-host` script.

| # | Chapter | What the student does |
|---|---------|-----------------------|
| 1 | 🏦 The Arrival | Health-check the new cluster, tour the Harvester and Rancher UIs. |
| 2 | 🛗 The Subterranean Divide | Map the node topology, build the cluster network and VM network foundation. |
| 3 | ⚡ The Flash Crash | Deploy a fully configured VM (disk, storage, cloud-init credentials) fast. |
| 4 | 🌊 The Rising Tide | Zero-downtime live migration of the payment gateway VM. |
| 5 | 🕵️ The Invisible Intruder | Software-defined networking: isolate the sensitive database behind a VPC. |
| 6 | ⏪ The Unthinkable Error | VM snapshots, restore into a staging clone, storage tiers, scheduled backups. |
| 7 | 🤠 The Stampede | Forge a golden VM template and stamp out identical machines on demand. |
| 8 | ⚔️ The Final Showdown | Migrate the last VM off the legacy ISAware cluster while it is still running. |
| 9 | 🌅 A New Horizon | Recap what was covered and where the skills go next. |

`10-development/` is an internal sandbox chapter for authoring and testing. It is not
part of the student flow.

---

## Where the lab runs

The lab assumes a single Instruqt VM, `kvm-host`: a SLES 16 machine with KVM that
virtualizes the whole SUSE Virtualization stack inside itself (nested virtualization).

That stack is **not built by this repo**. It is deployed with
**[rodeo-cli](https://github.com/avaleror/rodeo-cli)** using the `harvester` profile:

```bash
rodeo up --profile harvester
```

That one command builds everything the lab needs on the host:

| Component | IP | Notes |
|-----------|----|-------|
| Harvester VIP | 192.168.122.10 | kube-vip floating VIP, cluster API + UI (serves on 443) |
| harvester1 | 192.168.122.11 | bootstrap / cluster-init node |
| harvester2 | 192.168.122.12 | join node |
| harvester3 | 192.168.122.13 | join node |
| Rancher Prime | 192.168.122.9 | K3s + Rancher, NodePort 30002 |

The nested guests sit on the libvirt NAT network `192.168.122.0/24`. Because they are
nested, the UIs are reached from outside through **DNAT on `kvm-host`**:

```
kvm-host:8443   --DNAT-->  192.168.122.10:443     Harvester UI (floating VIP)
kvm-host:30002  --DNAT-->  192.168.122.9:30002    Rancher Prime UI (K3s NodePort)
```

Instruqt surfaces these as browser tabs. Each challenge declares `service` tabs on
`kvm-host` ports `8443` and `30002`, plus a terminal tab, so students get the Harvester
UI, the Rancher UI, and a shell without touching the nested networking.

For the full profile reference (host sizing, other Harvester profiles, iPXE install
detail) see the rodeo-cli
[Harvester guide](https://github.com/avaleror/rodeo-cli/blob/main/docs/guide-harvester.md).
The same stack backs the public self-serve
**[suse-virt-workshop](https://github.com/avaleror/suse-virt-workshop)**.

> **The image.** The published Instruqt image (`suse/suse-virt-rodeo-rc1`, see
> `config.yml`) was produced with rodeo-cli plus some manual tweaking, then saved as a
> reusable image. Rebuilding or refreshing that image is a rodeo-cli task, not a task
> in this repo.

---

## Repository layout

```
.
├── 01-the-arrival-welcome/              # Chapter 1
├── 02-the-subterranean-divide-cluster-prep/
├── 03-the-flash-crash-first-vm/
├── 04-the-rising-tide-live-migration/
├── 05-the-invisible-intruder-networking/
├── 06-the-unthinkable-error-snapshots/
├── 07-the-stampede-automation/
├── 08-the-final-showdown-migrate-isaware/
├── 09-a-new-horizon-whats-next/         # Chapter 9
├── 10-development/                      # internal authoring sandbox
├── track_scripts/
│   └── setup-kvm-host                   # runs at track start: boots VMs, waits for
│                                        # the cluster, sets agent variables
├── assets/                             # chapter images, GIF walkthroughs, logos
├── config.yml                          # Instruqt sandbox config (points at the image)
└── track.yml                           # Instruqt track definition
```

Each chapter directory holds:

- `assignment.md` — the story, instructions, and embedded walkthroughs the student reads
- `check-kvm-host` — validates the chapter objective (present where there is grading)
- `solve-kvm-host` — the automated solution used by the Solve button / CI

---

## How a session starts

1. Instruqt boots the `kvm-host` image (already contains the Harvester + Rancher stack).
2. `track_scripts/setup-kvm-host` runs: it starts the nested VMs idempotently, waits
   for the Harvester VIP, then for all 3 nodes to reach `Ready`, and exports the agent
   variables the assignments reference (`RANCHER_URL`, `HARVESTER_URL`,
   `RANCHER_PASSWORD`, `HARVESTER_PASSWORD`).
3. The student works through chapters 1 to 9. Each chapter's `check` script gates
   progress.

Startup from a pre-built image is minutes, not the ~90 the from-scratch cluster build
would take, which is the whole reason the stack is baked into the image.

---

## Working on the lab

### Push the track to Instruqt

```bash
instruqt track push
instruqt track start suse-virt-rodeo
```

`.github/workflows/publish.yml` validates and pushes the track automatically on every
push to `main`, and can be triggered manually with `workflow_dispatch`. It needs
`INSTRUQT_TOKEN` in the repo secrets and the `suse/suse-virt-rodeo-rc1` image published
in the Instruqt org.

### Credentials

The lab uses one fixed admin password for both the Harvester and Rancher UIs (user
`admin`). It is written to `/root/rancher-password` on `kvm-host` and exported as the
`RANCHER_PASSWORD` / `HARVESTER_PASSWORD` agent variables, so assignments reference it
as `[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]`. It is lab-grade
only, do not reuse it anywhere real. Node SSH is key-based.

---

## Contributing

Work on `dev`. Keep this repo lab-only: anything about building the host, the nested
VMs, iPXE, or the image belongs in
**[rodeo-cli](https://github.com/avaleror/rodeo-cli)**, not here.

Track developers: andres.valero@suse.com · raul.mahiques@suse.com
