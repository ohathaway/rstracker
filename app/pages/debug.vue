<template>
  <div class="p-8">
    <h1 class="text-2xl font-bold mb-4">Debug Page</h1>
    
    <div class="mb-8">
      <h2 class="text-xl font-semibold mb-4">Raw Data Debug</h2>
      <div class="bg-gray-100 p-4 rounded">
        <p><strong>Songs count:</strong> {{ songs?.length || 0 }}</p>
        <p><strong>Players count:</strong> {{ players?.length || 0 }}</p>
        <p><strong>Pending:</strong> {{ pending }}</p>
        <p><strong>Error:</strong> {{ error }}</p>
      </div>
    </div>

    <div class="mb-8">
      <h2 class="text-xl font-semibold mb-4">First 3 Songs Raw JSON</h2>
      <pre class="bg-gray-100 p-4 rounded text-xs overflow-auto">{{ JSON.stringify(songs.slice(0, 3), null, 2) }}</pre>
    </div>

    <div class="mb-8">
      <h2 class="text-xl font-semibold mb-4">Simple List Test</h2>
      <ul class="list-disc pl-5">
        <li v-for="song in songs.slice(0, 5)" :key="song.id">
          {{ song.title }} by {{ song.artist }} ({{ song.year }})
        </li>
      </ul>
    </div>

    <div class="mb-8">
      <h2 class="text-xl font-semibold mb-4">Simple Table Test</h2>
      <table class="border border-gray-300">
        <thead>
          <tr class="bg-gray-100">
            <th class="border border-gray-300 px-4 py-2">Title</th>
            <th class="border border-gray-300 px-4 py-2">Artist</th>
            <th class="border border-gray-300 px-4 py-2">Year</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="song in songs.slice(0, 5)" :key="song.id" class="border border-gray-300">
            <td class="border border-gray-300 px-4 py-2">{{ song.title }}</td>
            <td class="border border-gray-300 px-4 py-2">{{ song.artist }}</td>
            <td class="border border-gray-300 px-4 py-2">{{ song.year }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
// Reactive data
const songs = ref([])
const players = ref([])
const pending = ref(true)
const error = ref(null)

// Fetch data on client side only
onMounted(async () => {
  try {
    console.log('Fetching data...')
    // Fetch songs and players data
    const [songsData, playersData] = await Promise.all([
      $fetch('/api/songs'),
      $fetch('/api/players')
    ])
    
    console.log('Songs data:', songsData)
    console.log('Players data:', playersData)
    
    songs.value = songsData
    players.value = playersData
    error.value = null
  } catch (err) {
    console.error('Error fetching data:', err)
    error.value = err.message || 'Failed to load data'
  } finally {
    pending.value = false
  }
})
</script>