# Limpar todas as regras do firewall (tenha cuidado ao usar este comando)
iptables -F

# Definir uma política padrão para permitir o tráfego de saída
iptables -P OUTPUT ACCEPT



    # ip da rede que ira ser bloqueada
    server_ip="192.168.2.0"

    ip_file="ips.txt"

    iptables -F

    iptables -P OUTPUT ACCEPT

    iptables -A OUTPUT -d "$server_ip" -j ACCEPT

    while IFS= read -r ip; do
    iptables -A OUTPUT -d "$ip" -j DROP
    done < "$ip_file"

    iptables -P OUTPUT DROP