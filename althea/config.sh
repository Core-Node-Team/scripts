
BinaryName="althea"
DirectName=".althea" #database directory
CustomPort="315"
NodeName="althea-chain"  # project folder
ChainID="althea_417834-3"

install_binary() {
print_color $Blue "$BinaryName Kuruluyor..."
sleep 1
cd $HOME
mkdir -p $HOME/go/bin
wget -O $HOME/go/bin/althea https://github.com/althea-net/althea-L1/releases/download/v0.5.5/althea-linux-amd64
chmod +x $HOME/go/bin/althea
source $HOME/.bash_profile
source $HOME/.bash_profile
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
PEERS="6e1396c306d2d7f41dc199b16ecff2fd914eaa15@althea-testnet-peer.itrocket.net:19656,ff90784f12f93758d7e475a21ed9148c893bd8d9@65.109.231.70:26656,b757144eb49932f1d979b78f82f1d08f878310ef@[2a01:4f9:3051:19c2::2]:10056,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:15256,019988ce47565ad683b7675216e8fbcb171b841c@107.155.125.170:26656,bbf8ef70a32c3248a30ab10b2bff399e73c6e03c@65.21.198.100:21156,49a36f841a109b5fe3bc7cccea931e6e43ed450f@142.132.202.50:47656,c27cad7798d63dce11c1fa2ed5e6644537271ea4@95.165.149.94:26656,79875677d71e3213d34bd0fb8ede172d376bcff5@144.76.97.251:35656,f83cbd080df3486ff30ec91a6e134a17f00318ff@5.75.153.46:17886"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.althea/config/config.toml
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





