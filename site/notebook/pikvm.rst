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
