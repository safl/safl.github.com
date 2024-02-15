Panel Integration
-----------------

I really like the functionality and ease of use of the XFCE4 panel with
network-applet, printers, calender etc. it just works and no fuss to change
or expand. Thus using it, and disabling the i3bar.

However, this removes the workspace-indicator given by the i3bar. Fortunately a
XFCE panel applet can fix that. However, it needs to be installed from source.

i3ipc-glib
__________

This is needed for the ``i3-workspaces-plugin``. It too has dependencies:

.. code-block:: bash

  sudo apt-get install -qy \
    gobject-introspection \
    gtk-doc-tools \
    libjson-glib-dev \
    libxcb1-dev

Do this:

.. code-block:: bash

  cd -/git
  git clone https://github.com/altdesktop/i3ipc-glib.git
  cd i3ipc-glib
  git checkout v1.0.1

  ./autogen.sh --prefix=/usr
  make
  sudo make install

i3-workspaces-plugin
____________________

Requirements:

.. code-block:: bash

  sudo apt-get install \
    libxfce4panel-2.0-dev \
    libxfce4ui-2-dev \
    xfce4-dev-tools

i3 provides stuff like: i3bar, i3status, i3pystatus, i3blocks etc. however, the
XFCE4 provides the same with a bunch of well-supported applets like the
gnome-network-manager. So instead of using the i3bar, this setup favors using
the xfce-panel instead, and then integrating the i3 workspaces via a plugin:

.. code-block:: bash

  cd -/git
  git clone https://github.com/denesb/xfce4-i3-workspaces-plugin.git
  cd xfce4-i3-workspaces-plugin
  git checkout 1.4.0

  ./autogen.sh --prefix=/usr
  make
  sudo make install
