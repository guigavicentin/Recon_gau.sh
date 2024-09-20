#!/bin/bash

# Verificar programas instalados
for cmd in amass gau katana nmap; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd não está instalado. Instale antes de iniciar."
        exit 1
    fi
done

# Solicita dominio
read -p "Digite o domínio (exemplo: dominio.com): " DOMAIN

# Verifica se o domínio foi informado
if [ -z "$DOMAIN" ]; then
    echo "Domínio não informado. Encerrando."
    exit 1
fi

# Solicita o nome da pasta ao usuário
read -p "Digite o nome da pasta onde os resultados serão salvos: " PASTA

# Cria a pasta com o nome informado
mkdir -p "$PASTA"

# Define os nomes dos arquivos de saída
AMASS_FILE="$PASTA/amass_$DOMAIN.txt"
GAU_FILE="$PASTA/gau_$DOMAIN.txt"
KATANA_FILE="$PASTA/katana_$DOMAIN.txt"
IP_FILE="$PASTA/ips_$DOMAIN.txt"

# Varredura de subdomínios com Amass
echo "[*] Iniciando varredura de subdomínios com Amass..."
amass enum -d $DOMAIN -o "$AMASS_FILE"

# Valida IPs dos subdomínios e salva em um arquivo
echo "[*] Validando IPs dos subdomínios encontrados..."
cat "$AMASS_FILE" | xargs -I {} sh -c 'host {} | grep "has address" | awk "{print \$4}"' | sort -u > "$IP_FILE"

# Oferece opções para realizar uma varredura com Nmap
echo "Escolha uma das seguintes opções de varredura Nmap:"
echo "1. nmap -sS -Pn -p-"
echo "2. nmap -sP -p-"
echo "3. nmap -sS -f -p-"
echo "4. nmap -sS -D RND:10 -p- "
echo "5. nmap -sS -g 53 -p-"
echo "6. nmap -sS -T2 -p-"
echo "7. nmap -sS -p- --script firewall-bypass"
echo "8. nmap -sS -Pn -D RND:10 -p- -f"
echo "9. nmap -p- -sV"

read -p "Digite o número da opção desejada: " NMAP_OPTION

case $NMAP_OPTION in
    1)
        NMAP_CMD="nmap -sS -Pn -p-"
        ;;
    2)
        NMAP_CMD="nmap -sP -p-"
        ;;
    3)
        NMAP_CMD="nmap -sS -f -p-"
        ;;
    4)
        NMAP_CMD="nmap -sS -D RND:10 -p-"
        ;;
    5)
        NMAP_CMD="nmap -sS -g 53 -p-"
        ;;
    6)
        NMAP_CMD="nmap -sS -T2 -p-"
        ;;
    7)
        NMAP_CMD="nmap -sS -p- --script firewall-bypass"
        ;;
    8)
        NMAP_CMD="nmap -sS -Pn -D RND:10 -p- -f"
        ;;
    9)
        NMAP_CMD="nmap -p- -sV"
        ;;
    *)
        echo "Opção inválida. Encerrando."
        exit 1
        ;;
esac

echo "[*] Executando Nmap..."
while read -r ip; do
    $NMAP_CMD $ip -oN "$PASTA/nmap_$ip.txt"
done < "$IP_FILE"

# Executa GAU nos subdomínios encontrados
echo "[*] Executando GAU nos subdomínios encontrados..."
cat "$AMASS_FILE" | gau > "$GAU_FILE"

# Executa Katana
echo "[*] Executando Katana..."
katana -passive -pss waybackarchive,commoncrawl,alienvault -list "$AMASS_FILE" -o "$KATANA_FILE"

# Finalização
echo "[*] Varredura completa. Resultados salvos na pasta $PASTA."
