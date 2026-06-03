-- Audit logging template (complement with pgAudit in production)

-- Log DDL statements
ALTER SYSTEM SET log_statement = 'ddl';
SELECT pg_reload_conf();

-- Log connections (adjust for volume)
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;

-- Role change audit (example trigger pattern)
CREATE TABLE IF NOT EXISTS audit_role_changes (
  id bigserial PRIMARY KEY,
  changed_at timestamptz DEFAULT now(),
  rolename name,
  action text
);

-- Review: SELECT * FROM audit_role_changes ORDER BY changed_at DESC LIMIT 50;
