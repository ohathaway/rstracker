import { sqliteTable, text, integer, index, uniqueIndex } from 'drizzle-orm/sqlite-core'
import { sql } from 'drizzle-orm'

export const songs = sqliteTable('songs', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  title: text('title').notNull(),
  artist: text('artist').notNull(),
  year: integer('year').notNull(),
  ordinal: integer('ordinal'),
  createdAt: text('created_at').default(sql`CURRENT_TIMESTAMP`)
}, (table) => ({
  ordinalIdx: index('idx_songs_ordinal').on(table.ordinal)
}))

export const players = sqliteTable('players', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  name: text('name').notNull(),
  avatarUrl: text('avatar_url'),
  createdAt: text('created_at').default(sql`CURRENT_TIMESTAMP`)
})

export const progress = sqliteTable('progress', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  playerId: integer('player_id').notNull().references(() => players.id),
  songId: integer('song_id').notNull().references(() => songs.id),
  completionPercentage: integer('completion_percentage').default(0),
  completedAt: text('completed_at'),
  notes: text('notes'),
  createdAt: text('created_at').default(sql`CURRENT_TIMESTAMP`)
}, (table) => ({
  completionIdx: index('idx_progress_completion').on(table.completionPercentage),
  playerIdx: index('idx_progress_player').on(table.playerId),
  playerSongUnique: uniqueIndex('progress_player_id_song_id_unique').on(table.playerId, table.songId)
}))
