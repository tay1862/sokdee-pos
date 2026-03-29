#!/bin/bash
# รันครั้งเดียวบน VPS เพื่อติดตั้ง Docker
# curl -fsSL https://raw.githubusercontent.com/tay1862/sokdee-pos/main/deploy/bootstrap.sh | bash

set -e

echo "=== Installing Docker ==="
curl -fsSL https://get.docker.com | sh
systemctl enable docker
systemctl start docker

echo "=== Cloning repo ==="
git clone https://github.com/tay1862/sokdee-pos.git /opt/sokdee-pos
cd /opt/sokdee-pos

echo "=== Creating .env ==="
cp .env.example .env
echo ""
echo "⚠️  Edit /opt/sokdee-pos/.env with your secrets, then run:"
echo "   cd /opt/sokdee-pos && docker compose up -d"
