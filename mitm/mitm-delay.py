# Start with:
#
# mitmweb --ssl_insecure -s mitm-delay.py

import asyncio
import logging
import re

from mitmproxy.script import concurrent

async def request(flow):
    host_with_delay = re.search(r"^delay-(\d+)\.(.*)", flow.request.host)
    if host_with_delay:
        delay = int(host_with_delay[1])
        logging.info(f"Delay {delay}s for {flow.request.method} {flow.request.host}{flow.request.path}")
        flow.request.host = host_with_delay[2]
        flow.request.port = 6443

    if flow.request.host == "api.crc.testing":
        flow.request.port = 6443

    await asyncio.sleep(delay)

async def response(flow):
    logging.info(f"{flow.request.method} {flow.request.host}{flow.request.path} // Status code: {flow.response.status_code}")
