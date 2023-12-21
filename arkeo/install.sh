#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/0xSocrates/Scripts/main/style.sh)
source <(curl -s https://raw.githubusercontent.com/0xSocrates/Scripts/main/general_functions.sh)
source <(curl -s https://raw.githubusercontent.com/0xSocrates/Scripts/main/cascadia_config.sh)
clear
logo
get_moniker
removenode
prepare_server
install_binary
init
config
snapshot
service
lastinfo
source $HOME/.bash_profile
