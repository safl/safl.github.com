Secure-SHell (ssh)
------------------

Unsafe configuration, ``vim /etc/ssh/sshd_config``::

  PermitRootLogin yes

Then restart ssh::

  sudo service ssh restart

Transfer keys::

  ssh-copy-id root@localhost

key-pairs
~~~~~~~~~

...

agent
~~~~~

...

