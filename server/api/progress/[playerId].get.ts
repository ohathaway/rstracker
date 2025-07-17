export default defineEventHandler(async (event) => {
  const { database } = await hubDatabase()
  const playerId = getRouterParam(event, 'playerId')
  
  if (!playerId) {
    throw createError({
      statusCode: 400,
      statusMessage: 'playerId is required'
    })
  }
  
  const progress = await database.prepare(`
    SELECT 
      p.id,
      p.player_id,
      p.song_id,
      p.completion_percentage,
      p.completed_at,
      p.notes,
      p.created_at,
      s.title as song_title,
      s.artist as song_artist,
      s.year as song_year
    FROM progress p
    JOIN songs s ON p.song_id = s.id
    WHERE p.player_id = ?
    ORDER BY p.created_at DESC
  `).all(playerId)
  
  return progress
})