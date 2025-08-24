#!/bin/bash
# =====================================================
# VMware Tools Setup para Arch Linux (2025)
# =====================================================

echo -e "\n========================================"
echo -e " VMware Tools Setup para Arch Linux"
echo -e "========================================\n"

# 1) Instalar paquetes necesarios
echo -e "[+] Instalando paquetes necesarios..."
sudo pacman -Syu --noconfirm open-vm-tools mesa xf86-input-vmmouse || {
    echo -e "[-] Error instalando paquetes."
    exit 1
}

# 2) Habilitar servicio de open-vm-tools
echo -e "\n[+] Habilitando y arrancando vmtoolsd..."
sudo systemctl enable --now vmtoolsd.service || {
    echo -e "[-] No se pudo habilitar vmtoolsd.service"
}

# 3) Configurar autostart de vmware-user
echo -e "\n[+] Configurando autoejecución de vmware-user..."
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

echo -e "\n[+] Archivo de autostart creado en ~/.config/autostart/vmware-user.desktop"

# 4) Mensaje final
echo -e "\n✅ Listo! Reinicia la máquina virtual y prueba la pantalla completa dinámica."
