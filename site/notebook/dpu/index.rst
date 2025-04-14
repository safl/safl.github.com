Getting familiar with BlueField-2
=================================

I wanted to familiarize myself with DPUs and found the NVIDIA / Mellanox
BlueField-2 DPU on ebay with model number ``BF2H532C``.

For debugging it seems like it would be good to get a hold of:

* MBF35-DKIT

Host HW
=======

* Assemble parts
* Physically install the

Host FW/OS
==========

* Disable Secure Boot
* Install Ubuntu 24.04

You can manually load the drivers with ``mst start`` or set on boot via::

	systemctl enable mst.service
	systemctl start mst.service

I would recommend doing the above, otherwise the boot-process will be hanging
until timeout. With messages such as:

Now that the drivers are loaded, i see::

	10:00.0 Ethernet controller: Mellanox Technologies MT42822 BlueField-2 integrated ConnectX-6 Dx network controller (rev 01)
	10:00.1 Ethernet controller: Mellanox Technologies MT42822 BlueField-2 integrated ConnectX-6 Dx network controller (rev 01)
	10:00.2 Ethernet controller: Mellanox Technologies BlueField DPU Family Auxiliary Communication Channel [BlueField Family] (rev 01)
	10:00.3 DMA controller: Mellanox Technologies MT42822 BlueField-2 SoC Management Interface (rev 01)

That is, now there is this **new** device:

	10:00.2 Ethernet controller: Mellanox Technologies BlueField DPU Family Auxiliary Communication Channel [BlueField Family] (rev 01)

Which is probably what is needed.

Then ensure that the Mellanox drivers are loaded::

	mst start

Now devices pop up::

	ls /dev/mst/
	mt41686_pciconf0  mt41686_pciconf0.1  mt49873_pciconf0.2

Should be possible to get a login using::

	screen /dev/rshim0/console 115200

DPU
===

Default login is ``ubuntu`` / ``ubuntu``.

Change the password to something else upon first login.

Check the version::

	cat /etc/mlnx-release
	cat /etc/lsb-release
	bfb-info

I got::

	DOCA_2.0.2_BSP_4.0.3_Ubuntu_22.04-11.23-04.prod
	DISTRIB_ID=Ubuntu
	DISTRIB_RELEASE=22.04
	DISTRIB_CODENAME=jammy
	DISTRIB_DESCRIPTION="Ubuntu 22.04.3 LTS"

And the bfb-info::

	Versions:
	ATF: v2.2(release):4.0.2-37-g6b2609f
	UEFI: 4.0.2-15-g0613586
	BSP: mlxbf-bootimages <none>
	DOCA Base (OFED): 23.04-0.5.3.0
	MFT: 4.24.0-72
	DOCA: 2.0.2027-1

	Firmware:
	BF2 FW: 24.36.7506

	mlnx-dpdk:  'MLNX_DPDK 22.11.1.4.2'
	mlx-regex 1.2-ubuntu1
	virtio-net-controller 1.5.18-1
	collectx-clxapi 1.13.2
	libvma 9.8.20-1
	libxlio 3.0.2-1.2304053
	dpcp 1.1.39-1.2304053

	SNAP3:
	- mlnx-libsnap 1.5.2-5
	- mlnx-snap 3.7.2-8
	- spdk 23.01-6

	DOCA:
	- doca-apps 2.0.2027-1
	- doca-apps-dev 2.0.2027-1
	- doca-grpc 2.0.2027-1
	- doca-grpc-dev 2.0.2027-1
	- doca-libs 2.0.2027-1
	- doca-prime-runtime 2.0.2027-1
	- doca-prime-sdk 2.0.2027-1
	- doca-prime-tools 2.0.2027-1
	- doca-runtime 2.0.2027-1.23.04.0.5.3.0.bf.4.0.2.12679.11.23
	- doca-runtime-kernel 2.0.2027-1.23.04.0.5.3.0.bf.4.0.2.12679.11.23
	- doca-runtime-user 2.0.2027-1.23.04.0.5.3.0.bf.4.0.2.12679.11.23
	- doca-samples 2.0.2027-1
	- doca-sdk 2.0.2027-1.23.04.0.5.3.0.bf.4.0.2.12679.11.23
	- doca-sdk-kernel 2.0.2027-1.23.04.0.5.3.0.bf.4.0.2.12679.11.23
	- doca-sdk-user 2.0.2027-1.23.04.0.5.3.0.bf.4.0.2.12679.11.23
	- doca-services 2.0.2027-1
	- doca-tools 2.0.2027-1.23.04.0.5.3.0.bf.4.0.2.12679.11.23
	- dpa-compiler 1.4.0
	- dpacc 1.4.0
	- flexio 23.4.1494
	- libdoca-libs-dev 2.0.2027-1
	- librxpcompiler-dev 23.04.1
	- librxpcompiler-dev 23.04.1
	- rxp-compiler 23.04.1
	- rxpbench 23.04.0

	OFED:
	dpcp 1.1.39-1.2304053
	ibacm 2304mlnx44-1.2304053
	ibutils2 2.1.1-0.162.MLNX20230417.g738750f2.2304053
	ibverbs-providers:arm64 2304mlnx44-1.2304053
	ibverbs-utils 2304mlnx44-1.2304053
	infiniband-diags 2304mlnx44-1.2304053
	libibmad5:arm64 2304mlnx44-1.2304053
	libibmad-dev:arm64 2304mlnx44-1.2304053
	libibnetdisc5:arm64 2304mlnx44-1.2304053
	libibumad3:arm64 2304mlnx44-1.2304053
	libibumad-dev:arm64 2304mlnx44-1.2304053
	libibverbs1:arm64 2304mlnx44-1.2304053
	libibverbs-dev:arm64 2304mlnx44-1.2304053
	libopensm 5.15.0.MLNX20230417.d84ecf64-0.1.2304053
	libopensm-devel 5.15.0.MLNX20230417.d84ecf64-0.1.2304053
	libopenvswitch:arm64 2.17.7-1.2304053
	librdmacm1:arm64 2304mlnx44-1.2304053
	librdmacm-dev:arm64 2304mlnx44-1.2304053
	libvma 9.8.20-1
	libvma-dev 9.8.20-1
	libvma-utils 9.8.20-1
	libxlio 3.0.2-1.2304053
	libxlio-dev 3.0.2-1.2304053
	libxlio-utils 3.0.2-1.2304053
	mlnx-dpdk 22.11.0-1.4.2.23040530.1.4.2
	mlnx-dpdk-dev:arm64 22.11.0-1.4.2.23040530.1.4.2
	mlnx-ethtool 6.0-1.2304053
	mlnx-iproute2 6.2.0-1.2304053
	mlnx-ofed-kernel-utils 23.04-OFED.23.04.0.5.3.1.bf.kver.5.15.0-1015-bluefield
	mlnx-tools 23.04-0.2304053
	mstflint 4.16.1-2.2304053
	opensm 5.15.0.MLNX20230417.d84ecf64-0.1.2304053
	openvswitch-common 2.17.7-1.2304053
	openvswitch-common 2.17.7-1.2304053
	openvswitch-ipsec 2.17.7-1.2304053
	openvswitch-ipsec 2.17.7-1.2304053
	openvswitch-switch 2.17.7-1.2304053
	openvswitch-switch 2.17.7-1.2304053
	perftest 23.04.0-0.23.g63e250f.2304053
	python3-openvswitch 2.17.7-1.2304053
	python3-pyverbs:arm64 2304mlnx44-1.2304053
	rdmacm-utils 2304mlnx44-1.2304053
	rdma-core 2304mlnx44-1.2304053
	srptools 2304mlnx44-1.2304053
	ucx 1.15.0-1.2304053

PCI devices:
------------

DEVICE_TYPE             MST                           PCI       RDMA            NET                                     NUMA  
BlueField2(rev:1)       /dev/mst/mt41686_pciconf0     10:00.0                                           -1    

BlueField2(rev:1)       /dev/mst/mt41686_pciconf0.1   10:00.1                                           -1    

BlueField2(rev:1)       /dev/mst/mt49873_pciconf0.2   10:00.2                                           -1


BF Config
---------

DOCA_2.0.2_BSP_4.0.3_Ubuntu_22.04-11.23-04.prod

Content of ``bf.cfg``::

	ubuntu_PASSWORD='$1$tFWHnhQf$vn2b7vms6Apf287uZi75./'

The password is created with `openssl passwd -1` and the input 'Odus.321'