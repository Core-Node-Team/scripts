
BinaryName="cascadiad"
DirectName=".cascadiad" #database directory
CustomPort="119"
NodeName="cascadia"  # project folder
ChainID="cascadia_11029-1"

install_binary() {
print_color $Blue "$BinaryName Kuruluyor..."
sleep 1
exec > /dev/null 2>&1
cd $HOME || return
rm -rf $HOME/cascadia
git clone https://github.com/cascadiafoundation/cascadia.git
cd $HOME/cascadia || return
git checkout v0.1.9
make install
exec > /dev/tty 2>&1
print_color $Yellow "$BinaryName $($BinaryName version) Kuruldu."
sleep 1
}

snapshot() {
print_color $Blue "Snapshot İndiriliyor..."
URL=http://37.120.189.81/cascadia_testnet/cascadia_snap.tar.lz4
curl -L $URL | lz4 -dc - | tar -xf - -C $HOME/.cascadiad
}

config() {
print_color $Blue "Yapılandırma Dosyası Ayarları Yapılıyor..."
exec > /dev/null 2>&1
#genesis
curl -s https://raw.githubusercontent.com/Core-Node-Team/scripts/main/cascadia/genesis.json > $HOME/.cascadiad/config/genesis.json
#addrbook
curl -s https://raw.githubusercontent.com/Core-Node-Team/scripts/main/cascadia/addrbook.json > $HOME/.cascadiad/config/addrbook.json
#seed-peers
SEEDS=""
PEERS="21ca2712116138429aed3d72422379397c53fa86@65.109.65.248:34656"
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.cascadiad/config/config.toml

#min gas prices command
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025aCC\"/" ~/.cascadiad/config/app.toml

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







