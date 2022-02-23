#!/usr/bin/env python
import argparse
import httplib
import json

resources = ["lights", "groups", "config", "schedules", "scenes", "sensors", "rules"]

class Bridge(object):
    """
    Basic bridge communication.

    Usage:
    
    b = Bride(bridge, username)

    Reading resources:;

        b.lights()
        b.config()

    And the like...

    read/write attributes::

        b.get("lights", 1, "state") # State of light Nr. 1
        b.put("lights", 1, "state", {"on": False") # Turn light Nr. 1 offf

    """

    def __init__(self, bridge, username):
        self.bridge = bridge
        self.username = username

        for resource in resources:
            setattr(self, resource, self._get_resource(resource))

    def _get_resource(self, resource):
        return lambda: self.get(resource)

    def get(self, *args):
        args_txt = "/".join([str(arg) for arg in args])
        
        conn =  httplib.HTTPConnection("%s" % self.bridge)
        url = '/api/%s/%s' % (self.username, args_txt)
        conn.request('GET', url)
        
        res = conn.getresponse().read()
        res_json = json.loads(res)

        return res

    def put(self, *args):
        payload = json.dumps(args[-1])
        args_txt = "/".join([str(arg) for arg in args[:-1]])

        conn =  httplib.HTTPConnection("%s" % self.bridge)
        url = "/api/%s/%s" % (self.username, args_txt)
        conn.request("PUT", url, payload)
        
        res = conn.getresponse()

        return res

def main():
    parser = argparse.ArgumentParser(description='Philips HUE cli')
    parser.add_argument('bridge', type=str, help='Bridge address')
    parser.add_argument('username', type=str, help='Bridge username')
    parser.add_argument('resource', type=str, nargs='+', help="Resource")

    args = parser.parse_args()

    b = Bridge(args.bridge, args.username)
    for resource in args.resource:
        print(b.get(resource))

if __name__ == "__main__":
    main()
