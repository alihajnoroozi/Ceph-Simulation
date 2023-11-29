sudo apt install -y socat conntrack bmon net-tools ipset

##########################
#   CRI-O Installation   #
##########################

sudo su
export http{,s}_proxy=http://192.168.64.250:8080
export VERSION=1.28
export OS=xUbuntu_22.04


echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/xUbuntu_22.04/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list
mkdir -p /usr/share/keyrings
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/xUbuntu_22.04/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg
apt update
apt install -y cri-o cri-o-runc
apt install -y cri-tools

########################
#   CNI Installation   #
########################
apt install -y containernetworking-plugins
wget https://github.com/containernetworking/plugins/releases/download/v1.3.0/cni-plugins-linux-amd64-v1.3.0.tgz
tar xzf cni-plugins-linux-amd64-v1.3.0.tgz
sudo cp dhcp  dummy  firewall  host-device  host-local  ipvlan  loopback  macvlan  portmap  ptp  sbr  static  tap  tuning  vlan  vrf bandwidth bridge /opt/cni/bin/
rm dhcp  dummy  firewall  host-device  host-local  ipvlan  loopback  macvlan  portmap  ptp  sbr  static  tap  tuning  vlan  vrf bandwidth bridge

###########################
#   CRI-O Configuration   #
###########################
sudo vim /etc/crio/crio.conf
# Uncomment network_dir & plugin_dirs
# add "/usr/lib/cni/", under plugin_dirs

# network_dir = "/etc/cni/net.d/"
# plugin_dirs = [
#         "/opt/cni/bin/",
#         "/usr/lib/cni/",
# ]

vim /etc/cni/net.d/100-crio-bridge.conflist
# {
#   "cniVersion": "1.0.0",
#   "name": "crio",
#   "plugins": [
#     {
#       "type": "bridge",
#       "bridge": "cni0",
#       "isGateway": true,
#       "ipMasq": true,
#       "hairpinMode": true,
#       "ipam": {
#         "type": "host-local",
#         "routes": [
#             { "dst": "0.0.0.0/0" },
#             { "dst": "::/0" }
#         ],
#         "ranges": [
#             [{ "subnet": "10.235.0.0/16" }]
#         ]
#       }
#     }
#   ]
# }

###########################
#   Proxy Configuration   #
###########################
sudo vim /lib/systemd/system/crio.service
# Environment=HTTP_PROXY=http://192.168.128.250:8080
# Environment=HTTPS_PROXY=http://192.168.128.250:8080
# Environment=NO_PROXY=localhost,192.168.0.0/16,10.0.0.0/8

sudo systemctl restart crio