#!/bin/bash

echo "------------------------------------------------------------"
echo "---------------------Digite uma opção-----------------------"
echo "------------------------------------------------------------"

# opções
echo "1-Indentificar quais computadores estão ligados."
echo "2-Desligar os computadores da rede."
echo "3-Sair."
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
        # "awk" é usado para extrair informações específicas de saidas de comandos
        sudo arp-scan --localnet | awk '/^[0-9]+.[0-9]+.[0-9]+.[0-9]+/ {print $1}' > ips.txt # aqui foi usado awk para extrair os ips do comando arp-scan --localnet
        ifconfig | grep -A1 "$(ip r | grep default | awk '{print $5}')" | awk '/netmask/ {print $4}' > mascara.txt # awk foi ultilizado para extrair a mascara ip pelo comando ifconfig
        echo "Lista de todos os ips disponiveis da sua rede local."
        cat ips.txt

        echo "------------------------------------------------------------"
        echo "-------------------Verificação do ping----------------------"
        echo "------------------------------------------------------------"
        # verificando se os ips que o comando deu estão respondendo o ping.

        #Estrutura comumente usada para ler linhas de um arquivo ou da saída de um comando, uma linha por vez.
        #O IFS é responsavel em que a linha lida seja tratada como uma unica variavel string completa.
        #O read -r ip, lê uma linha do input e atribui essa linha a variavel ip, e o -r desativa a interpretação de barras invertidas e de caracteres especiais.
        while IFS= read -r ip; do

        ping -c 2 "$ip" &>/dev/null
        
        # verifica se o comando anterior foi executado com sucesso. Se o status de saída for zero, o bloco de comandos dentro do then será executado.
        # A variavel $? é uma variável especial em shell que contém o status de saída do último comando executado o valor 0 significa que o comando foi executado com sucesso.
        # -eq significa "=" "igual"
        if [ $? -eq 0 ]; then
        echo "O IP $ip está respondendo o ping."
        else
        echo "O IP $ip não está respondendo o ping."
        fi
    done < "ips.txt"
    sleep 5
    clear
    bash ./test.sh
;;
# fim op1
# comeco op2
2)
    echo "------------------------------------------------------------"
    echo "-------------------Desligar computadores--------------------"
    echo "------------------------------------------------------------"


# Coletando o arquivo txt que possui os ips ligados na rede.
ip_file="ips.txt"

# Coletando user do SSH destino.
ssh_user="admin"

#Coletando senha do ssh destino
ssh_password="admin"

#Estrutura comumente usada para ler linhas de um arquivo ou da saída de um comando, uma linha por vez.
#O IFS é responsavel em que a linha lida seja tratada como uma unica variavel string completa.
#O read -r ip, lê uma linha do input e atribui essa linha a variavel ip, e o -r desativa a interpretação de barras invertidas e de caracteres especiais.
while IFS= read -r ip; do

    ssh -p "$ssh_password"
    # comando remoto via SSH para desligar o computador remoto.
    # O -n Redireciona a entrada padrão do comando remoto a partir de /dev/null. Isso é útil quando você não precisa de interação interativa com o shell remoto.
    # Força um pseudo-tty a ser alocado. Isso é usado para interagir com comandos interativos.
    # "echo '$ssh_password' | sudo -S nohup init 0": Este é o comando que está sendo executado no host remoto.
    # nohup é usado para garantir que o comando continue a ser executado mesmo se a conexão SSH for encerrada.
    ssh -n -t "$ssh_user@$ip" "echo '$ssh_password' | sudo -S nohup init 0"
    
    # verifica se o comando anterior foi executado com sucesso. Se o status de saída for zero, o bloco de comandos dentro do then será executado.
    # A variavel $? é uma variável especial em shell que contém o status de saída do último comando executado o valor 0 significa que o comando foi executado com sucesso.
    # -eq significa "=" "igual"
    if [ $? -eq 0 ]; then
        echo "Desligamento bem-sucedido para o IP $ip."
    else
        echo "Falha ao desligar o IP $ip."
    fi
done < "$ip_file"
sleep 3
clear
bash ./test.sh
    ;;
    3)
    echo "Saindo do progama."
    exit
    ;;
# fimop2
esac
#fim do case
