#!/bin/bash
# Script para habilitar pantalla completa dinámica en VMware con Arch Linux
# Autor: ChatGPT adaptado para Arch Linux

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
RESET="\e[00m"

clear
echo -e "${CYAN}"
echo "============================================="
echo " VMware Tools Setup para Arch Linux "
echo "============================================="
echo -e "${RESET}"

echo -e "${YELLOW}[+] Instalando paquetes necesarios...${RESET}"
sudo pacman -Syu --noconfirm open-vm-tools xf86-video-vmware xf86-input-vmmouse mesa

echo -e "\n${YELLOW}[+] Habilitando y arrancando servicios...${RESET}"
sudo systemctl enable --now vmtoolsd.service
sudo systemctl enable --now vmware-vmblock-fuse.service

echo -e "\n${YELLOW}[+] Configurando autoejecución de vmware-user...${RESET}"

# Detectar escritorio
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* || "$XDG_CURRENT_DESKTOP" == *"KDE"* || "$XDG_CURRENT_DESKTOP" == *"XFCE"* ]]; then
    mkdir -p ~/.config/autostart
    cat > ~/.config/autostart/vmware-user.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=vmware-user
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=VMware User
EOF
    echo -e "${GREEN}[+] Se agregó vmware-user al autostart de tu escritorio gráfico${RESET}"
elif [[ "$XDG_CURRENT_DESKTOP" == *"i3"* ]]; then
    mkdir -p ~/.config/i3
    if ! grep -q "vmware-user" ~/.config/i3/config 2>/dev/null; then
        echo 'exec --no-startup-id vmware-user' >> ~/.config/i3/config
        echo -e "${GREEN}[+] vmware-user agregado al config de i3${RESET}"
    else
        echo -e "${YELLOW}[!] vmware-user ya estaba en tu config de i3${RESET}"
    fi
else
    echo -e "${RED}[-] No se detectó escritorio soportado automáticamente.${RESET}"
    echo -e "${YELLOW}[!] Agrega 'vmware-user' al autostart manualmente.${RESET}"
fi

echo -e "\n${GREEN}[✔] Listo! Reinicia la máquina virtual y prueba pantalla completa dinámica.${RESET}"
