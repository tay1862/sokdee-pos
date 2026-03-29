# SOKDEE POS — Deploy Guide

## ขั้นตอนครั้งแรก (ทำแค่ครั้งเดียว)

### 1. ตั้งค่า GitHub Secrets

ไปที่ `https://github.com/tay1862/sokdee-pos/settings/secrets/actions` แล้วเพิ่ม:

| Secret | ค่า |
|--------|-----|
| `VPS_HOST` | `217.216.75.64` |
| `VPS_USER` | `root` |
| `VPS_PASSWORD` | รหัสผ่าน VPS |

### 2. Bootstrap VPS (ทำครั้งเดียว)

SSH เข้า VPS แล้วรัน:
```bash
curl -fsSL https://raw.githubusercontent.com/tay1862/sokdee-pos/main/deploy/bootstrap.sh | bash
```

### 3. ตั้งค่า .env บน VPS

```bash
nano /opt/sokdee-pos/.env
```

ใส่ค่าจริง:
```
DB_PASSWORD=รหัสผ่านที่แข็งแกร่ง
JWT_SECRET=สุ่มด้วย: openssl rand -hex 32
JWT_REFRESH_SECRET=สุ่มด้วย: openssl rand -hex 32
```

### 4. Start ครั้งแรก

```bash
cd /opt/sokdee-pos
docker compose up -d
```

---

## หลังจากนั้น — Auto Deploy

ทุกครั้งที่ push ไป `main` branch:
1. GitHub Actions รัน tests
2. Build Docker image
3. Push ไป GitHub Container Registry
4. SSH เข้า VPS แล้ว pull image ใหม่ + restart

ไม่ต้องทำอะไรเพิ่มเลย

---

## คำสั่งที่ใช้บ่อยบน VPS

```bash
# ดู status
docker compose ps

# ดู logs
docker compose logs -f api

# Restart
docker compose restart api

# Update manual
cd /opt/sokdee-pos && git pull && docker compose pull && docker compose up -d
```

## Endpoints

- API: `http://217.216.75.64/api/v1/`
- Health: `http://217.216.75.64/health`
- WebSocket KDS: `ws://217.216.75.64/ws/kds`
