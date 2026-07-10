---
slug: a-new-horizon-whats-next
id: qzmycpm7jtwa
type: challenge
title: "\U0001F305 Chapter 9 — A New Horizon"
teaser: The bank runs entirely on SUSE Virtualization. Take a victory lap, review
  everything you mastered, and chart where your new skills can take your own datacenter.
tabs:
- id: jw4tji5y1jbv
  title: SUSE Virtualization UI
  type: service
  hostname: kvm-host
  path: /
  port: 8443
  protocol: https
- id: gjstzqppnxay
  title: Cluster Terminal
  type: terminal
  hostname: kvm-host
- id: ohjx4w0pk1mb
  title: Rancher Prime UI
  type: service
  hostname: kvm-host
  port: 30002
  protocol: https
difficulty: basic
timelimit: 1800
enhanced_loading: null
---

🌅 Chapter 9 — A New Horizon
============================

<style type="text/css">
  * {
    font-family: suse;
    src: url('https://fonts.google.com/specimen/SUSE');
  }
  .suse { color: #30ba78; }
  .virt { color: #30ba78; }
  .bank { color: #d4af37; }
  .hovereffect {
    border-radius: 25px 25px 25px 25px;
    background: linear-gradient(#30ba78 0 0) var(--hundredpercent, 0) / var(--hundredpercent, 0) no-repeat;
    transition: 0.5s, background-position 0s;
    padding: 5px;
  }
  .hovereffect:hover {
    --hundredpercent: 100%;
    color: white;
    border-radius: 10px 25px 10px 25px;
  }
  .storybox {
    border-left: 5px solid #d4af37;
    border-radius: 0 15px 15px 0;
    background: linear-gradient(135deg, rgba(48,186,120,.10), rgba(212,175,55,.10));
    padding: 15px 20px;
    margin: 15px 0;
  }
  .storybox em { color: #d4af37; }
  .missionbox {
    border: 2px dashed #30ba78;
    border-radius: 15px;
    padding: 12px 18px;
    margin: 15px 0;
  }
  .highlightcopy { color: white; font-weight: bold; padding: 0 10px; }
  img.logos { border-radius: 10px; }
</style>

<div class="storybox">

The dust has finally settled. The datacenter is quiet, bathed in the soft green glow of the <b class="virt">SUSE Virtualization</b> nodes operating in perfect harmony.

<b class="bank">Vertex Trust Bank</b> is no longer shackled to the past. It is now running entirely on a lean, high-performance, cloud-native virtualization stack.

Sarah stands beside you, looking at the unified dashboard on the main screen. *"I didn't think it was possible,"* she admits, shaking her head in disbelief. *"We are running containerized microservices and monolithic ledgers on the exact same fabric. Our storage is distributed, our networks are software-defined, and our licensing costs have just plummeted."*

She turns to you and extends her hand. *"Thank you. You didn't just save our infrastructure — you saved the bank."*

</div>

## <b class="hovereffect">🏆 Your Deeds, Architect</b>

You conquered incredible odds during your time here:

| Chapter | Crisis | Skill you mastered |
|:--------|:-------|:-------------------|
| 🏦 The Arrival | A drowning legacy datacenter | Inspecting the platform via dashboard, Longhorn, and `kubectl` |
| 🛗 The Subterranean Divide | Two warring hardware silos | Uniting VMs and containers on one Kubernetes fabric |
| ⚡ The Flash Crash | A market meltdown | Deploying VMs in minutes with images, volumes, and cloud-init |
| 🌊 The Rising Tide | A flooded server rack | Zero-downtime live migration and resource management |
| 🕵️ The Invisible Intruder | A lateral attack path | Software-defined VLANs, network policies, and private SDN subnets |
| ⏪ The Unthinkable Error | A deleted $100M record | Snapshots, safe staging clones, and non-destructive restores |
| 🤠 The Stampede | A compute famine | Infrastructure as code — scaling fleets with Terraform |
| ⚔️ The Final Showdown | A vendor holding the bank hostage | Live extraction from VMware and guest telemetry |

Your work at <b class="bank">Vertex Trust Bank</b> is complete — but the digital frontier is vast and constantly evolving. There are always new architectures to design and new systems to modernize.

🧭 Victory lap — the lab is still yours
=======================================

The lab environment will remain active until your timer expires. Feel free to explore the dashboard and experiment with the infrastructure you have built. Some ideas:

- **Take a final inventory of the empire you built**, in the [button label="Cluster Terminal" variant="success"](tab-1):

```bash,run
kubectl get vm -A && kubectl get network-attachment-definitions -A && kubectl get virtualmachinesnapshots -A
```

- **Design your own crisis.** Create a new VM from scratch in the [button label="SUSE Virtualization UI" variant="success"](tab-0) — pick the image, size it, cloud-init it, snapshot it, live-migrate it. No instructions this time. You know the way.

- **Peek at the monitoring stack** that has been watching over you all along:

```bash,run
kubectl get pods -n cattle-monitoring-system | head -10
```

🏗️ Epilogue Quest — Sarah's last request (optional)
====================================================

<div class="storybox">

You are halfway to the elevator when Sarah catches up with you, tablet in hand. *"One more thing, Architect. The mobile banking team saw what you built. They want their own Kubernetes cluster for the new customer portal — and they want it running **on** this platform, not beside it. Can it do that?"*

You smile. This is where <b class="virt">SUSE Virtualization</b> stops being a hypervisor replacement and becomes a **cloud**.

</div>

When **Rancher Prime** manages <b class="virt">SUSE Virtualization</b>, it treats the platform as a cloud provider — identical to how it talks to AWS, Azure, or GCP. You can provision full Kubernetes clusters on the bank's own hardware with the same workflow the cloud teams already use.

**Step 1 — A project for the team.** Rancher uses **Projects** to group namespaces and apply RBAC at scale. In the [button label="Rancher Prime UI" variant="success"](tab-2):

1. Navigate to your cluster > **Projects/Namespaces**
2. Click **Create Project**, name it <b class="highlightcopy">retail-banking</b>
3. Under **Members**, add `admin` with the role **Project Member** (in production you would add the actual portal team)
4. Click **Create**

**Step 2 — The cloud credential.** Rancher needs permission to create VMs on the platform:

1. Top-right user menu > **Cloud Credentials** > **Create**
2. Select **Harvester**
3. Name it <b class="highlightcopy">vertex-harvester</b> and select the imported cluster
4. Click **Create**

**Step 3 — Provision the portal cluster.** Still in the Rancher Prime UI:

1. Go to **Cluster Management** > **Create** and select **RKE2/K3s**
2. Under **Infrastructure**, select **Harvester**
3. Set **Cluster Name** to <b class="highlightcopy">vertex-mobile</b>, pick the latest K3s version, and choose the `vertex-harvester` credential
4. Configure the node pool: **1** machine, namespace `default`, the openSUSE Leap image from your **Images** page, `2` CPU / `4 GiB` memory / `40 GiB` disk, network `default/vmnet`, SSH user `opensuse`
5. Under the cluster add-ons, enable the **Harvester CSI Driver** (Longhorn-backed persistent volumes) and the **Harvester Cloud Provider** (LoadBalancer services from your IP pool)
6. Click **Create**

Watch the platform build a cluster inside itself from the [button label="Cluster Terminal" variant="success"](tab-1) — this takes 5–10 minutes; press `Ctrl+C` once it reports `Active`:

```bash,run
watch kubectl get clusters.provisioning.cattle.io -A
```

**Step 4 — Light up the ops dashboard.** Once `vertex-mobile` is Active, open it in Rancher's **Cluster Explorer** and launch the built-in **Kubectl Shell** (`>_` icon, top right). Deploy the bank's ops dashboard — a tiny Node.js app that reads the cluster API and renders live vitals:

```bash
kubectl create namespace vertex-ops
kubectl create serviceaccount geeko-dash -n vertex-ops
kubectl create clusterrole geeko-dash-reader --verb=get,list --resource=nodes
kubectl create clusterrolebinding geeko-dash-reader --clusterrole=geeko-dash-reader --serviceaccount=vertex-ops:geeko-dash
kubectl create configmap geeko-dash-config -n vertex-ops --from-literal=CLUSTER_NAME=VERTEX-TRUST-MOBILE-01
```

```bash
kubectl apply -f - << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: geeko-dash
  namespace: vertex-ops
  labels:
    app: geeko-dash
spec:
  replicas: 1
  selector:
    matchLabels:
      app: geeko-dash
  template:
    metadata:
      labels:
        app: geeko-dash
    spec:
      serviceAccountName: geeko-dash
      containers:
        - name: geeko-dash
          image: docker.io/avaleror/alien-geeko:latest
          ports:
            - containerPort: 3000
          env:
            - name: CLUSTER_NAME
              valueFrom:
                configMapKeyRef:
                  name: geeko-dash-config
                  key: CLUSTER_NAME
          resources:
            requests:
              cpu: 25m
              memory: 32Mi
            limits:
              cpu: 100m
              memory: 64Mi
---
apiVersion: v1
kind: Service
metadata:
  name: geeko-dash
  namespace: vertex-ops
spec:
  selector:
    app: geeko-dash
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 3000
EOF
```

```bash
kubectl rollout status deployment/geeko-dash -n vertex-ops
kubectl get svc geeko-dash -n vertex-ops
```

The `EXTERNAL-IP` comes straight out of <b class="highlightcopy">vertex-ippool</b> (`192.168.122.200–220`) — the address reserve you funded back in Chapter 2. The loop is closed. Verify the dashboard answers, from the [button label="Cluster Terminal" variant="success"](tab-1) (replace with the external IP you saw):

```bash
curl -s http://EXTERNAL_IP/health
```

The full stack you now command:

```
Bare metal
  └── SUSE Virtualization  (KubeVirt + Longhorn + Kube-OVN)
        └── vertex-mobile  (K3s cluster, provisioned by Rancher Prime as VMs)
              └── geeko-dash  (ops dashboard, LoadBalancer IP from vertex-ippool)
```

Every layer open source. Every layer one bill. Sarah's mobile banking team gets their cloud — and it never leaves the building.

🚀 What's next on your horizon?
===============================

- 📖 Keep your skills sharp by exploring the deep technical architecture in the [SUSE Virtualization Documentation](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html).

- 🐮 Learn how to manage **fleets of these clusters at scale** — one Rancher Prime managing every SUSE Virtualization cluster in every branch datacenter — with [SUSE Rancher Prime](https://documentation.suse.com/cloudnative/rancher-manager/latest/en/rancher-manager.html).

- 🧪 Rebuild this at home: <b class="virt">SUSE Virtualization</b> is open source. Grab the ISO, install it on any spare x86 box, and your own Vertex Trust migration begins.

- 💬 Talk to your <b class="suse">SUSE</b> representative about what this story would look like with **your** legacy cluster in the darkest corner of the room.

<div class="storybox">

It has been an absolute honor working alongside you, **Architect**.

**Happy migrating!** 🎉

</div>

📚 More information
===================

- [SUSE Virtualization — Overview](https://documentation.suse.com/cloudnative/virtualization/latest/en/introduction/overview.html)
- [Creating Virtual Machines](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/create-vm.html)
- [Live Migration](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/live-migration.html)
- [Backup and Restore](https://documentation.suse.com/cloudnative/virtualization/latest/en/virtual-machines/backup-restore.html)
- [Cluster Networking](https://documentation.suse.com/cloudnative/virtualization/latest/en/networking/cluster-network.html)
