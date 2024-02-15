from datetime import datetime
from pprint import pprint
import os

project = u"safl.dk"
year = datetime.now().year
copyright = u"%d Simon A. F. Lund" % year

extensions = [
    "sphinx.ext.extlinks",
    "sphinx_copybutton",
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
    'xref-app-discord': ('https://discord.com/%s', None),
    'xref-app-slack': ('https://slack.com/%s', None),
    'xref-app-spotify': ('https://www.spotify.com%s', None),
    'xref-app-sublimetext': ('https://www.sublimetext.com/%s', None),
    'xref-app-teams': ('https://www.microsoft.com/en-us/microsoft-teams%s', None),
    'xref-app-zoom': ('https://zoom.us/download%s', None),
    'xref-appimage': ('https://appimage.org/%s', None),
    'xref-de-cinnamon': ('https://projects.linuxmint.com/cinnamon/%s', None),
    'xref-de-gnome': ('https://www.gnome.org/%s', None),
    'xref-de-kde': ('https://kde.org/%s', None),
    'xref-de-mate': ('https://mate-desktop.org/%s', None),
    'xref-de-xfce': ('https://xfce.org/%s', None),
    'xref-flatpak': ('https://flatpak.org/%s', None),
    'xref-getmail': ('https://wiki.archlinux.org/title/Getmail%s', None),
    'xref-gnupg': ('https://wiki.archlinux.org/title/GnuPG%s', None),
    'xref-neomutt': ('https://neomutt.org/%s', None),
    'xref-os-armbian': ('https://www.armbian.com/%s', None),
    'xref-os-debian': ('https://www.debian.org/%s', None),
    'xref-os-fedora': ('https://getfedora.org/%s', None),
    'xref-os-freebsd': ('https://www.freebsd.org/%s', None),
    'xref-os-linux': ('https://en.wikipedia.org/wiki/Linux%s', None),
    'xref-os-macos': ('https://en.wikipedia.org/wiki/MacOS%s', None),
    'xref-os-opensuse': ('https://www.opensuse.org/%s', None),
    'xref-os-rpios': ('https://www.raspberrypi.com/software/%s', None),
    'xref-os-ubuntu': ('https://ubuntu.com/%s', None),
    'xref-os-windows': ('https://www.microsoft.com/en-us/windows%s', None),
    'xref-snapcraft': ('https://snapcraft.io/%s', None),
    'xref-wayland': ('https://wayland.freedesktop.org/%s', None),
    'xref-wm-awesome': ('https://awesomewm.org/%s', None),
    'xref-wm-fluxbox': ('http://fluxbox.org/%s', None),
    'xref-wm-i3': ('https://i3wm.org/%s', None),
    'xref-wm-i3-gaps': ('https://github.com/Airblader/i3%s', None),
    'xref-wm-openbox': ('http://openbox.org/%s', None),
    'xref-wm-xmonad': ('https://xmonad.org/%s', None),
    'xref-x11': ('http://www.opengroup.org/tech/desktop/x-window-system/%s', None),
    'xref-kvm': ('https://wiki.debian.org/KVM%s', None)
}

def update_context(app, pagename, templatename, context, doctree):
    context["blue8bit"] = "0.0.1"

def setup(app):

    app.connect("html-page-context", update_context)

    return {"version": "0.0.1", "parallel_read_safe": True}
