export default defineEventHandler(async (event) => {
  const { database } = await hubDatabase()
  const body = await readBody(event)
  
  const { player_id, song_id, completion_percentage = 0, notes = '' } = body
  
  if (!player_id || !song_id) {
    throw createError({
      statusCode: 400,
      statusMessage: 'player_id and song_id are required'
    })
  }
  
  // Check if completion percentage is 100 to set completed_at
  const completed_at = completion_percentage === 100 ? new Date().toISOString() : null
  
  try {
    // Insert or update progress
    const result = await database.prepare(`
      INSERT INTO progress (player_id, song_id, completion_percentage, completed_at, notes)
      VALUES (?, ?, ?, ?, ?)
      ON CONFLICT(player_id, song_id) DO UPDATE SET
        completion_percentage = excluded.completion_percentage,
        completed_at = excluded.completed_at,
        notes = excluded.notes,
        created_at = CURRENT_TIMESTAMP
    `).run(player_id, song_id, completion_percentage, completed_at, notes)
    
    return { success: true, id: result.meta.last_row_id }
  } catch (error) {
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to update progress'
    })
  }
})