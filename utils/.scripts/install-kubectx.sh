#!/bin/bash
function is_bin_in_path {
  builtin type -P "$1" &> /dev/null
}

is_bin_in_path kubectx && echo "kubectx is already installed" && exit 0



sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens


