
BinaryName="arkeod"
DirectName=".arkeo" #database directory
CustomPort="314"
NodeName="Arkeo"  # project folder
ChainID="arkeo"

install_binary() {
print_color $Blue "$BinaryName Kuruluyor..."
sleep 1
exec > /dev/null 2>&1
wget http://37.120.189.81/arkeo_testnet/arkeod
chmod +x arkeod
mv arkeod $HOME/go/bin/
source $HOME/.bash_profile
exec > /dev/tty 2>&1
print_color $Yellow "$BinaryName $($BinaryName version) Kuruldu."
sleep 1
}

snapshot() {
print_color $Blue "Snapshot İndiriliyor..."
curl -L http://37.120.189.81/arkeo_testnet/arkeo_snap.tar.lz4 | tar -I lz4 -xf - -C $HOME/.arkeo
}

config() {
print_color $Blue "Yapılandırma Dosyası Ayarları Yapılıyor..."
exec > /dev/null 2>&1
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/arkeo/addrbook.json > $HOME/$DirectName/config/addrbook.json
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/arkeo/genesis.json > $HOME/$DirectName/config/genesis.json
peers="8c2d799bcc4fbf44ef34bbd2631db5c3f4619e41@213.239.207.175:60656,e46d22832e1746d099c7a0e329cee8d904337718@65.109.48.181:32656,0c96f2b20f856186dbff5dd2e85640aaae8a6034@5.181.190.76:22856,cb9401d70e1bd59e3ed279942ce026dae82aca1f@65.109.33.48:27656,465600bad30995e46124d5ec23021f4845be2ece@38.242.210.137:26656,32ec9022a9565e490bf28ce6550739156fd1e41e@81.0.221.203:26656,374facfe63ab4c786d484c2d7d614063190590b7@88.99.213.25:38656,1eaeb5b9cb2cc1ae5a14d5b87d65fef89998b467@65.108.141.109:17656,9c0df85008e400b440232fdb7470c593fa07609a@154.53.56.176:30656,65c95f70cf0ca8948f6ff59e83b22df3f8484edf@65.108.226.183:22856"
seeds="0e1000e88125698264454a884812746c2eb4807@seeds.lavenderfive.com:22856"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/$DirectName/config/config.toml
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001uarkeo"|g' $HOME/.arkeo/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.arkeo/config/config.toml


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






