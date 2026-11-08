# Architecture v0.1

## Target Architecture (rencana M04 dan M05)

```mermaid
flowchart TD
    U["Pengguna (browser)"] -->|"HTTPS 443 (rencana M04)"| FW["Azure NSG + UFW"]
    subgraph VPS["VPS Azure Standard B2ats v2 - Ubuntu 24.04.5 LTS"]
        FW --> C["Caddy (TLS, redirect HTTP ke HTTPS)"]
        C --> G["Gunicorn 127.0.0.1:8000"]
        G --> F["Flask (RBAC, nomor unik, disposisi)"]
        F --> D[("SQLite")]
        F --> L[("Folder lampiran")]
    end
    D -. "backup harian terenkripsi (rencana M05)" .-> B[("Azure Blob Storage privat, LRS")]
    L -. "satu set dengan SQLite" .-> B
```

## Resource Constraints
- 2 vCPU
- 836 MiB RAM
- 29 GB disk
- Ubuntu Server 24.04.5 LTS, Python 3.12.3

## Security Decisions
- non-root administration (user cloudstudent)
- SSH key authentication (Ed25519)
- password SSH disabled, root login disabled
- UFW enabled, hanya port 22 dan 80
- backend loopback-only (127.0.0.1:8000)

## Current Limitations
- HTTP only
- single VPS
- no database
- no container
- no CI/CD

## Planned Evolution
- M04 DNS + HTTPS
- M05 persistent data
- M06 container
- M07 IaC
- M09 CI/CD
