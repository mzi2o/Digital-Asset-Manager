BEGIN;

ALTER TABLE users ADD COLUMN IF NOT EXISTS username text;

WITH candidates AS (
  SELECT
    id,
    lower(regexp_replace(split_part(email, '@', 1), '[^a-z0-9._-]+', '_', 'g')) AS base_username,
    row_number() OVER (
      PARTITION BY lower(regexp_replace(split_part(email, '@', 1), '[^a-z0-9._-]+', '_', 'g'))
      ORDER BY id
    ) AS duplicate_number
  FROM users
), assigned AS (
  SELECT
    id,
    CASE WHEN duplicate_number = 1
      THEN base_username
      ELSE base_username || '_' || id::text
    END AS username
  FROM candidates
)
UPDATE users AS target
SET username = assigned.username
FROM assigned
WHERE target.id = assigned.id
  AND (target.username IS NULL OR btrim(target.username) = '');

CREATE UNIQUE INDEX IF NOT EXISTS users_username_unique ON users (username);
ALTER TABLE users ALTER COLUMN username SET NOT NULL;

COMMIT;
