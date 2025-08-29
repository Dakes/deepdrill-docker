#!/usr/bin/env bash
set -euo pipefail


# start an in-container Xorg with the dummy driver + GLX
Xorg "$DISPLAY" -noreset +iglx +extension GLX +extension RANDR \
-logfile /tmp/Xorg.log -config /etc/X11/xorg.conf.d/10-dummy.conf &


# tiny wait for the server to be ready
for _ in $(seq 1 50); do
if xdpyinfo >/dev/null 2>&1; then break; fi
sleep 0.2
done


# sanity check: show GL renderer (should be llvmpipe on CPU)
if command -v glxinfo >/dev/null 2>&1; then glxinfo -B || true; fi


exec "$@"
