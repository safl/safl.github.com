Secure-SHell (ssh)
==================

Unsafe configuration, ``vim /etc/ssh/sshd_config``::

  PermitRootLogin yes

Then restart ssh::

  sudo service ssh restart

Transfer keys::

  ssh-copy-id root@localhost

Configure Agent
---------------

Add the following to your ``~/.bash_aliases``::

  # SSH-agent when logging in over SSH
  SSH_ENV="$HOME/.ssh/environment"

  function start_agent {
      echo "Initialising new SSH agent..."
      /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
      echo succeeded
      chmod 600 "${SSH_ENV}"
      . "${SSH_ENV}" > /dev/null

      # Add your keys here for example 'id_rsa'
      /usr/bin/ssh-add "$HOME/.ssh/id_rsa";
  }

  # Source SSH settings, if applicable
  if [ -f "${SSH_ENV}" ]; then
      . "${SSH_ENV}" > /dev/null
      ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
          start_agent;
      }
  else
      start_agent;
  fi


Keys (key-pairs)
----------------

...

Keychain / ssh-agent
--------------------

...

