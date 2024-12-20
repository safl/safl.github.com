Desktop Environment
===================

There are a ton options when it comes to desktop environments including
:xref-de-gnome:`GNOME<>`, :xref-de-kde:`KDE<>`, with lightweight derivatives
such as :xref-de-xfce:`XFCE<>`, :xref-de-mate:`MATE<>` and
:xref-de-cinnamon:`Cinnamon<>`. 

Heavyeight vs lightweight is often measured in terms not just of window
management and composition but the entire offering of the desktop environment
provided tools and utilizes are such as network-managers, file-browsers,
screensavers, session-managers, key-chains, printer-configurators, system
configuration, and the list goes on.such as the inclusion of as well as the
supporting libraries for gui components / widgets.

In addition to choosing an existing desktop environment then another 
approach is combining different software projects, such as replacing the
window-manager, or adding another compositor, etc.

All of the above are based on the :xref-x11:`X Window System<>`, a replacement
for which has been underway for 10+ years called :xref-wayland:`Wayland<>`.

My desktop environment is slightly **diy** in the form of a modification of the
lighweight desktop environment :xref-de-xfce:`XFCE<>`. With the window-manager
replaced with :xref-wm-i3:`i3<>`, addition of compositor picom, and the
launcher rofi. The following illustrates what the :xref-de-xfce:`XFCE<>` desktop
environment looks like before and after these modifications.

.. figure:: xfce-vanilla.png
   :align: left
   :figwidth: 50%
   :width: 95%

   :xref-de-xfce:`XFCE<>` as it looks right after installation.

.. figure:: xfce-saflmod.png
   :align: right
   :figwidth: 50%
   :width: 95%

   :xref-de-xfce:`XFCE<>` modified with :xref-wm-i3:`i3<>`, picom, rofi, feh, and HiDPI.


The following subsections documents the packages to install and the
configuration files used.

Modications
-----------

The following modifications rely on configuration-files to a higher extend that
the appearance configuration of :xref-de-xfce:`XFCE<>`.

Window Manager
~~~~~~~~~~~~~~

For the core task of **window management**
one is also spoiled for choice, to name a few
then; :xref-wm-fluxbox:`FluxBox<>`, :xref-wm-openbox:`OpenBox<>`,
:xref-wm-awesome:`Awesome<>`, :xref-wm-i3:`i3<>`, and 
:xref-wm-xmonad:`xmonad<>`. A killer feature is **tiling**.

I went with :xref-wm-i3:`i3<>` since it works very well
with :xref-de-xfce:`XFCE<>`, providing the entire :xref-de-xfce:`XFCE<>` desktop
environment enhanced with the awesome tiling capabilties of :xref-wm-i3:`i3<>`.
Additionally, then the configuration is compatible with **sway** which is
convenient if/when I move from Xorg to Wayland.

Install it with:

.. code-block:: bash

	sudo apt-get install i3

Then run the following to switch the window-manager from ``xfwm`` to ``i3``, and
to disable ``xfdesktop```:

.. code-block:: bash

   xfconf-query -c xfce4-session -p /sessions/Failsafe/Client0_Command -t string -sa xfsettingsd -t string -s --daemon
   xfconf-query -c xfce4-session -p /sessions/Failsafe/Client1_Command -t string -sa i3
   xfconf-query -c xfce4-session -p /sessions/Failsafe/Client2_Command -t string -sa xfce4-panel 
   xfconf-query -c xfce4-session -p /sessions/Failsafe/Client3_Command -t string -s thunar -t string -s --daemon

Lastly, then disable the launch of ``xfsettingsd``.

The configuration of :xref-wm-i3:`i3<>` is done via the configuration file at
``~/.config/i3/config``. In the following sections then there will be references
to subsections of this config, however, in its full form, then here it is:

.. literalinclude:: ../../../../dotfiles/b0rk3d/config/i3/config

Compositor
~~~~~~~~~~

To get transparent windows, with background-blur for better readability, rounded
corners and other eye-candy, then a compositor is needed. I went with picom, the
compositor formerly named compton.

A picture says more than a 1000 words... so... have a look here. From left to
right, screenshots showing the desktop environment without and then with picom
running. I eventually dropped rounded-corners as it did not look "natural".

.. image:: picom01.jpg
   :width: 33%
.. image:: picom02.jpg
   :width: 33%
.. image:: picom03.jpg
   :width: 33%

In addition to the visual changes as shown above, then using ``picom`` has
the effect of aleviating tearing issues that may arise during regular use
of :xref-de-xfce:`XFCE<>`. Install with:
        
.. code-block:: bash

	sudo apt-get install picom

Configure ``picom`` like by editing ``~/.config/picom.conf``:

.. literalinclude:: ../../../../dotfiles/b0rk3d/config/picom/picom.conf

Then launch it via the :xref-wm-i3:`i3<>` config ``~/.config/i3/config``:

.. literalinclude:: ../../../../dotfiles/b0rk3d/config/i3/config
   :lines: 30-31


Backgrounds / wall-papers
~~~~~~~~~~~~~~~~~~~~~~~~~

The cli-tool ``feh`` gets the job done, another popular tool is ``nitrogen``. I
chose ``feh`` since the wallpapers I have:

.. image:: ../../../../backdrops/pixelart01.webp
    :width: 24%

.. image:: ../../../../backdrops/pixelart02.webp
    :width: 24%

.. image:: ../../../../backdrops/pixelart03.webp
    :width: 24%

.. image:: ../../../../backdrops/pixelart04.webp
    :width: 24%


are in ``.webp`` format and compresses great. Back to the point, ``nitrogen``
does not support ``.webp`` but ``feh`` does.

.. code-block:: bash

	sudo apt-get install feh

Launch ``feh`` via :xref-wm-i3:`i3<>` by opening ``~/.config/i3/config`` to
and adding:

.. literalinclude:: ../../../../dotfiles/b0rk3d/config/i3/config
   :lines: 33-34

Launcher
~~~~~~~~

:xref-de-xfce:`XFCE<>` already has a launcher that is, the Whisker Menu, at it
is actually very awesome. However, it doesn't work as well in the i3 context,
since it is treated as a regular window.

.. code-block:: bash

	sudo apt-get install rofi

Then launch it via the :xref-wm-i3:`i3<>` config ``~/.config/i3/config``:

.. literalinclude:: ../../../../dotfiles/b0rk3d/config/i3/config
   :lines: 73-74


Lightdm Greeter background
~~~~~~~~~~~~~~~~~~~~~~~~~~

For a coherent vibe, then I like to also change the background on
thesession-manager / login-screen as well. I use the backgrounds from above
and convert them to ``.jpg`` since Lightdm does not support ``.webp``. The end
result, with scaling as well, looks something like this:

.. figure:: lightdm-scaled-bg.jpg
   :figwidth: 50%
   :width: 95%

   Lightdm greeter after after scaling and changing background.

Here is what I did:

.. code-block:: bash

  # Grab some tools
  sudo apt-get install -qy parallel webp

  # Convert .webp to a format that lightdm can render
  cd ~/git/safl.github.com/backdrops
  parallel convert {} {.}.jpg ::: *.webp

  # Copy the files to a location that lightdm can read
  sudo cp -r ~/git/safl.github.com/backdrops /opt/backdrops

Then copy them to ``/opt/backdrops`` and edit the lightdm configuration at
``/etc/lightdm/lightdm-gtk-greeter.conf``, setting e.g.:


.. literalinclude:: ../../../../dotfiles/b0rk3d/etc/lightdm/lightdm-gtk-greeter.conf
   :lines: 50-51

HiDPI
~~~~~

High resolution displays are great for putting a bunch of stuff on them. E.g.
more pixels, more space for stuff. Another use, is increasing readability by
increasing the number of dots-per-inch, this can make text look so so good,
crisp, clear, easy on the eyes. Less squinting...

Unfortunately, then configuring it is very cumbersome. To do so,
then :xref-de-xfce:`XFCE<>` has a nice **Window Scaling** feature, however, it
does not affect :xref-wm-i3:`i3<>`. :xref-wm-i3:`i3<>` on the other hand uses
``Xft.dpi`` which can be set in ``.Xresources`` and then run ``xrdb -merge
-I$HOME ~/.Xresources`` from ``.xinitrc``. Alas, this won't affect lightdm, e.g.
the login screen.

Alas, I found the most effective is to edit ``/etc/environment``:

.. literalinclude:: ../../../../dotfiles/b0rk3d/etc/environment

And then invoke ``xrandr --dpi 192`` via :xref-wm-i3:`i3<>`:

.. literalinclude:: ../../../../dotfiles/b0rk3d/config/i3/config
   :lines: 35-36

XFCE Appearance
---------------

In :xref-de-xfce:`XFCE<>` then every configuration option has a graphical
settings / configuration application. This is great for exploring what
is possible.
In the following sections the theme, style, fonts and icons used
by :xref-de-xfce:`XFCE<>`. gui-settings to alter are provided as screenshots.

Font, theme, icons
~~~~~~~~~~~~~~~~~~

:xref-de-xfce:`XFCE<>` comes with Monospace, which is not a bad font at all,
however, i don't like the vertical spacing. Instead, I install:

.. code-block:: bash

  sudo apt-get install -qy fonts-dejavu

Which can then be set as the system-wide font in the :xref-de-xfce:`XFCE<>`
Apperance dialog:

.. image:: xfce-appearance-style.jpg
   :width: 24%
.. image:: xfce-appearance-icons.jpg
   :width: 24%
.. image:: xfce-appearance-fonts.jpg
   :width: 24%
.. image:: xfce-appearance-settings.jpg
   :width: 24%

Mouse
~~~~~

.. image:: xfce-mouse-theme.jpg
   :width: 24%

Panel 
~~~~~

The :xref-de-xfce:`XFCE<>` panel (``xfce4-panel``) does a great job, only
downside is the lack of integration with :xref-wm-i3:`i3<>` workspaces. Here is
the configuration I am using:

.. image:: xfce-panel-appearance.png
    :width: 33%
.. image:: xfce-panel-items.png
    :width: 33%
    
Terminal 
~~~~~~~~

I have also used projects like the guake drop-down and the terminal emulator
for its great splitting capabilities. However, with a tiling wm, I no longer
feel the need for these.
Then there is a choice of terminal emulator itself, there are alot out there,
such as xterm and alacritty. However, I have found the :xref-de-xfce:`XFCE<>`
terminal emulator (``xfce4-terminal```) to do a really good job.

Now, for opacity, this is controlable via the apllication settings, like so:


.. image:: xfce-terminal-appearance.png
    :width: 45%
.. image:: xfce-terminal-colors.png
    :width: 45%


