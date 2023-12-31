#!/bin/bash
source <(curl -s https://raw.githubusercontent.com/0xSocrates/Scripts/main/style.sh)
clear
HedefBlok="316000"
update() {
print_color $Green "Düğüm belirtilen blok yüksekliğine ulaştı. Güncelleme yapılıyor..."
sudo systemctl stop pryzmd
MIMARI=$(uname -m)

if [ "$MIMARI" = "x86_64" ]; then
    # AMD64 mimarisi için
    wget https://storage.googleapis.com/pryzm-zone/core/0.10.0/pryzmd-0.10.0-linux-amd64
    chmod +x pryzmd-0.10.0-linux-amd64
    mv pryzmd-0.10.0-linux-amd64 $(which pryzmd)
elif [ "$MIMARI" = "aarch64" ]; then
    # ARM64 mimarisi için
    wget https://storage.googleapis.com/pryzm-zone/core/0.10.0/pryzmd-0.10.0-linux-arm64
    chmod +x pryzmd-0.10.0-linux-arm64
    mv pryzmd-0.10.0-linux-arm64pryzmd $(which pryzmd)
fi
source $HOME/.bash_profile
sudo systemctl start pryzmd
sleep 2
sudo systemctl restart pryzmd
print_color $Blue "Güncelleme tamamldandı. Version: $(pryzmd version)" sleep 1
print_color $Blue "Logları takip edin:         sudo journalctl -u pryzmd -fo cat" sleep 1
}
curl -sSL https://raw.githubusercontent.com/0xSocrates/Scripts/main/core-node.sh | bash
print_color $PURPLE "Current Version: $(pryzmd version)"
print_color $PURPLE "Update Version: 0.10.0"
print_color $PURPLE "Update Height: $HedefBlok"
print_color $PURPLE "Current Height: $(pryzmd status 2>&1 | jq -r .SyncInfo.latest_block_height)"
echo -e ""
while true; do
    latest_block_height=$(pryzmd status 2>&1 | jq -r .SyncInfo.latest_block_height)
    if [ "$latest_block_height" -ge "$HedefBlok" ]; then
        update  
        break
    else
        print_color $Yellow "Düğüm henüz beklenen blok yüksekliğine ulaşmadı($(pryzmd status 2>&1 | jq -r .SyncInfo.latest_block_height)) Bekleniyor..."
    fi
    sleep 2
done
source $HOME/.bash_profile
