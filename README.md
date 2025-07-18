# Bass Learning Tracker

A NuxtHub application for tracking bass learning progress between two players in a friendly competition.

## Features

- Track learning progress for 50 classic bass songs
- Compare completion status between two players
- Clean, responsive UI with bass/music theme
- Real-time progress updates
- D1 database integration via NuxtHub

## Technology Stack

- **Framework**: Nuxt 3
- **Database**: Cloudflare D1 (via NuxtHub)
- **UI**: Nuxt UI + Tailwind CSS
- **Deployment**: Cloudflare Pages (via NuxtHub)

## Development Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start the development server with NuxtHub:
   ```bash
   npm run dev
   # or directly:
   npx nuxthub preview
   ```

3. Open [http://localhost:3000](http://localhost:3000) in your browser

**Note**: Use `npx nuxthub preview` instead of `nuxt dev` to enable Cloudflare D1 database and other NuxtHub features in development.

## API Routes

- `GET /api/songs` - Get all songs with completion status
- `GET /api/players` - Get all players with stats
- `POST /api/progress` - Update song completion progress
- `GET /api/progress/:playerId` - Get specific player's progress

## Database Schema

### Songs Table
- `id` - Primary key
- `title` - Song title
- `artist` - Artist name
- `year` - Release year
- `created_at` - Timestamp

### Players Table
- `id` - Primary key
- `name` - Player name
- `avatar_url` - Avatar URL (optional)
- `created_at` - Timestamp

### Progress Table
- `id` - Primary key
- `player_id` - Foreign key to players
- `song_id` - Foreign key to songs
- `completion_percentage` - 0-100 completion percentage
- `completed_at` - Completion timestamp
- `notes` - Optional notes
- `created_at` - Timestamp

## Song List

The app includes 50 classic bass songs from various decades:
- 1960s classics like "House Of The Rising Sun"
- 1970s favorites like "Psycho Killer" and "Money"
- 1980s hits like "Crazy Train" and "Under Pressure"
- 1990s grunge like "Smells Like Teen Spirit"
- 2000s additions like "Seven Nation Army"

## Deployment

This app is designed to be deployed on Cloudflare Pages via NuxtHub:

1. Push to GitHub
2. Connect to Cloudflare Pages
3. NuxtHub will handle D1 database provisioning
4. Deploy with zero configuration

## License

MIT