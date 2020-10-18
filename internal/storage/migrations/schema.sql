-- Create table for storing themes --
DROP TABLE IF EXISTS theme;

CREATE TABLE IF NOT EXISTS themes (
  id SERIAL NOT NULL PRIMARY KEY,
  json_theme JSON NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create function for keeping `updated_at` updated with current timestamp
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
    RETURNS trigger AS
$$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$
    LANGUAGE 'plpgsql';

-- Create trigger to call the function we created to keep updated_at updated
DROP trigger IF EXISTS urls_updated_at ON themes;
CREATE trigger themes_updated_at
    BEFORE UPDATE ON themes FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_timestamp();
