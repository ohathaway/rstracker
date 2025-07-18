export default defineEventHandler(async (event) => {
  try {
    const db = hubDatabase()
    
    const result = db.prepare(`
      SELECT 
        p.id,
        p.name,
        p.avatar_url,
        p.created_at,
        COUNT(pr.id) as completed_songs
      FROM players p
      LEFT JOIN progress pr ON p.id = pr.player_id AND pr.completion_percentage >= 95
      GROUP BY p.id, p.name, p.avatar_url, p.created_at
      ORDER BY p.id ASC
    `).all()
    
    return result.results || result
  } catch (error) {
    console.error('Error fetching players:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch players'
    })
  }
})