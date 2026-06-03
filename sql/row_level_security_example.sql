-- Row-Level Security (RLS) example pattern for multi-tenant / multi-entity applications
-- Replace table and column names for your environment.

-- 1. Enable RLS on a sensitive table
ALTER TABLE app_transaction ENABLE ROW LEVEL SECURITY;

-- 2. Force RLS for table owners (recommended in production)
ALTER TABLE app_transaction FORCE ROW LEVEL SECURITY;

-- 3. Policy: application role sees only its entity
CREATE POLICY entity_isolation_select ON app_transaction
  FOR SELECT
  TO app_role
  USING (entity_id = current_setting('app.current_entity_id')::uuid);

CREATE POLICY entity_isolation_write ON app_transaction
  FOR INSERT
  TO app_role
  WITH CHECK (entity_id = current_setting('app.current_entity_id')::uuid);

-- 4. Set session context from application (per connection)
-- SELECT set_config('app.current_entity_id', '<entity-uuid>', false);

-- 5. Audit: log DDL and role changes (complement with pgAudit or log_statement)
