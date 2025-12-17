import { sql } from 'drizzle-orm'

export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  const { player_id, song_id, score, notes = '' } = body

  if (!player_id || !song_id) {
    throw createError({
      statusCode: 400,
      statusMessage: 'player_id and song_id are required'
    })
  }

  if (score === undefined || score < 0 || score > 100) {
    throw createError({
      statusCode: 400,
      statusMessage: 'score must be a percentage between 0 and 100'
    })
  }

  // Check if score is 95% or higher to set completed_at
  const completed_at = score >= 95 ? new Date().toISOString() : null

  try {
    // Insert or update progress
    const result = await db.run(sql`
      INSERT INTO progress (player_id, song_id, completion_percentage, completed_at, notes)
      VALUES (${player_id}, ${song_id}, ${score}, ${completed_at}, ${notes})
      ON CONFLICT(player_id, song_id) DO UPDATE SET
        completion_percentage = excluded.completion_percentage,
        completed_at = excluded.completed_at,
        notes = excluded.notes,
        created_at = CURRENT_TIMESTAMP
    `)

    return { success: true, id: result.meta.last_row_id }
  } catch (error) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to update progress'
    })
  }
})