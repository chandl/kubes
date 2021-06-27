# kubes

A collection of kubernetes tools that I use for a rasp pi cluster


* `/mnt/hdd` NFS mounted across all nodes 
* `certbot` with `certbot-cloudflare` used to generate wildcard certs


* setup pfsense to use nordvpn - https://support.nordvpn.com/Connectivity/Router/1626958942/pfSense-2-5-Setup-with-NordVPN.htm
    * added firewall rule making lab hosts go through vpn gateway 
    * added firewall rule disallowing traffic from these hosts not through vpn 
    * updated pfsense System > Advanced, Miscellaneous tab, check "Skip rules when gateway is down".

