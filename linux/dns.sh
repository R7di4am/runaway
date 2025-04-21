#!/bin/bash
set -e
DNS1="78.157.42.100"
DNS2="78.157.42.101"

connections=$(nmcli -t -f NAME connection show --active)

if [ -z "$1" ]; then
  echo -e "\e[32m[+] Setting custom DNS to $DNS1 and $DNS2...\e[0m"
  for conn in $connections; do
    echo "→ Modifying: $conn"
    nmcli connection modify "$conn" ipv4.dns "$DNS1 $DNS2"
    nmcli connection modify "$conn" ipv4.ignore-auto-dns yes
    nmcli connection modify "$conn" ipv6.ignore-auto-dns yes 2>/dev/null
    nmcli connection down "$conn" && nmcli connection up "$conn"
  done
  echo -e "\n \e[32mDNS successfully set for all active connections.\e[0m"
else
  echo -e "\e[33m[-] Resetting DNS to automatic (DHCP)...\e[0m"
  for conn in $connections; do
    echo "→ Resetting: $conn"
    nmcli connection modify "$conn" ipv4.ignore-auto-dns no
    nmcli connection modify "$conn" ipv4.dns ""
    nmcli connection modify "$conn" ipv6.ignore-auto-dns no 2>/dev/null
    nmcli connection modify "$conn" ipv6.dns "" 2>/dev/null
    nmcli connection down "$conn" && nmcli connection up "$conn"
  done
  echo -e "\n \e[33mDNS reset to default for all active connections.\e[0m"
fi
