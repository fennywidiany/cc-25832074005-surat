# ADR-0001: Initial VPS Deployment Architecture

## Status
Accepted

## Context
VPS 1 vCPU, RAM 1 GB, disk 20 GB, Ubuntu Server 24.04.

## Decision
- Flask
- Gunicorn 1 worker
- systemd
- Caddy
- UFW
- GitHub

## Alternatives
1. Node.js + PM2
2. NGINX + Gunicorn
3. Docker
4. PHP-FPM

## Rationale
...

## Consequences
### Positive
...
### Negative
...

## Review Trigger
Review pada M06/M07.
