import { sql } from 'drizzle-orm'

export default defineEventHandler(async (event) => {
  try {
    const playerId = getRouterParam(event, 'playerId')

    if (!playerId) {
      throw createError({
        statusCode: 400,
        statusMessage: 'playerId is required'
      })
    }

    const result = await db.run(sql`
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
      WHERE p.player_id = ${playerId}
      ORDER BY p.created_at DESC
    `)

    return result.results
  } catch (error) {
    console.error('Error fetching progress:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Failed to fetch progress'
    })
  }
})