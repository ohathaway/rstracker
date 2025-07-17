#!/usr/bin/env node
import { readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'
import Database from 'better-sqlite3'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

// Read the migration file
const migrationSQL = readFileSync(join(__dirname, '../database/migrations/0001_initial.sql'), 'utf8')

// Create or open the database
const db = new Database('dev.db')

// Execute the migration
try {
  db.exec(migrationSQL)
  console.log('Database initialized successfully!')
} catch (error) {
  console.error('Error initializing database:', error)
}

db.close()