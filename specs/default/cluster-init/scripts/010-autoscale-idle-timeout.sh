#!/bin/bash

set -e

idle_timeout=$(jetpack config pbspro.autoscale_idle_timeout nan)
[ "$idle_timeout" != "nan" ] || exit 0

# replace autoscale idle timeout
asjson=/opt/cycle/pbspro/autoscale.json
tmp=$(mktemp)
jq ".idle_timeout = $idle_timeout" < $asjson > "$tmp"
# retain permissions
cat "$tmp" > $asjson
rm "$tmp"
