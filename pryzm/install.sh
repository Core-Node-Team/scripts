#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/0xSocrates/Scripts/main/style.sh) || true
source <(curl -s https://raw.githubusercontent.com/0xSocrates/Scripts/main/general_functions.sh) || true
source <(curl -s https://raw.githubusercontent.com/Core-Node-Team/scripts/main/pryzm/config.sh) || true
clear
logo
get_moniker
removenode
prepare_server
install_binary
source $HOME/.bash_profile
init
config
snapshot
service
lastinfo
source $HOME/.bash_profile




