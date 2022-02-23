Control Philips Hue Lights with a Phone from the seventies

Modulation over the phone line.

Membrane 4x3 keypad connected to Raspberry pi.

Generic USB numeric keypad.

Voice control.


OS

HUE API
=======

Almost too good to be true, but Philips actually created an neat RESTful API for they HUE product series.
So communication runs over::

    http://[bridge]/api/<username>/[resource]

Thanks Philips! Truth be told, this is why I pay the insane amount for a lightbulb, such that I can play around with it.

Create a user
-------------

Physically click the `link` button on the HUE bridge, then do a POST to "api" with payload::

  {"devicetype":"f78#safl"}

Where `f78` is the APP name and `safl` is the username. Returned values should be something like::

    [
        {
            "success": {
                "username": "114c60782a10a3df2f8c82281afdcbef"
            }
        }
    ]

List lights
-----------

Look at how neat it is done::

    http://[bridge]/api/<username>/lights

With return::

    {
        "1": {
            "state": {
                "on": true,
                "bri": 144,
                "hue": 13123,
                "sat": 212,
                "effect": "none",
                "xy": [
                    0.5125,
                    0.4149
                ],
                "ct": 467,
                "alert": "none",
                "colormode": "ct",
                "reachable": true
            },
            "type": "Extended color light",
            "name": "Tårn (Venstre)",
            "modelid": "LCT001",
            "manufacturername": "Philips",
            "uniqueid": "00:17:88:01:00:e7:df:61-0b",
            "swversion": "66013452",
            "pointsymbol": {
                "1": "none",
                "2": "none",
                "3": "none",
                "4": "none",
                "5": "none",
                "6": "none",
                "7": "none",
                "8": "none"
            }
        },
        "2": {
            "state": {
                "on": true,
                "bri": 144,
                "hue": 13123,
                "sat": 212,
                "effect": "none",
                "xy": [
                    0.5125,
                    0.4149
                ],
                "ct": 467,
                "alert": "none",
                "colormode": "ct",
                "reachable": true
            },
            "type": "Extended color light",
            "name": "Køkken",
            "modelid": "LCT001",
            "manufacturername": "Philips",
            "uniqueid": "00:17:88:01:00:d1:f2:ce-0b",
            "swversion": "66013452",
            "pointsymbol": {
                "1": "none",
                "2": "none",
                "3": "none",
                "4": "none",
                "5": "none",
                "6": "none",
                "7": "none",
                "8": "none"
            }
        },
        "3": {
            "state": {
                "on": true,
                "bri": 144,
                "hue": 13123,
                "sat": 212,
                "effect": "none",
                "xy": [
                    0.5125,
                    0.4149
                ],
                "ct": 467,
                "alert": "none",
                "colormode": "ct",
                "reachable": true
            },
            "type": "Extended color light",
            "name": "Soveværelse",
            "modelid": "LCT001",
            "manufacturername": "Philips",
            "uniqueid": "00:17:88:01:00:d1:ed:23-0b",
            "swversion": "66013452",
            "pointsymbol": {
                "1": "none",
                "2": "none",
                "3": "none",
                "4": "none",
                "5": "none",
                "6": "none",
                "7": "none",
                "8": "none"
            }
        },
        "4": {
            "state": {
                "on": false,
                "bri": 35,
                "hue": 33848,
                "sat": 44,
                "effect": "none",
                "xy": [
                    0.3693,
                    0.3695
                ],
                "ct": 234,
                "alert": "none",
                "colormode": "xy",
                "reachable": true
            },
            "type": "Extended color light",
            "name": "Tårn (Højre)",
            "modelid": "LCT001",
            "manufacturername": "Philips",
            "uniqueid": "00:17:88:01:00:e1:55:71-0b",
            "swversion": "66013452",
            "pointsymbol": {
                "1": "none",
                "2": "none",
                "3": "none",
                "4": "none",
                "5": "none",
                "6": "none",
                "7": "none",
                "8": "none"
            }
        }
    }

Information from individual lights are retrievable::

    http://[bridge]/api/<username>/lights/1

Ahhh so nice.

Manipulating state such as turning lights on/off
================================================

Look at the state above, those attributes can be manipulated by PUT requests.

Such as a PUT to the individual light "state":

    http://[bridge]/api/<username>/lights/1

the the payload::

    {"on":false}

To turn it off.

Multiple values are writable with one request, such as setting it on, brightness, and hue.
However, not all attributes: bri, hue, sat, effect, xy, ct, alert, colormode, and reachable are writable.

The Phone
=========

The dane Henning Andreasen (1923-1985) designed the F78 phone in 1978. In my mind this what a phone looks like. It and the 76E model defined the look of danish telephones. Have a peak at what that look like here [http://www.ptt-museum.dk/dyn/files/articles_items/512-movie/Til%20Liv_II.flv]. However, since land lines are pretty much extinct this thing is today a museum piece. I thought it would be fun to use repurpose it as I kinda like the late seventies design.

raspian with wpa supplicant.

Configure Wi-Fi in Raspbian
===========================

Setup the wlan device `/etc/network/interfaces`::

    ...
    allow-hotplug wlan0
    iface wlan0 inet dhcp
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
    iface default inet dhcp
    ...

We want that entry for wlan0, remove any other wlan in there.

Configure Wi-Fi `/etc/wpa_supplicant/wpa_supplicant.conf`::

    ...
    network={
    ssid="Marvel"
    psk="haha"
    proto=RSN
    key_mgmt=WPA-PSK
    pairwise=CCMP TKIP
    group=CCMP TKIP
    auth_alg=OPEN
    }

Add the program
===============

Prerequisities::
    
    sudo apt-get install python-dev vim evtest
    sudo pip install evdev

Grab the source::

    cd ~
    git clone https://github.com/safl/hue.git
    
