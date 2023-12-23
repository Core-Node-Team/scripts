BinaryName="elysd"
DirectName=".elys" #database directory
CustomPort="313"
NodeName="elys"  # project folder
ChainID="elystestnet-1"

install_binary() {
print_color $Blue "$BinaryName Kuruluyor..."
sleep 1
exec > /dev/null 2>&1
git clone https://github.com/elys-network/elys.git
cd elys
git checkout v0.18.0
make install
source $HOME/.bash_profile
print_color $Yellow "$BinaryName $($BinaryName version) Kuruldu."
sleep 1
}

snapshot() {
print_color $Blue "Snapshot İndiriliyor..."
curl -L http://37.120.189.81/elys_testnet/elys_snap.tar.lz4 | tar -I lz4 -xf - -C $HOME/.elys
}

config() {
print_color $Blue "Yapılandırma Dosyası Ayarları Yapılıyor..."
exec > /dev/null 2>&1
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/elys/addrbook.json > $HOME/$DirectName/config/addrbook.json
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/elys/genesis.json > $HOME/$DirectName/config/genesis.json
peers="258f523c96efde50d5fe0a9faeea8a3e83be22ca@seed.elystestnet-1.elys.aviaone.com:20273"
seeds="ae7191b2b922c6a59456588c3a262df518b0d130@elys-testnet-seed.itrocket.net:38656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/$DirectName/config/config.toml
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.0uelys"/g' $HOME/.elys/config/app.toml


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

cosmovisor() {
exec > /dev/null 2>&1
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@latest
mkdir -p ~/.elys/cosmovisor/genesis/bin && mkdir -p ~/.elys/cosmovisor/upgrades
cp $(which elysd) ~/.elys/cosmovisor/genesis/bin/

sudo tee /etc/systemd/system/elysd.service > /dev/null <<EOF
[Unit] 
Description=Elys Network node 
After=network.target
[Service] 
Type=simple 
Restart=on-failure 
RestartSec=5 
User=$USER 
ExecStart=$(which cosmovisor) run start
LimitNOFILE=65535
Environment="DAEMON_NAME=elysd"
Environment="DAEMON_HOME=$HOME/.elys"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=false"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="UNSAFE_SKIP_BACKUP=true"
[Install] 
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable $BinaryName
systemctl start $BinaryName
systemctl restart $BinaryName
exec > /dev/tty 2>&1
}


