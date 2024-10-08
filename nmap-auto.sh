#!/bin/bash

if [ -z "$1" ]; then
    echo -e "e\[33m [*]Uso:e\ e\[32m ./nmap-auto.sh \e[0m" "\e[31m{IP}\e[0m"
    echo 1
fi

# Dicecion de guardado del reporte
REPORT_DIR="$PWD"
REPORT="$REPORT_DIR/Scan$(date +%H:%M).txt"

# Mensaje
echo -e "\n[*] Iniciando escaneo de puertos para $1..."
echo -e "[*]El reporte se guardará en $REPORT"

# Tipos de escaneo:

# Escaneo de puertos abiertos
echo -e "\e[31m Escaneando Puertos Abiertos...\e[0m"
open_port=$(nmap --open -p- -sS --min-rate 5000 -n -Pn $1)
port_scan=$(echo "$open_port" | awk '/^[0-9]+\/tcp/ {print $1}' | cut -d'/' -f1)
echo -e "\n---Puertos Encontrados---" | tee -a $REPORT
echo -e "$open_port\n" | tee -a $REPORT

# Escaneo de servicios en los puertos abiertos
if [ -n "$port_scan" ]; then
    echo -e "\e[31m Escaneando Servicios...\e[0m"
    service_scan=$(nmap -sC -sV --version-intensity 0 -Pn -T4 -p$port_scan $1)
    echo -e "[*]Servicios:" | tee -a $REPORT
    echo -e "$service_scan\n"| tee -a $REPORT
else
    echo "[*]No se encontraron puertos comunes." | tee -a $REPORT
fi

echo -e "\n---Escaneo Completado---\n"
echo -e "[*]Reporte final  en $REPORT"
