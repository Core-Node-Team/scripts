#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/0xSocrates/Scripts/main/style.sh)
source <(curl -s https://raw.githubusercontent.com/0xSocrates/Scripts/main/general_functions.sh)
source <(curl -s https://raw.githubusercontent.com/Core-Node-Team/scripts/main/elys/config.sh)
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
cosmovisor
lastinfo
source $HOME/.bash_profile
