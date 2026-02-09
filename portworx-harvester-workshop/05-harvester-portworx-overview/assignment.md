---
slug: harvester-portworx-overview
id: eu8fvp8sytmr
type: challenge
title: SUSE Virtualization - Portworx Overview
teaser: Overview of Portworx and Kubevirt Storage basics
tabs:
- id: qb6uoe5rxt6s
  title: Terminal
  type: terminal
  hostname: cloud-client
  cmd: su - root
- id: ioqbebe5ywu6
  title: Rancher UI
  type: service
  hostname: cloud-client
  path: /
  port: 91
- id: lvy0y4n1jwmr
  title: Harvester UI
  type: service
  hostname: cloud-client
  path: /
  port: 90
difficulty: basic
timelimit: 28800
enhanced_loading: null
---

Editor's Notes
=====
This assignment should be written by Portworx. It is completed

SUSE® Virtualization is a modern, open, interoperable, hyperconverged infrastructure (HCI) solution built on Kubernetes. It is an open-source alternative designed for operators seeking a cloud-native HCI solution. SUSE Virtualization runs on bare metal servers and provides integrated virtualization and distributed storage capabilities. In addition to traditional virtual machines (VMs), SUSE Virtualization supports containerized environments automatically through integration with SUSE® Rancher Prime. It offers a solution that unifies legacy virtualized infrastructure while enabling the adoption of containers from core to edge locations.

In this lab, we are going to learn how Portworx can be used to provide storage for VMs running on SUSE Virtualization.

We will cover Portworx and Kubevirt storage concepts, and learn how to perform both provisioning and day-2 operations on VMs running on SUSE Virtualization.


Connecting to SUSE Virtualization
=====

In this lab, we will be interacting with SUSE Virtualization using SUSE Rancher Prime. Rancher Prime provides a unified interface for managing Kubernetes clusters, including SUSE Virtualization.

### Logging in to the Rancher Prime UI

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

### Accessing the SUSE Virtualization Cluster

From the Rancher Prime UI, select the `Virtualization Management` menu item from the left-hand menu. Then select the `harvester` cluster from the menu

![01-connect_to_cluster.gif](../assets/01-connect_to_cluster.gif)

### The SUSE Virtualization UI

It is also possible to log in to SUSE Virtualization using the built in management interface. Although we will not be using this interface in this lab, it is available for your reference.

Let's open the [button label="Harvester UI" variant="success"](tab-2) tab.

Log in to Rancher Prime, if necessary, with the following credentials:

- Username:

```txt
admin
```

- Password:

```txt
Portworx123!
```

### The Command Line Interface

This lab has also been configured with a command line interface. Kubectl has been pre-configured to connect to the SUSE Virtualization cluster.

Let's open the [button label="Terminal" variant="success"](tab-0) tab.

Run the following command to test connectivity:

```bash,run
kubectl get nodes
```

Portworx on SUSE Virtualization Overview
=====

## The Portworx Storage Cluster

Portworx Enterprise is a cloud native storage and data management platform for Kubernetes that is designed to enable enterprises manage storage for their containerized stateful applications across various infrastructure environments.

Because SUSE Virtualization is based on Kubernetes, it can take advantage of the many capabilities provided by Portworx Enterprise.

Let's start by getting to know the Portworx cluster that is providing storage services for our SUSE virtualization cluster.

Run the following command to view the Portworx cluster status:
```bash,run
pxctl status --color
```
Notice that we can see our 3 nodes are online and part of the storage cluster. We can also see that there is a global storage pool available for use by our VMs.

We can also see information about our configured disk devices.

The configuration of the Portworx storage cluster is managed by an Operator and configured by a custom resource definition (CRD). Let's take a look at the CRD that is used to configure the Portworx storage cluster.

We can see the metadata of the CRD by running:

```bash,run
kubectl -n portworx get storageclusters.core px-cluster -o yaml | yq4 .metadata
```

And the configuration specifics by running:
```bash,run
kubectl -n portworx get storageclusters px-cluster -o yaml | yq4 .spec
```

Many of the above configuration parameters can be modified. For example, we can upgrade a Portworx cluster by simply changing the image tag in the CR and the operator will take care of the rest!

## Storage Classes

Storage classes are the way that Kubernetes defines "templates" for storage. When a persistent volume claim (PVC) is created, a storage class is specified to define the characteristics of the storage that is requested.

Portworx uses storage classes to define the characteristics of the storage that is provided to Kubernetes workloads which include VMs. Portworx extends the options of the storage class by providing parameters that are specific to Portworx.

Let's look at the configuration parameters of the `px-csi-vm` storage class that is used to provide storage for VMs.

```bash,run
kubectl get sc px-csi-vm -o yaml
```

The parameters define what configurations will be used when creating a new volume. For example, `repl` defines the number of replicas that are created for each volume. In this case, we are creating 2 replicas for each volume.

A full list of parameters can be found in the [Portworx documentation](https://docs.portworx.com/portworx-enterprise/provision-storage/create-pvcs/dynamic-provisioning). For now, we can use the `px-csi-vm` storage class that was created for us.


Kubevirt Storage Concepts
=====

Kubevirt (and more specifically, the [containerized data importer](https://github.com/kubevirt/containerized-data-importer)) adds some additional CRDs that provide some useful features for managing data volumes for VMs. Let's take a look at some of the key concepts.

## Data Volumes

One of the most common use cases for virtual machines is template based provisioning. It is rare that anyone installs a new VM using an ISO, instead we create templates that our users can clone from. Kubernetes doesn't have built in support for cloning (at least in the way we need it), and why would they? A PV attached to a container is only storing the unique persistent data. The image the container runs is stored elsewhere in a registry.

Data volumes solve this problem by providing an abstraction on top of Persistent Volume Claims (PVCs) that allows declarative image management.

Data volumes are deployed as a Kubernetes custom resource definition (CRD). The CRD is called `DataVolume` and is part of the `kubevirt.io` API group. Let's take a look at the definition of a DataVolume:

```yaml
apiVersion: cdi.kubevirt.io/v1beta1
kind: DataVolume
metadata:
  name: vm-root
  namespace: default
spec:
  source:
    http:
      url: "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
  storage:
    volumeMode: Block
    storageClassName: px-csi-vm
    accessModes:
      - ReadWriteMany
    resources:
      requests:
        storage: 10Gi
```

Notice that the `DataVolume` specifies a `source` and a `storage` section. The `source` section defines where the data for the volume comes from. In this case, we are using an HTTP URL to download the image. The `storage` section defines the storage class and size of the volume. Applying the above `DataVolume` will create a new volume and download the image from the specified URL. It is possible to have a blank source (which just creates a PVC) as well as a source that clones an existing PVC.

There is no need to apply the above manifest now, we will have lots of practice deploying virtual machines later.

## Storage Profiles

In the above `DataVolume` example, we specified a few parameters to tell the CSI driver what sort of storage we wanted, but what if we don't know what storage parameters are available? Or maybe we would like to set some defaults for our users? This is the job of the Storage Profile.
Storage Profile is the resource that serves the information about recommended parameters for the PVC.

This can be used by CDI controllers when creating a PVC for DV. That way the DataVolume can be simplified and if the properties are missing, defaults can be applied from the StorageProfile.

Storage profiles are automatically created when a new storage class is created. It will use a set of default parameters provided by the CDI operator, but the values can be overridden.

Let's look at the configuration parameters of the `px-csi-vm` storage profile that is used to provide storage for VMs.

```bash,run
kubectl get storageprofile px-csi-vm -o yaml
```

Notice that our `.spec` node is blank. This means that the defaults provided by the CDI operator are being used. These defaults can be viewed in the `.status` node.

Most notably, the ClaimPropertySets define the access modes and volume modes that are supported by the storage profile. In this case, we are using `ReadWriteMany` access mode and `Block` volume mode.

This means that all new volumes created using the `px-csi-vm` storage profile will be created with 2 replicas and will support `ReadWriteMany` access mode and `Block` volume mode.


> [!NOTE]
> RWX block volumes are essential for VM storage as it allows for live migration of VMs between nodes.



That's it for this lesson! Click the `Check` button to move on!