#!/bin/bash

# ================================
#   Arch Linux VMware Tools Setup
# ================================

# 🎨 Colores
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
CYAN="\e[36m"
LBLUE="\e[94m"
RESET="\e[0m"

# 🎨 Banner
ART="
=============================================
 Arch Linux - VMware Tools (open-vm-tools)
=============================================
 By: @GeK
"
printf "${CYAN}${ART}${RESET}\n"

# Función: instalar open-vm-tools
install_vmtools() {
    printf "${YELLOW}[!]${RESET} Instalando 'open-vm-tools'...\n"
    sudo pacman -Syu --noconfirm open-vm-tools xf86-input-vmmouse xf86-video-vmware mesa
    printf "${GREEN}[+]${RESET} Paquete 'open-vm-tools' instalado correctamente\n\n"
}

# Función: habilitar servicios
enable_services() {
    printf "${LBLUE}[*]${RESET} Habilitando servicios de VMware Tools...\n"
    sleep 1

    sudo systemctl enable --now vmtoolsd.service
    sudo systemctl enable --now vmware-vmblock-fuse.service

    printf "${GREEN}[+]${RESET} Servicios activados:\n"
    printf "   - vmtoolsd.service\n"
    printf "   - vmware-vmblock-fuse.service\n\n"
}

# Función: verificar instalación
check_vmtools() {
    if ! command -v vmware-user-suid-wrapper &>/dev/null; then
        printf "${RED}[-]${RESET} 'open-vm-tools' no está instalado\n"
        printf "${YELLOW}[?]${RESET} ¿Deseas instalarlo ahora? [Y/n]: "
        read -r USER_INPUT
        if [[ -z "$USER_INPUT" || "$USER_INPUT" =~ ^[Yy]$ ]]; then
            install_vmtools
            enable_services
        else
            printf "${RED}[-]${RESET} Cancelado por el usuario.\n"
            exit 1
        fi
    else
        printf "${GREEN}[+]${RESET} 'open-vm-tools' ya está instalado ✅\n\n"
        enable_services
    fi
}

# ================================
#   MAIN
# ================================
check_vmtools

printf "${GREEN}[✓]${RESET} Configuración completada.\n"
printf "${LBLUE}[*]${RESET} Ahora reinicia tu VM para aplicar los cambios.\n"
