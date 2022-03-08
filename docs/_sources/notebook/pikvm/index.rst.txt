PiKVM with v3 HAT
=================

From the download-page, grab ``v3-hdmi-rpi4-latest.img.xz`` and write it to
sdcard. Assemble the thing and let it boot.

Post-installation tasks in the PiKVM shell::

  # Change storage to read/write mode
  rw

  # Change the hostname
  hostnamectl set-hostname <the-new-hostname>

  # Disable WiFi and Bluetooth
  echo "dtoverlay=disable-wifi" >> /boot/config.txt
  echo "dtoverlay=disable-bt" >> /boot/config.txt

  # Change the password
  passwd root

  # Change password for ui
  kvmd-htpasswd set admin

  # Enable the oled-display of the steel-case
  systemctl enable --now kvmd-oled kvmd-oled-reboot kvmd-oled-shutdown
  systemctl enable --now kvmd-fan

  # Change storage to read-only mode
  ro

Troubleshooting
---------------

If you find that mouse / keyboard is not working then check:

* Make sure you have the small USB-C bridge connected. That is the thing that
  lies with the ATX-pcb. Without it, then mouse/keyboard won't work.

* Make sure you are connected the USB-cabel from the PiKVM to the
  target-machine.

* Make sure that USB works on your target-machine.

* That you used the right image, e.g. if you use a v2 image with the v3 hat,
  then mouse/keyboard won't work. This might seem obvious, but I made the
  mistake of just grabbing the first download-link on the download-page,
  instead of reading the page and grabbing the one for v3... so... if nothing
  else works, then this might be why.
