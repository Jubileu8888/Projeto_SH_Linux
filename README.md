# Automatizador de Rede

Este script em Bash oferece algumas funcionalidades para identificar e desligar computadores em uma rede local. O projeto visa proporcionar uma ferramenta simples para fins educacionais e administrativos.

## Opções Disponíveis

1. **Identificar quais computadores estão ligados:** Esta opção utiliza o comando `arp-scan` para identificar os IPs ativos na rede local. Em seguida, verifica se esses IPs respondem ao comando de ping.

2. **Desligar os computadores da rede:** Utiliza SSH para se conectar aos computadores identificados na rede e executa o comando de desligamento remoto. Certifique-se de configurar as variáveis `ssh_user` e `ssh_password` no script.

3. **Sair:** Encerra a execução do programa.

## Requisitos

- Ambiente Linux (ou similar) para executar comandos como `arp-scan` e `ssh`.
- Acesso SSH aos computadores que serão desligados.

## Instruções de Uso

1. Execute o script usando o comando `./test.sh`.
2. Selecione a opção desejada.
3. Siga as instruções apresentadas no console.

## Aviso Importante

Este script é destinado apenas para fins educacionais e administrativos. Certifique-se de ter permissões adequadas ao executar comandos que envolvam desligamento remoto.

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para sugerir melhorias ou novas funcionalidades para aprimorar a experiência de uso.

## Quem Fez

Este script foi desenvolvido por [Seu Nome ou Apelido](https://github.com/seu-usuario-do-github).
