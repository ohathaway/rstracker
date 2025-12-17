-- Update progress table to better support Rocksmith scores
-- The completion_percentage field already exists and can store 0-100 values
-- We just need to update the logic to use 95% as the "complete" threshold

-- Add a comment to clarify the field usage
-- completion_percentage now represents the Rocksmith score (0-100%)
-- 95% or higher is considered "complete"

-- Update any existing 100% entries to be more realistic if needed
-- (This is optional - you can keep existing data as-is)

-- Add an index for better performance on completion queries
CREATE INDEX IF NOT EXISTS idx_progress_completion ON progress(completion_percentage);

-- Add an index for player queries
CREATE INDEX IF NOT EXISTS idx_progress_player ON progress(player_id);