
BinaryName="althea"
DirectName=".althea" #database directory
CustomPort="315"
NodeName="althea-chain"  # project folder
ChainID="althea_417834-3"

install_binary() {
print_color $Blue "$BinaryName Kuruluyor..."
sleep 1
exec > /dev/null 2>&1
apt install npm -y
cd $HOME
rm -rf althea-L1
git clone https://github.com/althea-net/althea-L1
cd althea-L1
make install
source $HOME/.bash_profile
exec > /dev/tty 2>&1
print_color $Yellow "$BinaryName $($BinaryName version) Kuruldu."
sleep 1
}

snapshot() {
print_color $Blue "Snapshot İndiriliyor..."
curl -L http://37.120.189.81/althea_testnet/althea_snap.tar.lz4 | tar -I lz4 -xf - -C $HOME/.althea
}

config() {
print_color $Blue "Yapılandırma Dosyası Ayarları Yapılıyor..."
exec > /dev/null 2>&1
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/althea/addrbook.json > $HOME/$DirectName/config/addrbook.json
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/althea/genesis.json > $HOME/$DirectName/config/genesis.json
peers="bc47f3e8f9134a812462e793d8767ef7334c0119@chainripper-2.althea.net:23296"
seeds=""
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/$DirectName/config/config.toml
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001aalthea"|g' $HOME/.althea/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.althea/config/config.toml


# puruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
  $HOME/$DirectName/config/app.toml
# indexer
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/$DirectName/config/config.toml
# custom port
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CustomPort}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CustomPort}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CustomPort}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CustomPort}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CustomPort}66\"%" $HOME/$DirectName/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CustomPort}17\"%; s%^address = \":8080\"%address = \":${CustomPort}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CustomPort}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CustomPort}91\"%; s%:8545%:${CustomPort}45%; s%:8546%:${CustomPort}46%; s%:6065%:${CustomPort}65%" $HOME/$DirectName/config/app.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${CustomPort}17\"%; s%^address = \":8080\"%address = \":${CustomPort}80\"%; s%^address = \"localhost:9090\"%address = \"localhost:${CustomPort}90\"%; s%^address = \"localhost:9091\"%address = \"localhost:${CustomPort}91\"%; s%:8545%:${CustomPort}45%; s%:8546%:${CustomPort}46%; s%:6065%:${CustomPort}65%" $HOME/$DirectName/config/app.toml
exec > /dev/tty 2>&1
sleep 1
print_color $Yellow "Tamamlandı."
sleep 1
}





