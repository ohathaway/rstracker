export default defineEventHandler(async (event) => {
  const { database } = await hubDatabase()
  
  const players = await database.prepare(`
    SELECT 
      p.id,
      p.name,
      p.avatar_url,
      p.created_at,
      COUNT(pr.id) as completed_songs
    FROM players p
    LEFT JOIN progress pr ON p.id = pr.player_id AND pr.completion_percentage = 100
    GROUP BY p.id, p.name, p.avatar_url, p.created_at
    ORDER BY p.id ASC
  `).all()
  
  return players
})