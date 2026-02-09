---
slug: susevirt-demo
id: pzlmzjxdinvy
type: challenge
title: SUSE Virtualization Instructor Demo
teaser: A short description of the challenge.
notes:
- type: text
  contents: Replace this text with your own text
tabs:
- id: ebf19afbk0oy
  title: Terminal
  type: terminal
  hostname: cloud-client
  cmd: bash
- id: nyg1vpny72ri
  title: Rancher UI
  type: service
  hostname: cloud-client
  path: /
  port: 91
- id: vx5ityanhzzh
  title: Harvester UI
  type: service
  hostname: cloud-client
  path: /
  port: 90
- id: e2fo5fgufkcx
  title: Terminal - HIAB
  type: terminal
  hostname: cloud-client
  cmd: bash -c "gcloud compute ssh harvester1 --zone=us-central1-a"
difficulty: ""
timelimit: 28800
enhanced_loading: null
---

Log in to Rancher Prime
=====

Let's open the [button label="Rancher" variant="success"](tab-1) tab.

Log in to Rancher Prime, if necessary, with the following credentials:

- Username:

```txt
admin
```

- Password:

```txt
[[ Instruqt-Var key="RANCHER_PASSWORD" hostname="cloud-client" ]]
```

Log in to Harvester
=====

- Username:

```txt
admin
```

- Password:

```txt
Portworx123!
```


Accessing both environment's with kubectl
=====

There are currently 4 contexts configured in ~/.kube/config

- **local** The downloaded kubeconfig from the rancher UI
- **rancher** The RKE2 instance running on util3 which hosts rancher
- **susevirt** The downloaded kubeconfig from the installed susevirt cluster
- **harvester-through-rancher** Connects using the harvester bearer token to the harvester cluster through the rancher API (port 30002)

It can be configured by running:
```bash
k config set-credentials rancher-bearer --token=$RANCHER_TOKEN
k config set-cluster susevirt-through-rancher --server=https://$HARVESTER_NAT_IP:30002/k8s/clusters/$(k --context rancher get clusters.provisioning.cattle.io harvester -n fleet-default -o yaml | yq -r .status.clusterName) --insecure-skip-tls-verify=true
k config set-context susevirt-through-rancher --cluster susevirt-through-rancher --user rancher-bearer
k config use-context susevirt-through-rancher
```



Environment Information
=====

Some variables and functions that are used in the setup script are not present in the operating environment you are running here, this is by design, but if you want to run code snipets (such as the the code found in the Rancher Installation Information) it is helpful to set up a couple of extra environment variables and aliases:


```bash
alias log=echo
alias debug=echo
alias logv2=echo
```

Most variables for your running environment have been added to `.bashrc`


Networking Information
=====


### Ip addresses

This lab uses a cluster-in-a-box configuration. There is a single GCP instance running a libvirt/kvm hypervisor. The DNS name for this lab is: [[ Instruqt-Var key="HARVESTER_DNS" hostname="cloud-client" ]] and the IP address is: [[ Instruqt-Var key="HARVESTER_NAT_IP" hostname="cloud-client" ]]


The following VMs are running on this host machine:
- harvester1 - `192.168.122.11/24` rancher:Password1
- harvester2 - `192.168.122.12/24` rancher:Password1
- harvester3 - `192.168.122.13/24` rancher:Password1
- util3 - `192.168.122.9/24` ubuntu:Password1

The dns and gw for this subnet are both `192.168.122.1`

You can access the cluster-in-a-box vm by running:

```bash
gcloud compute ssh ${HARVESTER_INSTANCE_NAME} \
  --zone=$ZONE1
```

once logged in, you can ssh to any of the above VMs

This machine has a libvirtd firewall hook that creates a port forward to internal resources.

- `8443:192.168.122.11:443` - Connects to harvester1 https
- `8080:192.168.122.11:80` - Connects to harvester1 http
- `6443:192.168.122.11:6443` - Connects to the harvester1 kube API
- `7443:192.168.122.9:443` - connects to the ingress of the RKE2 instance (unused)
- `7080:192.168.122.9:80` - connects to the ingress of the RKE2 instance (unused)
- `9443:192.168.122.9:6443` - connects to the RKE2 instance that hosts rancher prime
- `30001:192.168.122.9:30001` - connects to the rancher UI (http)
- `30002:192.168.122.9:30002` - connects to the rancher UI (https)

### DNS

We are using DNSMASQ included with libvirt. I currently have the following entries (which are of course in the host file of the cluster-in-a-box)

```
192.168.122.9 rancher.lab.local
```

### UI Access information

Access to the Rancher console is currently configured using a local nginx proxy running the stream module with the following configuration.

```
stream {
    upstream harvester_servers_http {
        least_conn;
        server ${HARVESTER_NAT_IP}:30001 max_fails=3 fail_timeout=5s;
    }
    server {
        listen 91;
        proxy_pass harvester_servers_http;
    }
}
```

Which connects to a node port on util3:
```
apiVersion: v1
kind: Service
metadata:
  name: rancher-np
  namespace: cattle-system
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 30001
  - name: https-internal
    port: 443
    protocol: TCP
    targetPort: 444
    nodePort: 30002
  selector:
    app: rancher
  sessionAffinity: None
  type: NodePort
```

This means that pointing an instruqt tab to port 91 of the `cloud-client` will access the rancher UI


Harvester access is also using a local nginx proxy using the following configuration:
```
server {
    listen 90;
    server_name _;

    location / {
        proxy_pass https://${HARVESTER_NAT_IP}:8443;

        # Disable SSL verification (since backend uses self-signed cert)
        proxy_ssl_verify off;
        proxy_ssl_server_name on;

        # Preserve client request info
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        proxy_connect_timeout 10s;
        proxy_read_timeout 60s;
        proxy_send_timeout 60s;
    }

    access_log /var/log/nginx/harvester_access.log;
    error_log  /var/log/nginx/harvester_error.log;
}
```

which means that pointing an instruqt tab to port 90 of the `cloud-client will access the harvester UI

Note that the above tabs have already been configured.


Rancher Installation Information
=====

Rancher was installed and configured using the following script:

```bash
  # Let's set the rancher bootstrap password to a known value
  RANCHER_BOOTSTRAP_PASSWORD=Password1
  # It is only used in this section so we don't need to export or make it global



  kubectl config use-context rancher
  helm repo add rancher-prime https://charts.rancher.com/server-charts/prime
  helm repo update

  # remove a previous bad install attempt
  helm uninstall rancher --namespace cattle-system

  helm install rancher rancher-prime/rancher \
    --namespace cattle-system \
    --set hostname=$HARVESTER_RANCHER_INT_DNS \
    --set replicas=1 \
    --set bootstrapPassword=$RANCHER_BOOTSTRAP_PASSWORD

  #Create a seprate nodeport service:
  cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: rancher-np
  namespace: cattle-system
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 30001
  - name: https-internal
    port: 443
    protocol: TCP
    targetPort: 444
    nodePort: 30002
  selector:
    app: rancher
  sessionAffinity: None
  type: NodePort
EOF


# We don't have a seperate wait-ready function, so we just need to sleep
sleep 180

# Let's set the rancher password to a known value


	RANCHER_RESPONSE=`curl -s "https://${HARVESTER_NAT_IP}:30002/v3-public/localProviders/local?action=login" -H 'content-type: application/json' --data-binary "{\"username\":\"admin\",\"password\":\"$RANCHER_BOOTSTRAP_PASSWORD\"}" --insecure`

	debug "RANCHER_RESPONSE: $RANCHER_RESPONSE"

  # Extract the API token from the response
  RANCHER_TOKEN=`echo $RANCHER_RESPONSE | jq -r .token`
  debug "RANCHER_TOKEN: $RANCHER_TOKEN"

  # Add the token to our BASHRC file
  add_bashrc "export RANCHER_TOKEN=${RANCHER_TOKEN}"

    # Change the password to the one provided in the global vars section
  curl -s "https://${HARVESTER_NAT_IP}:30002/v3/users?action=changepassword" -H 'content-type: application/json' -H "Authorization: Bearer $RANCHER_TOKEN" --data-binary "{\"currentPassword\":\"$RANCHER_BOOTSTRAP_PASSWORD\",\"newPassword\":\"$RANCHER_PASSWORD\"}" --insecure

  kubectl config use-context susevirt

  logv2 "Installing Rancher on Harvester in a box VM" phase="END"
```