#!/bin/bash
function is_bin_in_path {
  builtin type -P "$1" &> /dev/null
}

is_bin_in_path k && echo "k is already installed" && exit 0

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /home/codespace/.local/bin/k

