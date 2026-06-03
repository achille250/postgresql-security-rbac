# PostgreSQL Security & RBAC

Role-based access control, **Row-Level Security (RLS)**, audit logging patterns, replication authentication, and object ownership audit templates for enterprise PostgreSQL.

**Author:** [Achille Cesar Ntwali](https://github.com/achille250) · Kigali, Rwanda

---

## Overview

Security primitives for multi-tenant and public-sector financial systems: least-privilege application roles, separated replication users, session context for RLS, and DDL/connection logging baselines.

---

## Repository structure

```
postgresql-security-rbac/
├── sql/
│   ├── grant_application_role_template.sql  # App role: CONNECT, schema grants
│   ├── row_level_security_example.sql       # RLS policies + session context
│   └── audit_logging_template.sql           # log_statement, connections
├── table_ownership_audit_template.txt       # Document object owners pre/post migration
└── README.md (this file)
```

---

## Quick start

### Application role (least privilege)

```sql
\i sql/grant_application_role_template.sql
-- Replace app_db, app_readwrite, passwords
```

### Row-Level Security

```sql
\i sql/row_level_security_example.sql
-- Set per session: SELECT set_config('app.current_entity_id', '<uuid>', false);
```

### Audit baseline

```sql
\i sql/audit_logging_template.sql
-- Production: prefer pgAudit for comprehensive audit trails
```

### Ownership review

Use `table_ownership_audit_template.txt` before/after schema migrations to avoid orphaned or personal-account owners.

---

## Security checklist

- [ ] SCRAM-SHA-256 for passwords (`password_encryption`)
- [ ] No superuser for applications
- [ ] Replication user: `REPLICATION` only, IP-restricted in `pg_hba.conf`
- [ ] Monitoring user: `pg_monitor` only
- [ ] Revoke `CREATE` on `public` from `PUBLIC` where applicable

---

## Related repositories

| Repo | Focus |
|------|--------|
| [postgresql-ha-replication](https://github.com/achille250/postgresql-ha-replication) | Replication auth (SCRAM, slots) |
| [postgresql-monitoring-stack](https://github.com/achille250/postgresql-monitoring-stack) | Monitoring user setup |
| [postgresql-performance-tuning](https://github.com/achille250/postgresql-performance-tuning) | Schema constraints |

---

## License

MIT — see [LICENSE](LICENSE).
