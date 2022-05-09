#!/bin/bash
function is_bin_in_path {
  builtin type -P "$1" &> /dev/null
}

is_bin_in_path kind && echo "kind is already installed" && exit 0

curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /home/codespace/.local/bin/kind
