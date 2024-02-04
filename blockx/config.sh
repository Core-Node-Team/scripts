BinaryName="blockxd"
DirectName=".blockxd" #database directory
CustomPort="122"
NodeName="blockx"  # project folder
ChainID="blockx_100-1"

install_binary() {
print_color $Blue "$BinaryName Kuruluyor..."
sleep 1
exec > /dev/null 2>&1
cd $HOME
rm -rf blockx
git clone https://github.com/BlockXLabs/BlockX-Genesis-Mainnet1 blockx
cd blockx
git checkout c940d186c0d118ea017f6abc00225fdd9b26fe14
make install
source $HOME/.bash_profile
exec > /dev/tty 2>&1
print_color $Yellow "$BinaryName $($BinaryName version) Kuruldu."
sleep 1
}

snapshot() {
print_color $Blue "Snapshot İndiriliyor..."
curl -L http://37.120.189.81/blockx_mainnet/blockx_snap.tar.lz4 | tar -I lz4 -xf - -C $HOME/.babylond
}

config() {
print_color $Blue "Yapılandırma Dosyası Ayarları Yapılıyor..."
exec > /dev/null 2>&1
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/blockx/addrbook.json > $HOME/$DirectName/config/addrbook.json
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/blockx/genesis.json > $HOME/$DirectName/config/genesis.json
sed -i -e "s|^seeds *=.*|seeds = \"5f5cfac5c38506fbb4275c19e87c4107ec48808d@seeds.nodex.one:12210\"|" $HOME/.blockxd/config/config.toml
# min gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0abcx\"|" $HOME/.blockxd/config/app.toml


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
