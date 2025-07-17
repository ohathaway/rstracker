<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Header -->
    <div class="bass-gradient">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="py-6">
          <div class="flex items-center justify-between">
            <div>
              <h1 class="text-3xl font-bold text-white">Bass Learning Tracker</h1>
              <p class="text-blue-100 mt-1">Competition between {{ players.length }} players</p>
            </div>
            <div class="flex space-x-4">
              <div v-for="player in players" :key="player.id" class="text-center">
                <div class="text-white font-medium">{{ player.name }}</div>
                <div class="text-blue-100 text-sm">{{ player.completed_songs }} songs completed</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Main Content -->
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Loading State -->
      <div v-if="pending" class="text-center py-12">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
        <p class="mt-4 text-gray-600 dark:text-gray-400">Loading songs...</p>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="text-center py-12">
        <div class="text-red-600 dark:text-red-400">
          <p class="text-lg font-medium">Error loading songs</p>
          <p class="mt-2">{{ error }}</p>
        </div>
      </div>

      <!-- Songs List -->
      <div v-else class="bg-white dark:bg-gray-800 shadow-sm rounded-lg overflow-hidden">
        <div class="px-6 py-4 border-b border-gray-200 dark:border-gray-700">
          <h2 class="text-lg font-medium text-gray-900 dark:text-white">Song List</h2>
          <p class="text-sm text-gray-600 dark:text-gray-400 mt-1">
            {{ songs.length }} songs total
          </p>
        </div>

        <div class="overflow-x-auto">
          <table class="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead class="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Song
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Artist
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Year
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Player 1
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Player 2
                </th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody class="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
              <tr v-for="song in songs" :key="song.id" class="hover:bg-gray-50 dark:hover:bg-gray-700">
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm font-medium text-gray-900 dark:text-white">
                    {{ song.title }}
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm text-gray-900 dark:text-white">
                    {{ song.artist }}
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <div class="text-sm text-gray-900 dark:text-white">
                    {{ song.year }}
                  </div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span 
                    :class="song.player1_completion === 100 ? 'completed-badge' : 'pending-badge'"
                  >
                    {{ song.player1_completion === 100 ? 'Completed' : 'Pending' }}
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap">
                  <span 
                    :class="song.player2_completion === 100 ? 'completed-badge' : 'pending-badge'"
                  >
                    {{ song.player2_completion === 100 ? 'Completed' : 'Pending' }}
                  </span>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                  <UButton 
                    @click="markComplete(song.id, 1)"
                    :disabled="song.player1_completion === 100"
                    variant="outline"
                    size="xs"
                    class="mr-2"
                  >
                    Mark P1 Complete
                  </UButton>
                  <UButton 
                    @click="markComplete(song.id, 2)"
                    :disabled="song.player2_completion === 100"
                    variant="outline"
                    size="xs"
                  >
                    Mark P2 Complete
                  </UButton>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// Fetch songs and players data
const { data: songs, pending, error, refresh } = await useFetch('/api/songs')
const { data: players } = await useFetch('/api/players')

// Mark song as complete for a player
async function markComplete(songId, playerId) {
  try {
    await $fetch('/api/progress', {
      method: 'POST',
      body: {
        player_id: playerId,
        song_id: songId,
        completion_percentage: 100
      }
    })
    
    // Refresh the data
    await refresh()
  } catch (error) {
    console.error('Error marking song as complete:', error)
  }
}
</script>