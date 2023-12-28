#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/0xSocrates/Scripts/main/style.sh)
clear

HedefBlok="316000"

update() {
print_color $Green "Düğüm belirtilen blok yüksekliğine ulaştı. Güncelleme yapılıyor..."
sudo systemctl stop pryzmd


sudo systemctl start pryzmd
sleep 2
sudo systemctl restart pryzmd
print_color $Blue "Güncelleme tamamldandı. Version: $(pryzmd version)" sleep 1
print_color $Blue "Logları takip edin:         sudo journalctl -u pryzmd -fo cat" sleep 1
}

curl -sSL https://raw.githubusercontent.com/0xSocrates/Scripts/main/core-node.sh | bash
echo -e ""
echo -e "Current Version: $(pryzmd version)"
echo -e "Update Version: 0.10.0"
echo -e "Update Height: $HedefBlok"
echo -e "Current Height: $(pryzmd status 2>&1 | jq -r .SyncInfo.latest_block_height)"
echo -e ""

while true; do
    latest_block_height=$(pryzmd status 2>&1 | jq -r .SyncInfo.latest_block_height)
    if [ "$latest_block_height" -ge "$HedefBlok" ]; then
        update  
        break
    else
        print_color $Yellow "Düğüm henüz beklenen blok yüksekliğine ulaşmadı($(pryzmd status 2>&1 | jq -r .SyncInfo.latest_block_height)) Bekleniyor..."
    fi
    sleep 1
done

source $HOME/.bash_profile
