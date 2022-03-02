Docker Engine
=============

Foo...

Installation
------------

Install the docker-engine via Docker-provided repositories, the ones provided
with Debian are not recommended, so go ahread with the following::

  #Ensure old versions are gone
  sudo apt-get remove \
    docker \
    docker-engine \
    docker.io \
    containerd \
    runc

  # Install prerequisites
  sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

  # Setup docker repos
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update

  # Now install it
  sudo apt-get install docker-ce docker-ce-cli containerd.io

Non-root usage
--------------

We want to be able to run docker as a non-root user, this is achieved by simply
adding the non-root user to docker, for example::

  sudo usermod -aG docker $USER

Now log out and log back in again, this is to refresh group-membership, then
verify that it is working by starting the docker image::

  docker run hello-world

Privileged containers
---------------------

...
