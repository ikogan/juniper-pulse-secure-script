# Juniper Pulse Secure VPN Script

This script is based on the experimental Juniper support from
[OpenConnect](http://www.infradead.org/openconnect/juniper.html).

It's a simple script that uses Zenity to prompt the user for credentials
and provide feedback, gksu to obtain root, and openconnect to make the connection.

## Installing/Dependencies/Usage

The following packages must be installed in Ubuntu:

```
sudo apt-get install gksu zenity libssl-dev libxml2-dev vpnc-scripts
```

OpenConnect must be compiled from source for the experimental Juniper support:

```
wget ftp://ftp.infradead.org/pub/openconnect/openconnect-7.06.tar.gz
tar xzf openconnect-7.06.tar.gz{
cd openconnect-7.06
./configure --with-vpnc-script=/usr/share/vpnc-scripts/vpnc-script
make
sudo make install
```

Finally, simply place this script somewhere and `chmod +x` it. Then you'll
want to edit the script and change the `VPN_URL` variable at the top.
Ideally, create a `.desktop` entry
for this. http://askubuntu.com/questions/436891/create-a-desktop-file-that-opens-and-execute-a-command-in-a-terminal
has some information on how to create these files though it's not necessary
(or likely desirable) to do so for this script. An example might be:

```
[Desktop Entry]
Version=1.0
Name=VPN Conection
Comment=Connect to the VPN
Exec=bash "/home/${user}/juniper-pulse-secure-script/juniper-vpn-connect.sh start"
Icon=network-vpn
Terminal=true 
Type=Application
Categories=Internet;
```

Place this file into `~/.local/share/applications/SSL VPN.desktop`. Note that you'll
probably need to create another icon to stop the VPN. That'll be fixed later.