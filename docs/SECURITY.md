# Security & Hardening Policy: DatabaseCreator

**SPDX-License-Identifier:** Apache-2.0  
**Copyright:** (c) 2024-2026 Vivek Umrao and DatabaseCreator contributors.

---

## 1. Threat Model & Security Posture

DatabaseCreator is primarily deployed on developer workstations, testing environments, and automated CI/CD runners. The primary security objectives are:
1. **Preventing Container Escape & Host Takeover**: Ensuring compromised or malicious database services cannot break out into the host OS.
2. **Preventing Plaintext Credential Exposure**: Avoiding leaking administrative secrets into version control, build manifests, or container image layer histories.
3. **Preventing Local System Denial of Service**: Ensuring file system operations, health probes, and process lifecycles do not hang, consume unbounded memory, or wipe host files.

---

## 2. Hardening Measures Implemented

### 2.1 Elimination of Universal `--privileged`
- **Vulnerability**: Legacy container runners often pass `--privileged=true` as a shortcut. This grants all 40+ Linux kernel capabilities (`CAP_SYS_ADMIN`, `CAP_NET_ADMIN`, `CAP_DAC_OVERRIDE`, etc.), disables AppArmor and SELinux profiles, and mounts all host `/dev` hardware devices into the container.
- **Remediation**: All database containers (MySQL, MariaDB, Postgres, MSSQL, DB2, MongoDB, Redis, ClickHouse, CockroachDB, Snowflake, Databricks) run with default restricted container privileges.
- **Oracle Specifics**: Oracle Autonomous Database Free requires FUSE (`/dev/fuse`) for internal Autonomous Database storage operations. DatabaseCreator grants only targeted parameters: `--cap-add SYS_ADMIN --device /dev/fuse`, keeping the remaining kernel surface restricted.

### 2.2 Rootless Daemonless Execution via Podman
- DatabaseCreator designates **Podman** as its primary engine.
- Rootless Podman maps `root` inside the container to the user's unprivileged `UID` on the host kernel via user namespaces (`userns`).
- Even in the event of an arbitrary code execution exploit within a database engine, the attacker gains only unprivileged host user rights.

### 2.3 Strict Least-Privilege File Permissions
- Insecure permissions such as `COPY --chmod=0777` (world-writable, executable) have been eradicated across all Dockerfiles.
- **Executable entrypoints**: Restricted to `0755` (`rwxr-xr-x`).
- **SQL scripts & configuration files**: Restricted to `0644` (`rw-r--r--`).

### 2.4 Strong Password & Authentication Enforcement
- **PostgreSQL**: Discontinued `POSTGRES_HOST_AUTH_METHOD trust` (which allowed anyone to connect without credentials). Enforced password authentication using `scram-sha-256`.
- **MSSQL**: Maintained strict CLR execution policies.

### 2.5 Credential Governance in Git
- [Database.properties](file:///home/user/work/DatabaseCreator/Database.properties) contains development-only default credentials.
- [.gitignore](file:///home/user/work/DatabaseCreator/.gitignore) strictly ignores:
  - `Database.properties.local`
  - `*.local.properties`
  - `*.env` (except `.env.example`)
  - `secrets/`
- Local overrides in `Database.properties.local` take precedence over default files without risking accidental commits.

---

## 3. Reporting a Security Issue

If you discover a vulnerability or security flaw in this project, please report it privately to the maintainers rather than opening a public issue.
