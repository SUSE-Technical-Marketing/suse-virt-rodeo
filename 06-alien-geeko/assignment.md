---
slug: alien-geeko
id: agk1nostr0m01
type: challenge
title: AeroGrid NOC Dashboard — Activate alien-geeko
teaser: Deploy alien-geeko on the check-in cluster and open the AeroGrid NOC tab to watch live cluster vitals
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
- id: tab-nostromo
  title: AeroGrid NOC
  type: service
  hostname: cloud-client
  path: /
  port: 92
difficulty: basic
timelimit: 2400
enhanced_loading: null
---

> **OPS BRIEF:** AeroGrid Network Operations Center | Priority: High | Assigned: Infrastructure Team
> The `checkin-cluster` is running but the NOC has no visibility into it. Deploy the `alien-geeko` NOC dashboard, expose it via LoadBalancer, and set the instance name to `AEROGRID-NOC-TERMINAL-1`.

The `checkin-cluster` provisioned in the previous challenge is live, but dark. The AeroGrid NOC can see it in the Rancher cluster list, but has no live view of its node count, architecture, Kubernetes version, or load. The NOC dashboard must go up before the portal is considered operational.

**alien-geeko** is a Node.js application that queries the Kubernetes API at runtime and renders live cluster vitals. It was built for the KubeCon booth demo and runs on every cluster in a multi-site SUSE Edge fleet. It needs only a service account and the K8s API. No databases. No external dependencies.

Once deployed, the [button label="AeroGrid NOC" variant="success"](tab-3) tab opens the NOC dashboard and shows `checkin-cluster`'s live vitals: node count, OS, K8s version, CPU, memory, and load average.

Connect to the Check-In Cluster
===

The cluster kubeconfig was saved in the previous challenge. Connect to it now:

```bash,run
export KUBECONFIG=/root/.kube/checkin-cluster.yaml
kubectl get nodes
```

You should see the K3s worker node provisioned on SUSE Virtualization. Now deploy the NOC dashboard on it.

TASK: Deploy the NOC Dashboard
===

Apply the manifest stack in order. Each block is a distinct component of the dashboard deployment.

**Step 1 — Create the namespace:**

```bash,run
kubectl apply -f - << 'EOF'
apiVersion: v1
kind: Namespace
metadata:
  name: alien-geeko
  labels:
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/warn: restricted
EOF
```

**Step 2 — Assign the service account and read permissions:**

```bash,run
kubectl apply -f - << 'EOF'
apiVersion: v1
kind: ServiceAccount
metadata:
  name: alien-geeko
  namespace: alien-geeko
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: alien-geeko-reader
rules:
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get", "list"]
  - nonResourceURLs: ["/version"]
    verbs: ["get"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: alien-geeko-reader
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: alien-geeko-reader
subjects:
  - kind: ServiceAccount
    name: alien-geeko
    namespace: alien-geeko
EOF
```

**Step 3 — Set the cluster display name. This is the name that appears on the NOC dashboard:**

```bash,run
kubectl apply -f - << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: alien-geeko-config
  namespace: alien-geeko
data:
  CLUSTER_NAME: "AEROGRID-CHECKIN-01"
EOF
```

**Step 4 — Deploy the dashboard application and expose it via the IP pool:**

```bash,run
kubectl apply -f - << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: alien-geeko
  namespace: alien-geeko
  labels:
    app: alien-geeko
spec:
  replicas: 1
  selector:
    matchLabels:
      app: alien-geeko
  template:
    metadata:
      labels:
        app: alien-geeko
    spec:
      serviceAccountName: alien-geeko
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        runAsGroup: 1000
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: alien-geeko
          image: docker.io/avaleror/alien-geeko:latest
          ports:
            - containerPort: 3000
          env:
            - name: NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: CLUSTER_NAME
              valueFrom:
                configMapKeyRef:
                  name: alien-geeko-config
                  key: CLUSTER_NAME
          resources:
            requests:
              cpu: 25m
              memory: 32Mi
            limits:
              cpu: 100m
              memory: 64Mi
          livenessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 10
            periodSeconds: 30
          readinessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 10
          securityContext:
            allowPrivilegeEscalation: false
            capabilities:
              drop: ["ALL"]
      tolerations:
        - key: node-role.kubernetes.io/control-plane
          operator: Exists
          effect: NoSchedule
---
apiVersion: v1
kind: Service
metadata:
  name: alien-geeko
  namespace: alien-geeko
spec:
  selector:
    app: alien-geeko
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 3000
EOF
```

Wait for the dashboard to come online:

```bash,run
kubectl rollout status deployment/alien-geeko -n alien-geeko
```

TASK: Open the NOC Dashboard Tab
===

The dashboard is running. Port-forward it to the NOC tab so the AeroGrid team has live cluster visibility.

```bash,run
kubectl port-forward -n alien-geeko svc/alien-geeko 92:80 --address=0.0.0.0 &
```

> [!NOTE]
> The `&` runs the port-forward in the background. Keep this terminal session alive — if you close it, the connection drops and the NOC tab goes dark.

Open the [button label="AeroGrid NOC" variant="success"](tab-3) tab.

The dashboard displays `checkin-cluster`'s live vitals:
- Node count and hardware architecture
- Kubernetes distribution and version
- Memory, CPU, and load average per node
- The cluster display name from the ConfigMap

This is alien-geeko — the same application used in the KubeCon booth demo, now running on a K3s cluster that lives inside SUSE Virtualization, managed by Rancher, with a LoadBalancer IP pulled from `rodeo-ippool`.

TASK: Set the NOC Terminal Instance Name
===

The NOC needs a specific instance ID in the dashboard display. Update the ConfigMap to `AEROGRID-NOC-TERMINAL-1`:

```bash,run
kubectl patch configmap alien-geeko-config -n alien-geeko \
  --patch '{"data":{"CLUSTER_NAME":"AEROGRID-NOC-TERMINAL-1"}}'
```

Restart the dashboard to pick up the new name:

```bash,run
kubectl rollout restart deployment/alien-geeko -n alien-geeko
kubectl rollout status deployment/alien-geeko -n alien-geeko
```

Refresh the [button label="AeroGrid NOC" variant="success"](tab-3) tab. The dashboard now identifies this instance as `AEROGRID-NOC-TERMINAL-1`.

Verify the IP Pool Connection
===

Check the LoadBalancer IP the dashboard received from `rodeo-ippool`:

```bash,run
kubectl get svc alien-geeko -n alien-geeko
```

The `EXTERNAL-IP` is an address from `rodeo-ippool` (`192.168.122.200-220`) — the same pool created in challenge 01. The full chain connects: IP pool on the platform, LoadBalancer on the check-in cluster, live vitals in the NOC tab.

Verify the dashboard health endpoint:

```bash,run
LB_IP=$(kubectl get svc alien-geeko -n alien-geeko \
  -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl -s http://$LB_IP/health
```

The Full Stack
===

In the [button label="Rancher UI" variant="success"](tab-1) tab, look at **Cluster Management**:

- `local` — SUSE Virtualization HCI: 3 nodes, Longhorn storage, Kube-OVN network isolation
- `checkin-cluster` — provisioned by Rancher, running as a VM on the platform, NOC dashboard live

The entire stack from hardware to application:

```
Bare metal (3 nodes)
  └── SUSE Virtualization (KubeVirt + Longhorn + Kube-OVN)
        └── checkin-cluster VM (K3s, provisioned by Rancher)
              └── alien-geeko (NOC dashboard, LoadBalancer via rodeo-ippool)
                    └── Port-forward → NOC tab (port 92)
```

Every component is open source. Every component is SUSE-supported. No VMware. No Broadcom invoice. AeroGrid's platform is live.

Click **Check** to complete the rodeo.
