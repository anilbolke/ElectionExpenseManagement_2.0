-- ===========================================================================
-- Add nomination_id column to candidates table
-- Date: 2025-10-20
-- ===========================================================================

-- Add nomination_id column after constituency
ALTER TABLE candidates 
ADD COLUMN nomination_id VARCHAR(50) NULL
AFTER constituency;

-- Add index on nomination_id for faster lookups
CREATE INDEX idx_nomination_id ON candidates(nomination_id);

-- Verify the column was added
DESCRIBE candidates;

-- Optional: Update existing records with placeholder values
-- UPDATE candidates SET nomination_id = CONCAT('NOM-', candidate_id) WHERE nomination_id IS NULL;

SELECT 'nomination_id column added successfully!' as status;
