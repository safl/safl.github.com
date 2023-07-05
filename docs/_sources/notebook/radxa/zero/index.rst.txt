Notes for clearing using "maskrom" mode on MacOS.

Install::

  brew install python lsusb libusb
  python3 -m pip install pyamlboot

The ``boot-g12.py`` comes with ``pyamlboot``. Run it::

Download::

  # bin for erasing the emmc
  wget https://dl.radxa.com/zero/images/loader/radxa-zero-erase-emmc.bin

  # bin for loading the Zero as a block-device for writing
  wget https://dl.radxa.com/zero/images/loader/rz-udisk-loader.bin

  # Erase the eMMC
  /opt/homebrew/bin/boot-g12.py erase.bin

  # Write the udisk-loader, provides for blk-device access from host
  /opt/homebrew/bin/boot-g12.py rz-udisk-loader.bin

  # Write the image
  sudo dd if=Armbian_23.5.1_Radxa-zero_bookworm_current_6.1.30_xfce_desktop.img of=/dev/disk5 status=progress bs=1M oflag=direct


v4l2
====

Useful commands::

  # List of available video devices
  v4l2-ctl --list-devices.

  # List available control settings
  v4l2-ctl -d /dev/video0 --list-ctrls.

  # List available video formats
  v4l2-ctl -d /dev/video0 --list-formats-ext.

  # Read the current settings
  v4l2-ctl -d /dev/video0 --get-ctrl=exposure_auto.
  
  # Change the setting value
  v4l2-ctl -d /dev/video0 --set-ctrl=exposure_auto=1
