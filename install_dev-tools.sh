#!/bin/bash

echo "=== Установка инструментов ==="

if command -v docker &> /dev/null; then
    echo "Docker уже установлен"
else
    echo "Установка Docker..."
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker $USER
    echo "Docker установлен"
fi

if docker compose version &> /dev/null; then
    echo "Docker Compose уже установлен"
else
    echo "Установка Docker Compose..."
    sudo apt-get install -y docker-compose-plugin
    echo "Docker Compose установлен"
fi

if command -v python3 &> /dev/null; then
    echo "Python уже установлен"
else
    echo "Установка Python..."
    sudo apt-get install -y python3 python3-pip python3-venv
    echo "Python установлен"
fi

if python3 -c "import django" 2>/dev/null; then
    echo "Django уже установлен"
else
    echo "Установка Django..."
    python3 -m pip install --user --break-system-packages django 2>/dev/null || python3 -m pip install --user django
    echo "Django установлен"
fi

echo ""
echo "=== Готово ==="
echo "Для использования Docker без sudo выполните: newgrp docker"
