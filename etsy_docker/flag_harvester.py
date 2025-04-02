#!/usr/bin/env python3

# polls live Vitess components and extracts the CLI args for analysis

# Note: you may need to execute this script from your laptop over the VPN as the firewall may block access from devVMs on these ports
# Example Usage:
# python3 flag_harvester.py vtctld-4rvh.us-central1-f.c.etsy-vitess-prod.internal:8080
# python3 flag_harvester.py vtgate-blue-0-065s.us-central1-a.c.etsy-vitess-prod.internal:8080
# python3 flag_harvester.py dbgifts001a.us-central1-a.c.etsy-mysql-prod.internal:15306


import json
import urllib.request
import re
import sys


# some flags are very specific to the runtime environment so annotate these the best we can in the final output
SKIPPED_FLAGS = re.compile(r"^--topo_|port$", flags=re.IGNORECASE)
REDACTED_FLAGS = re.compile(r"us_central|\.internal|\.com", flags=re.IGNORECASE)
endpoint = sys.argv[1]


with urllib.request.urlopen(f"http://{endpoint}/debug/vars") as response:
    data = json.loads(response.read())

cmdline = data.get("cmdline", [])
flags = cmdline[1:]

print("***** Unaltered Flags *****")
print(*sorted(flags), "\n\n", sep="\n")

print("***** Skipped/Redacted Flags *****")
for flag in sorted(flags):
    try:
        flag, value = flag.split("=")
        if SKIPPED_FLAGS.search(flag):
            flag = f"<SKIP> {flag}"
        if REDACTED_FLAGS.search(value):
            value = "<REDACTED>"
        print(f"{flag}={value}")
    except ValueError:
        print(flag)
