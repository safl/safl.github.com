========
 GitHUB
========

Self-hosted Runners
===================

There are limits to what you can do on the runners hosted by GitHUB. This is
where GitHUB self-hosted runners comes into play. You can BYOD to the GitHUB
Actions. This can be HW in your garage, basement, attic, or, often more
conveniently, provided via cloud-hosting or bare-metal host.

This explores the latter approaches: virtual and bare-metal providers.

Virtual
-------

To the authors knowledge, then the only cloud-provider supporting
nested-virtualization is `Digital-Ocean`_. That is, atleast for low-tier
virtual machines e.g less than **100USD/mo** per instance.

Nested virtualization is needed as the GitHUB-runner will start up a custom
qemu-instance for NVMe emulation. All the droplet types work, however, it is
usually nice with more than a single core in the VM, 8GB+, Storage, that is,
when running qemu-instances.

It will of course vary based on your specific use-case.

A more cost-effective solution is deploying multiple runners on the same machine.

Bare-metal
----------

`Hetzner`_ is a great place to get hosted bare-metal, at the time writing this
then a ``AX41-NVMe`` (priced at **51.3EUR/mo**) system gives you a machine with
the following specs:

* CPU: AMD Ryzen 5 3600 ~ 6 Cores / 12 Threads
* MEM: 64GB DDR4
* STORAGE: 2x 512GB SSD (Samsung 980PRO)

In Digital-Ocean terms, this hardware can provide **SIX INSTANCES** of what in DO terms are:

* Droplet Type: Dedicated CPU

  * General Purpose
  * CPU: 2 Core
  * MEM: 8GB
  * STORAGE: 25GB

* Cost for this instance at the time of writing: **63USD/mo**.

Basically getting six times the resources, plus some to spare.

System Setup
------------

The machine will be named ``ghrbox`` with a numeral postfix, specifically ``ghrbox01``

Deploy your keys:

.. code-block:: bash

    ssh-copy-id root@<SYSTEM_IP>

Update it and install various needed libraries and tools:

.. code-block:: bash

    apt-get -qy update
    apt-get -qy upgrade
    apt-get -qy dist-upgrade
    apt-get -qy install \
        cloud-utils \
        git \
        htop \
        libvirt-daemon-system \
        qemu \
        qemu-system \
        qemu-utils \
        time \
        tree \
        vim

Install **Docker** according to the official documentation:

* https://docs.docker.com/engine/install/debian/

Give the machine a name:

.. code-block:: bash

    # Set the hostname
    hostnamectl set-hostname ghrbox01

    # Update it in /dev/hosts
    vim /dev/hosts

Log into the machine and create a new non-root user named ``ghr``:

.. code-block:: bash

    adduser ghr
    usermod -aG sudo ghr
    usermod -aG libvirt ghr
    usermod -aG docker ghr

The GitHUB Action-runner will be executing as this user.

Add your keys to system for the ``ghr`` user as well:

.. code-block:: bash

    ssh-copy-id ghr@<SYSTEM_IP>

Actions Runner
~~~~~~~~~~~~~~

Log into the system as the ``ghr`` user, and setup a couple environment
variables, as they will be needed for the subsequent commands:

.. code-block:: bash

  # This is the username of the user created previously
  export RUNNER_USER=ghr

  # This is the URL of your GitHUB Project e.g. https://github.com/OpenMPDK/xNVMe
  export URL=

  # This is a GitHUB Runner token, get this from the project-settings/runners page
  export TOKEN=

Log out and log in as the ``ghr`` user.

Install GitHUB-action-runner:

.. code-block:: bash

    # Create a home for the runner
    mkdir actions-runner && cd actions-runner

    # Download the runner
    curl -o actions-runner-linux-x64-2.303.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.303.0/actions-runner-linux-x64-2.303.0.tar.gz

    # Extract it
    tar xzf ./actions-runner-linux-x64-2.303.0.tar.gz

Setup six runners:

.. code-block:: bash

    for nr in {1..6}; do cp -r actions-runner "worker${nr}"; done;

Setup a token, get this from github.com and place it in an environment variable (``TOKEN``):

.. code-block:: bash

    export TOKEN=<GET_THIS_TOKEN_FROM_GITHUB>

Register runners:

.. code-block:: bash

    for nr in {1..6}; do pushd worker${nr}; ./config.sh --url ${URL} --unattended --disableupdate --replace --name ghrbox01-worker${nr} --token ${TOKEN}; popd; done

Install as a service, start and check them:

.. code-block:: bash

    # Service(s): install
    for nr in {1..6}; do pushd worker${nr}; sudo ./svc.sh install ${RUNNER_USER}; popd; done

    # Service(s): start
    for nr in {1..6}; do pushd worker${nr}; sudo ./svc.sh start; popd; done

    # Service(s): status
    for nr in {1..6}; do pushd worker${nr}; sudo ./svc.sh status; popd; done

Stop and uninstall services:

.. code-block:: bash

    # Services: stop
    for nr in {1..6}; do pushd worker${nr}; sudo ./svc.sh stop; popd; done

    # Services: uninstall
    for nr in {1..6}; do pushd worker${nr}; sudo ./svc.sh uninstall; popd; done

Remove all runners:

.. code-block:: bash

    for nr in {1..6}; do pushd "worker${nr}"; ./config.sh remove --token ${TOKEN}; popd; done;

Tips'n'Tricks
=============

Fetching pull-requests without adding remotes::

  git fetch upstream pull/49/head:ghpr-49

.. _Digital-Ocean: https://www.digitalocean.com/
.. _Hetzner-Robot: https://robot.hetzner.com/
.. _Hetzner: https://www.hetzner.com/
