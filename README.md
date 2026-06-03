# Database security & RBAC practices

Patterns applied in enterprise PostgreSQL environments (financial / public-sector systems).

## Principles

1. **Least privilege** — Application roles receive only required DML/DDL on specific schemas; no superuser for apps.
2. **Separation of duties** — DBA admin roles distinct from application and replication users.
3. **SCRAM-SHA-256** — Password encryption for PostgreSQL 14+ (`password_encryption = scram-sha-256`).
4. **Replication user** — `REPLICATION` attribute only; restricted in `pg_hba.conf` by source IP.
5. **Auditing** — DDL logging, connection logging, pgAudit or equivalent for sensitive schemas.
6. **Ownership hygiene** — Tables owned by module/schema owners, not mixed personal accounts (see template below).

## Replication authentication example

```sql
CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'use_vault_or_secret_file';
```

```
# pg_hba.conf
host  replication  replicator  <REPLICA_IP>/32  scram-sha-256
```

## Application role example

```sql
CREATE ROLE ifmis_app LOGIN PASSWORD '...';
GRANT CONNECT ON DATABASE ifmis_db TO ifmis_app;
GRANT USAGE ON SCHEMA public TO ifmis_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO ifmis_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ifmis_app;
```

## Monitoring user (non-superuser)

```sql
CREATE ROLE postgres_exporter LOGIN PASSWORD '...';
GRANT pg_monitor TO postgres_exporter;
```

## Ownership audit

Use `table_ownership_audit_template.txt` in this folder to document object owners before and after migrations.

## Related automation

Replica provisioning with secret files and `.pgpass` (mode 600): see `04-high-availability-replication/scripts/add_replica_v1.sh`.
