# Manual Deployment M03

## Application Path
`/srv/cc-m03`

## Service
`cc-m03.service` (systemd, file di `/etc/systemd/system/cc-m03.service`)

## Backend
`127.0.0.1:8000` (Gunicorn, 1 worker, 2 thread)

## Reverse Proxy
Caddy listen di port 80, meneruskan ke `127.0.0.1:8000`
(konfigurasi di `/etc/caddy/Caddyfile`)

## Public Endpoint
`http://40.83.96.115/`

## Health Check
`http://40.83.96.115/health`

## Update Procedure

```bash
cd /srv/cc-m03
git pull
source .venv/bin/activate
python -m pip install -r requirements.txt
sudo systemctl restart cc-m03
sudo systemctl status cc-m03 --no-pager
curl -fsS http://127.0.0.1:8000/health
curl -fsS http://127.0.0.1/health
```

Terakhir, tes dari client eksternal:
`curl http://40.83.96.115/health`

## Rollback Dasar

```bash
git log --oneline --decorate -10
git checkout m03
sudo systemctl restart cc-m03
```

Kembali ke versi terbaru:

```bash
git switch main
sudo systemctl restart cc-m03
```

## Logs

```bash
sudo journalctl -u cc-m03 -n 50 --no-pager
sudo journalctl -u caddy -n 50 --no-pager
```
