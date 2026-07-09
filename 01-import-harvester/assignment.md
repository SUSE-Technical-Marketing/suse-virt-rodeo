---
slug: import-harvester
id: imp0harv0rnc1
type: challenge
title: AeroGrid Platform — Connect SUSE Virtualization to Rancher Prime
teaser: Import the running SUSE Virtualization cluster into Rancher Prime to get a single pane of glass over the full platform
tabs:
- id: tab-terminal
  title: Terminal
  type: terminal
  hostname: kvm-host
- id: tab-rancher
  title: Rancher UI
  type: service
  hostname: kvm-host
  path: /
  port: 30002
- id: tab-harvester
  title: Harvester UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
difficulty: basic
timelimit: 1800
enhanced_loading: null
---

> **OPS BRIEF:** AeroGrid Network Operations Center | Priority: Critical | Assigned: Infrastructure Team
> The SUSE Virtualization cluster is up and healthy. Rancher Prime is running. They do not know about each other yet. Connect them now.

The AeroGrid SUSE Virtualization cluster is online — three nodes, distributed storage, SDN networking. Rancher Prime is running on its own VM. Right now they are two separate systems with no visibility into each other. You need to import the Harvester cluster into Rancher so you have one place to manage VMs, provision Kubernetes clusters, and control RBAC across the whole platform.

The import takes two steps and no kubectl commands. Rancher generates a registration URL. Harvester accepts it in its own Settings page, then handles the rest automatically.

> [!NOTE]
> Both UIs use self-signed certificates. Accept the browser security warning when it appears.

Your Lab Environment
===

Open the [button label="Terminal" variant="success"](tab-0) tab and verify the cluster is reachable:

```bash,run
curl -sk https://192.168.122.10/v1 | jq -r '.apiVersion'
curl -sk https://192.168.122.9:30002/v3 | jq -r '.type'
```

Both should return without error — `management.cattle.io/v3` and `collection`. The backends are up.

Log in to Rancher
===

Open the [button label="Rancher UI" variant="success"](tab-1) tab.

Log in with:
- **Username:** `admin`
- **Password:** `[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="kvm-host" ]]`

You will land on the Rancher home screen. There is one cluster listed: **local** — that is Rancher's own K3s management cluster, not the SUSE Virtualization platform. It has no Virtualization Management section yet because no Harvester cluster is imported.

TASK: Register the Harvester Cluster in Rancher
===

In the [button label="Rancher UI" variant="success"](tab-1) tab:

1. Click the **Virtualization Management** item in the left sidebar
2. Click **Import Existing** (top right)
3. Set **Cluster Name** to `harvester`
4. Click **Create**

Rancher now shows a registration URL. It looks like:
`https://192.168.122.9:30002/v3/import/xxxxx_c-xxxxx.yaml`

Copy this URL. You need it in the next step.

> [!IMPORTANT]
> The cluster name must be exactly `harvester` — scripts in later challenges depend on this name.

TASK: Apply the Registration URL in Harvester
===

Open the [button label="Harvester UI" variant="success"](tab-2) tab.

Log in with the same credentials (`admin` / password from above).

1. Click the **Settings** icon in the left sidebar (gear icon)
2. Scroll down to **cluster-registration-url**
3. Click the row to edit it
4. Paste the URL you copied from Rancher
5. Click **Save**

Harvester initiates the connection to Rancher in the background. It deploys a Rancher agent into the cluster and registers itself. This takes 1-3 minutes.

Verify the Import
===

Switch back to the [button label="Rancher UI" variant="success"](tab-1) tab and watch the cluster in **Virtualization Management**.

The cluster goes through: `Pending` → `Waiting` → `Active`.

Once it shows `Active`, verify from the terminal:

```bash,run
curl -sk \
  -H "Authorization: Bearer $(agent variable get RANCHER_TOKEN)" \
  "$(agent variable get RANCHER_URL)/v3/clusters?name=harvester" \
  | jq -r '.data[0].state'
```

`active` confirms the import is complete. Rancher Prime now manages the SUSE Virtualization cluster.

Click **Check** to continue.
