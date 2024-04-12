"""
  Set proxy for nix-daemon to speed up downloads
  You can safely ignore this file if you don't need a proxy.

  https://github.com/NixOS/nix/issues/1472#issuecomment-1532955973
"""
import os
import plistlib
import shlex
import subprocess
from pathlib import Path


NIX_DAEMON_PLIST = Path("/Library/LaunchDaemons/org.nixos.nix-daemon.plist")
NIX_DAEMON_NAME = "org.nixos.nix-daemon"
NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
# http proxy provided by clash or other proxy tools
# Corp Proxy: http://proxy.bloomberg.com:81
# Dev Proxy:  http://proxy.bloomberg.com:82
HTTP_PROXY = "http://proxy.bloomberg.com:81" # DevSkim: ignore DS137138

pl = plistlib.loads(NIX_DAEMON_PLIST.read_bytes())

# set http/https proxy
# NOTE: curl only accept the lowercase of `http_proxy`!
# NOTE: https://curl.se/libcurl/c/libcurl-env.html
pl["EnvironmentVariables"]["http_proxy"] = HTTP_PROXY
pl["EnvironmentVariables"]["https_proxy"] = HTTP_PROXY
pl["EnvironmentVariables"]["NIX_SSL_CERT_FILE"] = NIX_SSL_CERT_FILE

# remove http proxy
# pl["EnvironmentVariables"].pop("http_proxy", None)
# pl["EnvironmentVariables"].pop("https_proxy", None)

os.chmod(NIX_DAEMON_PLIST, 0o644)
NIX_DAEMON_PLIST.write_bytes(plistlib.dumps(pl))
os.chmod(NIX_DAEMON_PLIST, 0o444)

# reload the plist
for cmd in (
	f"launchctl unload {NIX_DAEMON_PLIST}",
	f"launchctl load {NIX_DAEMON_PLIST}",
):
  print(cmd)
  subprocess.run(shlex.split(cmd), capture_output=False)
