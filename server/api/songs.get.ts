import { sql } from 'drizzle-orm'

export default defineEventHandler(async (event) => {
  try {
    // Get all songs with their completion status for both players
    const result = await db.run(sql`
      SELECT
        s.id,
        s.ordinal,
        s.title,
        s.artist,
        s.year,
        s.created_at,
        p1.completion_percentage as player1_score,
        p1.completed_at as player1_completed_at,
        CASE WHEN p1.completion_percentage >= 95 THEN 1 ELSE 0 END as player1_complete,
        p2.completion_percentage as player2_score,
        p2.completed_at as player2_completed_at,
        CASE WHEN p2.completion_percentage >= 95 THEN 1 ELSE 0 END as player2_complete
      FROM songs s
      LEFT JOIN progress p1 ON s.id = p1.song_id AND p1.player_id = 1
      LEFT JOIN progress p2 ON s.id = p2.song_id AND p2.player_id = 2
      ORDER BY s.ordinal ASC
    `)

    return result.results
  } catch (error) {
    console.error('Error fetching songs:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch songs'
    })
  }
})