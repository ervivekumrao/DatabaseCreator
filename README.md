# Database Creator

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Engine](https://img.shields.io/badge/Engine-Podman_%7C_Docker-orange.svg)](#prerequisites--automatic-pre-flight-check)

A fast, unified developer CLI for spinning up containerized databases, in-memory caches, and lakehouse engines using
**Podman** (default, secure, rootless) with automatic fallback to **Docker**.

---

## Quickstart

Run `CreateDB.sh` from the repository root:

```bash
# Spin up PostgreSQL on port 5432
./CreateDB.sh -t postgres -p 5432 -n dev-pg

# Spin up Redis cache on port 6379
./CreateDB.sh -t redis -p 6379 -n dev-redis

# Spin up MySQL on port 3306 with persistent host storage
./CreateDB.sh -t mysql -p 3306 -n dev-mysql -d /data/mysql
```

---

## Prerequisites & Automatic Pre-Flight Check

You do **not** need to manually check dependencies. When you run `./CreateDB.sh`, the script automatically checks your
host system:

- **Default Engine:** Uses **Podman** (rootless and daemonless).
- **Fallback Engine:** If Podman is missing, it notifies you and uses **Docker**.
- **Missing Tools:** If any tool or container engine is missing, the script displays the **exact copy-paste install
  command** for your specific operating system (Ubuntu/Debian, Fedora/RHEL, Arch, Alpine, macOS, WSL).

To run the pre-flight check without launching a database:

```bash
./CreateDB.sh --preflight
```

---

## Supported Databases & Engines

| Option (`-t`) | Engine                                                 | Default Port    | Internal Data Path          |
|:--------------|:-------------------------------------------------------|:----------------|:----------------------------|
| `mysql`       | MySQL Community Server                                 | `3306`          | `/var/lib/mysql`            |
| `mariadb`     | MariaDB Server                                         | `3306`          | `/var/lib/mysql`            |
| `postgres`    | PostgreSQL                                             | `5432`          | `/var/lib/postgresql/data`  |
| `mssql`       | Microsoft SQL Server (2022)                            | `1433`          | `/var/opt/mssql`            |
| `oracle`      | Oracle Autonomous Database Free                        | `1521`          | `/opt/oracle/oradata`       |
| `db2`         | IBM DB2 Community Edition                              | `50000`         | `/database`                 |
| `mongodb`     | MongoDB Document Database                              | `27017`         | `/data/db`                  |
| `redis`       | Redis / Valkey Cache & Key-Value                       | `6379`          | `/data`                     |
| `clickhouse`  | ClickHouse Columnar Analytics (OLAP)                   | `8123` / `9000` | `/var/lib/clickhouse`       |
| `cockroach`   | CockroachDB Distributed SQL (Web UI: 8080)             | `26257`         | `/cockroach/cockroach-data` |
| `snowflake`   | Snowflake Local Emulator (DuckDB-backed)               | `8080`          | `/data`                     |
| `databricks`  | Databricks Local Engine (Spark + Delta Lake, UI: 4040) | `10000`         | `/opt/spark/data`           |

---

## CLI Options Reference

```bash
./CreateDB.sh [OPTIONS]
```

| Option | Long Option               | Description                                              | Default                               |
|:-------|:--------------------------|:---------------------------------------------------------|:--------------------------------------|
| `-t`   | `--database-type`         | Database vendor name (e.g. `mysql`, `postgres`, `redis`) | `mysql`                               |
| `-p`   | `--docker-port`, `--port` | Host port to map to the database                         | Engine default port                   |
| `-n`   | `--database-name`         | Container instance name                                  | `localdb`                             |
| `-v`   | `--database-version`      | Container image tag/version                              | `latest` (or `2022-latest` for MSSQL) |
| `-d`   | `--data-dir`, `--volume`  | Host directory or named volume for persistent storage    | Ephemeral container storage           |
| `-e`   | `--engine`                | Force container runtime (`podman` or `docker`)           | Auto-detected                         |
| `-c`   | `--check`, `--preflight`  | Run environment checkup only                             | -                                     |
| `-h`   | `--help`                  | Display usage instructions                               | -                                     |

---

## Managing Containers

Control database containers without remembering engine-specific syntax:

```bash
# View running database containers
./CreateDB.sh status [name]

# Follow container log output
./CreateDB.sh logs [name]

# Stop container
./CreateDB.sh stop [name]

# Remove container
./CreateDB.sh rm [name]
```

---

## Configuration & Credentials

Default database names, usernames, passwords, and reference JDBC connection strings are defined
in [Database.properties](Database.properties).

To customize credentials locally without modifying version-controlled files:

```bash
# Create local override (gitignored by default)
cp config/database.env.example Database.properties.local
```

---

## In-Depth Documentation

For advanced architecture, developer guides, security policies, and testing manuals, refer to the `docs/` directory:

- 📘 **[Architecture & Blueprint](docs/ARCHITECTURE.md)** — Modular subsystems, container lifecycles, and storage design.
- 🗄️ **[Database Engine Reference](docs/DATABASE_GUIDE.md)** — Connection strings (JDBC, Python, Node.js), client CLI
  commands, and schemas for all 12 engines.
- 🛡️ **[Security & Hardening Policy](docs/SECURITY.md)** — Rootless containers, privilege mitigation, and credential
  governance.
- 🧪 **[In-Depth Testing Manual](docs/TESTING.md)** — Test harness, unit tests, static linting, and CI/CD integration.

---

## Developer Automation (`Makefile`)

```bash
make preflight    # Check host tools and container engines
make lint         # Run static syntax and license checks
make test         # Run full test suite (lint + unit + integration)
make status       # Show running database instances
make clean        # Clean temporary build artifacts
```

---

## License

Licensed under the **Apache License, Version 2.0**. See [LICENSE](LICENSE) for details.
