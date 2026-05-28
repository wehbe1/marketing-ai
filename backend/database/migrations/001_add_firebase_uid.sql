-- Migration: add Firebase auth columns to users table
-- Run once on existing PostgreSQL databases before deploying Firebase auth.

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS firebase_uid VARCHAR(128);

ALTER TABLE users
    ALTER COLUMN hashed_password DROP NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_users_firebase_uid
    ON users (firebase_uid)
    WHERE firebase_uid IS NOT NULL;
