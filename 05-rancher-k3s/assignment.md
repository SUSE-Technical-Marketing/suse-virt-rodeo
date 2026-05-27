---
slug: rancher-k3s
id: rnc1rbac0k3s1
type: challenge
title: AeroGrid Check-In Portal — Provision the K3s Cluster
teaser: Set up terminal RBAC, wire Rancher to SUSE Virtualization, and provision a K3s cluster for the passenger self-service check-in portal
tabs:
- id: tab-terminal
  title: Terminal
  type: terminal
  hostname: cloud-client
  cmd: su - root
- id: tab-rancher
  title: Rancher UI
  type: service
  hostname: cloud-client
  path: /
  port: 91
- id: tab-harvester
  title: Harvester UI
  type: service
  hostname: cloud-client
  path: /
  port: 90
difficulty: intermediate
timelimit: 3600
enhanced_loading: null
---

> **OPS BRIEF:** AeroGrid Network Operations Center | Priority: High | Assigned: Infrastructure Team
> Passengers need a self-service check-in portal. Provision a K3s cluster on SUSE Virtualization via Rancher, set up project RBAC, and wire up the cloud credential before you launch.

AeroGrid passengers currently queue at staffed desks to check in and print boarding passes. That changes now. The plan is a self-service check-in portal running on Kubernetes, provisioned directly on top of the SUSE Virtualization platform. Rancher handles the full lifecycle: VM creation, OS install, CNI setup, storage wiring, and load balancer integration — all from one interface.

Rancher as the Control Plane
===

This challenge is where SUSE Virtualization goes beyond a traditional hypervisor. When Rancher Prime manages SUSE Virtualization, it treats the platform as a **cloud provider** — identical to how it talks to GCP, AWS, or Azure. That means you can provision Kubernetes clusters directly on your on-premises HCI infrastructure using the same workflow you use for cloud.

| VMware | SUSE Rancher + SUSE Virtualization |
|--------|-------------------------------------|
| vCenter + vSphere roles | Rancher RBAC + Projects |
| vSphere with Tanzu | Rancher + Harvester node driver |
| Namespace isolation | Rancher Projects |
| Identity federation | Rancher auth providers (LDAP, OIDC, SAML) |

Check the current cluster inventory before you begin:

```bash,run
kubectl get clusters.provisioning.cattle.io -A
```

You should see only the `local` cluster — the SUSE Virtualization platform itself. No application clusters yet.

TASK: Configure Project RBAC
===

Before any cluster is provisioned, access controls must be set up. Rancher uses **Projects** to group namespaces and apply RBAC at scale. A project maps to a team or department — members can only see and manage what is in their project scope.

In the [button label="Rancher UI" variant="success"](tab-1) tab:

1. Navigate to your Harvester cluster > **Projects/Namespaces**
2. Click **Create Project**
3. Set the project name to `terminal-ops`
4. Under **Members**, click **Add**
5. Add `admin` with the role **Project Member** (in production you would add actual portal team members)
6. Click **Create**

Create a dedicated namespace scoped to this project:

```bash,run
kubectl create namespace checkin-workloads
```

```bash,run
kubectl annotate namespace checkin-workloads \
  field.cattle.io/projectId=$(kubectl get projects.management.cattle.io \
    -n local -o jsonpath='{.items[?(@.spec.displayName=="terminal-ops")].metadata.name}') \
  --overwrite
```

Verify the namespace is bound to the terminal-ops project:

```bash,run
kubectl get namespace checkin-workloads -o jsonpath='{.metadata.annotations.field\.cattle\.io/projectId}'
```

TASK: Create the Cloud Credential
===

Before Rancher can provision VMs on SUSE Virtualization, it needs a credential that lets it authenticate against the Harvester API.

In the [button label="Rancher UI" variant="success"](tab-1) tab:

1. Go to the top-right user menu > **Cloud Credentials**
2. Click **Create**
3. Select **Harvester**
4. Set:
   - **Name:** `harvester-local`
   - **Cluster:** Select the imported Harvester cluster
5. Click **Create**

Verify the credential is registered:

```bash,run
curl -sk \
  -H "Authorization: Bearer $(agent variable get RANCHER_TOKEN)" \
  "$(agent variable get RANCHER_URL)/v3/cloudcredentials" \
  | jq -r '.data[].name'
```

`harvester-local` should appear. Rancher can now provision VMs on the SUSE Virtualization platform.

TASK: Provision the Check-In Portal Cluster
===

Rancher will now provision a K3s Kubernetes cluster where the nodes are VMs running on the SUSE Virtualization platform. This is the `checkin-cluster` — the dedicated environment for the AeroGrid passenger self-service portal.

In the [button label="Rancher UI" variant="success"](tab-1) tab:

1. Go to **Cluster Management** > **Create**
2. Select **RKE2/K3s**
3. Under **Infrastructure**, select **Harvester**
4. Set:
   - **Cluster Name:** `checkin-cluster`
   - **Kubernetes Version:** Latest K3s v1.33 or v1.34 (Rancher 2.14+ requires v1.32 minimum — v1.30/v1.31 are no longer listed)
   - **Cloud Credential:** `harvester-local`

5. Configure the Node Pool:
   - **Pool Name:** `agents`
   - **Machine Count:** `1`
   - **Namespace:** `default`
   - **Image:** `default/leap16`
   - **CPU:** `2`
   - **Memory:** `4 GiB`
   - **Disk:** `40 GiB`
   - **Network:** `default/vmnet`
   - **SSH User:** `opensuse`

6. Under **Cluster Configuration > Add-Ons** (Rancher 2.14: may appear as **System Services**), enable:
   - **Harvester CSI Driver** — uses Longhorn for persistent volumes
   - **Harvester Cloud Provider** — enables LoadBalancer services via the platform's IP pool

7. Click **Create**

Watch the provisioning sequence:

```bash,run
watch kubectl get clusters.provisioning.cattle.io -A
```

Rancher creates the VM on SUSE Virtualization, waits for it to come up, installs K3s via cloud-init, and registers the cluster back to Rancher. This takes 5-10 minutes.

> [!NOTE]
> Every node in `checkin-cluster` is a VM managed by SUSE Virtualization. Longhorn provides its storage. The IP pool from challenge 01 provides its load balancer addresses. The check-in portal cluster runs entirely on the AeroGrid platform.

Once the cluster shows `Active`, press `Ctrl+C`.

TASK: Retrieve the Cluster Kubeconfig
===

Fetch the kubeconfig from Rancher. You will use it in the next challenge to deploy the NOC dashboard on the check-in cluster.

```bash,run
CLUSTER_ID=$(curl -sk \
  -H "Authorization: Bearer $(agent variable get RANCHER_TOKEN)" \
  "$(agent variable get RANCHER_URL)/v3/clusters?name=checkin-cluster" \
  | jq -r '.data[0].id')

curl -sk -X POST \
  -H "Authorization: Bearer $(agent variable get RANCHER_TOKEN)" \
  "$(agent variable get RANCHER_URL)/v3/clusters/${CLUSTER_ID}?action=generateKubeconfig" \
  | jq -r .config > /root/.kube/checkin-cluster.yaml

export KUBECONFIG=/root/.kube/checkin-cluster.yaml
kubectl get nodes
```

The `checkin-cluster` is online. Its kubeconfig is saved at `/root/.kube/checkin-cluster.yaml`.

What We Have Now
===

In the [button label="Rancher UI" variant="success"](tab-1) tab, go to **Cluster Management**:

- `local` — SUSE Virtualization HCI: 3 nodes, Longhorn storage, Kube-OVN networking
- `checkin-cluster` — K3s cluster: provisioned as a VM on the platform, managed by Rancher

One Rancher instance. Two clusters. No VMware. No Broadcom invoice.

Click **Check** when `checkin-cluster` is active. The next challenge deploys the NOC dashboard.
