#!/bin/bash

echo "------------------------------------------------------------"
echo "---------------------Digite uma opção-----------------------"
echo "------------------------------------------------------------"

# opções
echo "1-Indentificar quais computadores estão ligados."
echo "2-Desligar os computadores da rede."
echo "3-Bloquear internet"
echo "Digite uma opção: "
read op
clear

# estruturas op

# comeco op1
case $op in
    1)
        echo "------------------------------------------------------------"
        echo "-----------------------Computadores-------------------------"
        echo "------------------------------------------------------------"
        arp-scan --localnet | awk '/^[0-9]+.[0-9]+.[0-9]+.[0-9]+/ {print $1}' > ips.txt
        ifconfig | grep -A1 "$(ip r | grep default | awk '{print $5}')" | awk '/netmask/ {print $4}' > mascara.txt
        echo "Lista de todos os ips disponiveis da sua rede local."
        cat ips.txt


        echo "------------------------------------------------------------"
        echo "-------------------Verificação do ping----------------------"
        echo "------------------------------------------------------------"
        # verificando se os ips que o comando deu estão respondendo o ping.
        while IFS= read -r ip; do

        ping -c 2 "$ip" &>/dev/null
        
        if [ $? -eq 0 ]; then
        echo "O IP $ip está respondendo o ping."
        else
        echo "O IP $ip não está respondendo o ping."
        fi
    done < "ips.txt"
;;
# fim op1
# comeco op2
2)
    echo "------------------------------------------------------------"
    echo "-------------------Desligar computadores--------------------"
    echo "------------------------------------------------------------"

ip_file="ips.txt"


ssh_user="seu_usuario_ssh"

shutdown_script="~/shutdown_script.sh"

# verificando arquivo dos ips
if [ -f "$ip_file" ]; then
#iniciando processo de desligar
  while IFS= read -r ip; do

    ssh "$ssh_user@$ip" "$shutdown_script"
    

    if [ $? -eq 0 ]; then
      echo "Desligamento bem-sucedido para o IP $ip."
    else
      echo "Falha ao desligar o IP $ip."
    fi
  done < "$ip_file"
else
  echo "Arquivo 'ips.txt' não encontrado."
fi
    ;;
    
# fimop2
# comeco op3
3)
    ip_file="ips.txt"

    network_interface="eth0"

    while IFS= read -r ip; do
    iptables -A OUTPUT -o "$network_interface" -d "$ip" -j DROP
    done < "$ip_file"

    ;;
# fimop3
# comeco op4
4)
    # Site permitido
    allowed_site="youtube.com"

    # Interface de rede
    network_interface="eth0"

    iptables -F

    iptables -P OUTPUT DROP

    iptables -A OUTPUT -o "$network_interface" -d "$allowed_site" -j ACCEPT
    ;;
esac
#fim do case
