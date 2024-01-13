BinaryName="artelad"
DirectName=".artelad" #database directory
CustomPort="317"
NodeName="artela"  # project folder
ChainID="artela_11822-1"

install_binary() {
print_color $Blue "$BinaryName Kuruluyor..."
sleep 1
exec > /dev/null 2>&1
cd $HOME
rm -rf artela
git clone https://github.com/artela-network/artela
cd artela
git checkout v0.4.7-rc4
make install
source $HOME/.bash_profile
exec > /dev/tty 2>&1
print_color $Yellow "$BinaryName $($BinaryName version) Kuruldu."
sleep 1
}

snapshot() {
print_color $Blue "Snapshot İndiriliyor..."
curl -L http://37.120.189.81/artela_testnet/artela_snap.tar.lz4 | tar -I lz4 -xf - -C $HOME/.artelad
}

config() {
print_color $Blue "Yapılandırma Dosyası Ayarları Yapılıyor..."
exec > /dev/null 2>&1
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/artela/addrbook.json > $HOME/$DirectName/config/addrbook.json
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/artela/genesis.json > $HOME/$DirectName/config/genesis.json
SEEDS=""
PEERS="a996136dcb9f63c7ddef626c70ef488cc9e263b8@144.217.68.182:22256,de5612c035bd1875f0bd36d7cbf5d660b0d1e943@5.78.64.11:26656,bec6934fcddbac139bdecce19f81510cb5e02949@47.254.24.106:26656,30fb0055aced21472a01911353101bc4cd356bb3@47.89.230.117:26656,a03ae11a093c67e2554b73d174c4168fe715af10@57.128.103.184:26656,146d6011cce0423f564c9277c6a3390657c53730@157.90.226.23:26656,0188a9bcff4f411b29dbddda527d77803396e1c6@185.245.182.180:26656,b23bc610c374fd071c20ce4a2349bf91b8fbd7db@65.108.72.233:11656,aa416d3628dcce6e87d4b92d1867c8eca36a70a7@47.254.93.86:26656,978dee673bd447147f61aa5a1bdaabdfb8f8b853@47.88.57.107:26656,35ce36af33e289a29787eedb3127d21bf10edcff@81.0.218.194:45656,32d0e4aec8d8a8e33273337e1821f2fe2309539a@47.88.58.36:26656,1b73ac616d74375932fb6847ec67eee4a98174e9@116.202.85.52:25556,9e2fbfc4b32a1b013e53f3fc9b45638f4cddee36@47.254.66.177:26656,b23bc610c374fd071c20ce4a2349bf91b8fbd7db@65.108.72.233:11656,30fb0055aced21472a01911353101bc4cd356bb3@47.89.230.117:26656,9e2fbfc4b32a1b013e53f3fc9b45638f4cddee36@47.254.66.177:26656,978dee673bd447147f61aa5a1bdaabdfb8f8b853@47.88.57.107:26656,aa416d3628dcce6e87d4b92d1867c8eca36a70a7@47.254.93.86:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.artelad/config/config.toml
# min gas price
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.025art"|g' $HOME/.artelad/config/app.toml


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





