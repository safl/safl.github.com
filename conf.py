from datetime import datetime
from pprint import pprint
import os

project = u"safl.dk"
year = datetime.now().year
copyright = u"%d Simon A. F. Lund" % year

extensions = [
    "sphinx.ext.extlinks",
]
source_suffix = ".rst"

#templates_path = ["_templates"]

html_theme_path = ["_themes"]
html_theme = "blue8bit"
html_title = "safl.dk - Don't push me cause I'm close to the edge..."
html_theme_options = {
}
html_static_path = ["_static"]

extlinks = {
    'xref-app-discord': ('https://discord.com/', None),
    'xref-app-slack': ('https://slack.com/', None),
    'xref-app-spotify': ('https://www.spotify.com', None),
    'xref-app-sublimetext': ('https://www.sublimetext.com/', None),
    'xref-app-teams': ('https://www.microsoft.com/en-us/microsoft-teams', None),
    'xref-app-zoom': ('https://zoom.us/download', None),
    'xref-appimage': ('https://appimage.org/', None),
    'xref-de-cinnamon': ('https://projects.linuxmint.com/cinnamon/', None),
    'xref-de-gnome': ('https://www.gnome.org/', None),
    'xref-de-kde': ('https://kde.org/', None),
    'xref-de-mate': ('https://mate-desktop.org/', None),
    'xref-de-xfce': ('https://xfce.org/', None),
    'xref-flatpak': ('https://flatpak.org/', None),
    'xref-getmail': ('https://wiki.archlinux.org/title/Getmail', None),
    'xref-gnupg': ('https://wiki.archlinux.org/title/GnuPG', None),
    'xref-neomutt': ('https://neomutt.org/', None),
    'xref-os-armbian': ('https://www.armbian.com/', None),
    'xref-os-debian': ('https://www.debian.org/', None),
    'xref-os-fedora': ('https://getfedora.org/', None),
    'xref-os-freebsd': ('https://www.freebsd.org/', None),
    'xref-os-linux': ('https://en.wikipedia.org/wiki/Linux', None),
    'xref-os-macos': ('https://en.wikipedia.org/wiki/MacOS', None),
    'xref-os-opensuse': ('https://www.opensuse.org/', None),
    'xref-os-rpios': ('https://www.raspberrypi.com/software/', None),
    'xref-os-ubuntu': ('https://ubuntu.com/', None),
    'xref-os-windows': ('https://www.microsoft.com/en-us/windows', None),
    'xref-snapcraft': ('https://snapcraft.io/', None),
    'xref-wayland': ('https://wayland.freedesktop.org/', None),
    'xref-wm-awesome': ('https://awesomewm.org/', None),
    'xref-wm-fluxbox': ('http://fluxbox.org/', None),
    'xref-wm-i3': ('https://i3wm.org/', None),
    'xref-wm-i3-gaps': ('https://github.com/Airblader/i3', None),
    'xref-wm-openbox': ('http://openbox.org/', None),
    'xref-wm-xmonad': ('https://xmonad.org/', None),
    'xref-x11': ('http://www.opengroup.org/tech/desktop/x-window-system/', None),
    'xref-kvm': ('https://wiki.debian.org/KVM', None)
}

def update_context(app, pagename, templatename, context, doctree):
    context["blue8bit"] = "0.0.1"

def setup(app):

    app.connect("html-page-context", update_context)

    return {"version": "0.0.1", "parallel_read_safe": True}
