Disable Beep / System Beep / pcspeaker
======================================

Unload the module::

  sudo rmmod pcspkr

Make sure it is not loaded again, by "blacklisting" it::

  echo "blacklist pcspkr" >> /etc/modprobe.d/blacklist.conf
