---
slug: networking
id: net1vlan0vpc1
type: challenge
title: AeroGrid Network Topology — VLANs and Airline Isolation
teaser: Build the AeroGrid backbone VLAN and isolate airline tenant networks so passenger data never crosses carrier boundaries
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
difficulty: basic
timelimit: 2400
enhanced_loading: null
---

> **OPS BRIEF:** AeroGrid Network Operations Center | Priority: High | Assigned: Infrastructure Team
> Three airlines share AeroGrid infrastructure. Each one needs their traffic completely isolated. Create VLAN 100 as the ramp control backbone, then set up two airline tenant zones with no traffic crossing between them.

AeroGrid hosts three airlines on the platform. Each airline's passenger data, check-in systems, and ground ops traffic must be completely separated. Under VMware + NSX, this meant NSX micro-segmentation policies, distributed firewall rules, and a dedicated NSX license. On SUSE Virtualization, it is two kubectl manifests.

AeroGrid's Networking Stack
===

SUSE Virtualization uses two technologies that cover the full spectrum from basic VLAN segmentation to enterprise SDN:

| Layer | Technology | Use case | VMware equivalent |
|-------|-----------|----------|-------------------|
| L2 / VLAN bridging | Multus | Ramp control backbone VLAN, VM attachment | Distributed Switch |
| SDN / isolated zones | Kube-OVN | Airline tenant isolation | NSX micro-segmentation |

**Multus** attaches multiple network interfaces to a VM and bridges them to physical VLANs on the host. This is how you put airport operations systems on a dedicated ramp control VLAN.

**Kube-OVN** (v1.15.4 in this release) runs in **non-primary CNI mode** — it owns VM overlay and VPC traffic only, while the management bridge handles pod networking. This is a cleaner separation than older versions and means Kube-OVN's isolated subnets are purely for VM workloads. It adds a full Software-Defined Networking layer with isolated subnets, NAT gateways, and support for **overlapping CIDR ranges**. Two airline tenants can each use `10.0.0.0/24` in their own zone with no traffic crossing between them. Complete isolation, even with shared address space.

Check the current network state:

```bash,run
kubectl get network-attachment-definitions -n default
```

You should see `vmnet` from the previous challenge. That is the untagged management bridge. Now we add the ramp control backbone and the airline isolation zones.

TASK: Create the AeroGrid Ramp Control Backbone VLAN
===

VLAN 100 is AeroGrid's ramp control backbone. It tags traffic separately from the management bus. Any upstream switch port connected to the cluster nodes must have VLAN 100 trunked for real external connectivity.

In the [button label="Harvester UI" variant="success"](tab-2) tab:

1. Go to **Networks > VM Networks** > **Create**
2. Set:
   - **Name:** `vlan100`
   - **Type:** `L2VlanNetwork`
   - **Cluster Network:** `mgmt`
   - **VLAN ID:** `100`
3. Click **Create**

Verify:

```bash,run
kubectl get network-attachment-definitions vlan100 -n default -o yaml | grep -A5 config
```

You should see `"vlanId": 100` in the CNI config. The ramp control backbone is live on VLAN 100.

TASK: Create Airline Tenant Isolation Zones
===

AeroGrid needs two isolated network zones for airline tenants. Each zone must be air-gapped from the outside and from each other. In SUSE Virtualization, this is a Kube-OVN subnet with `natOutgoing: false` and `private: true`.

> [!NOTE]
> This is the NSX micro-segmentation equivalent — but it is two kubectl manifests, not an NSX license, a micro-segmentation policy, and a distributed firewall rule set.

Create the first airline tenant zone (SkyWave Airlines):

```bash,run
cat << EOF | kubectl apply -f -
apiVersion: kubeovn.io/v1
kind: Subnet
metadata:
  name: containment-alpha
spec:
  cidrBlock: "172.16.0.0/24"
  gateway: "172.16.0.1"
  excludeIps:
    - "172.16.0.1"
  protocol: IPv4
  natOutgoing: false
  private: true
EOF
```

Create the second airline tenant zone (NordAir) — same CIDR, completely isolated from the first. This demonstrates the overlapping CIDR capability that Kube-OVN provides:

```bash,run
cat << EOF | kubectl apply -f -
apiVersion: kubeovn.io/v1
kind: Subnet
metadata:
  name: containment-beta
spec:
  cidrBlock: "172.16.0.0/24"
  gateway: "172.16.0.1"
  excludeIps:
    - "172.16.0.1"
  protocol: IPv4
  natOutgoing: false
  private: true
EOF
```

> [!NOTE]
> Kube-OVN v1.15 (non-primary CNI mode) handles overlapping CIDRs via VPC isolation. If the command above returns a validation error about duplicate CIDRs, use `172.16.1.0/24` for `containment-beta` instead — the isolation demonstration still holds, just with different addresses.

Verify both airline tenant zones are live with no outgoing NAT:

```bash,run
kubectl get subnets.kubeovn.io -o custom-columns=NAME:.metadata.name,CIDR:.spec.cidrBlock,NAT:.spec.natOutgoing
```

Both subnets exist at `172.16.0.0/24` with `natOutgoing: false`. Kube-OVN separates the traffic via overlay — neither airline zone can reach the other, and neither has a path to the outside.

> [!IMPORTANT]
> SkyWave Airlines and NordAir are now fully isolated. They share the same IP space, but their traffic never crosses. This is the NSX capability AeroGrid was paying for — now running on open-source Kube-OVN.

Full Network Inventory
===

List the complete network topology:

```bash,run
kubectl get network-attachment-definitions -n default && \
kubectl get subnets.kubeovn.io
```

You should have:
- `vmnet` — untagged management bridge (challenge 01)
- `vlan100` — VLAN 100 ramp control backbone (this challenge)
- `containment-alpha` and `containment-beta` — isolated Kube-OVN airline tenant zones with no external access (this challenge)

Click **Check** to continue.
