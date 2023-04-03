from mitmproxy import http
from mitmproxy import ctx
import re

class HTTPSProxy:
    def __init__(self, target_host, target_sni, proxy_host, proxy_port):
        self.target_host = target_host
        self.target_sni = target_sni
        self.proxy_host = proxy_host
        self.proxy_port = proxy_port

    def run(self):
        from mitmproxy.tools.main import mitmdump
        mitmdump(['-p', str(self.proxy_port), '-s', __file__])

    def request(self, flow: http.HTTPFlow) -> None:
        if flow.request.scheme != "https":
            return

        # check if DNS and SNI headers are the same
        dns_header = flow.request.headers.get("Host")
        sni_header = flow.request.headers.get("SNI")
        if dns_header == sni_header:
            # place only SNI header into Forwarded header
            flow.request.headers["Forwarded"] = f"for={self.proxy_host};proto=https;host={sni_header}"
        else:
            # place both DNS and SNI headers into Forwarded header
            flow.request.headers["Forwarded"] = f"for={self.proxy_host};proto=https;host={dns_header};host={sni_header}"

        # update the Host header
        flow.request.headers["Host"] = self.target_host

        # update the SNI header
        flow.request.headers["SNI"] = self.target_sni

        # update the DNS resolution for the target host
        flow.request.host = self.target_host
        flow.request.port = 443

addons = [
    HTTPSProxy("delightful-sand-056d73f0f.2.azurestaticapps.net", "security.microsoft.com", 8080)
]