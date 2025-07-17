export default defineEventHandler(async (event) => {
  const { database } = await hubDatabase()
  
  // Get all songs with their completion status for both players
  const songs = await database.prepare(`
    SELECT 
      s.id,
      s.title,
      s.artist,
      s.year,
      s.created_at,
      p1.completion_percentage as player1_completion,
      p1.completed_at as player1_completed_at,
      p2.completion_percentage as player2_completion,
      p2.completed_at as player2_completed_at
    FROM songs s
    LEFT JOIN progress p1 ON s.id = p1.song_id AND p1.player_id = 1
    LEFT JOIN progress p2 ON s.id = p2.song_id AND p2.player_id = 2
    ORDER BY s.year ASC, s.title ASC
  `).all()
  
  return songs
})