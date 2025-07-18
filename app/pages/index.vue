<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Header -->
    <div class="bass-gradient">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="py-6">
          <div class="flex items-center justify-between">
            <div>
              <h1 class="text-3xl font-bold text-white">Bass Learning Tracker</h1>
              <p class="text-blue-100 mt-1">Competition between {{ players?.results?.length || 0 }} players</p>
            </div>
            <div class="flex space-x-4">
              <div v-for="player in players.results" :key="player.id" class="text-center">
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
          <div class="flex items-center justify-between">
            <div>
              <h2 class="text-lg font-medium text-gray-900 dark:text-white">Song List</h2>
              <p class="text-sm text-gray-600 dark:text-gray-400 mt-1">
                {{ songs?.results?.length || 0 }} songs total - ordered from easiest (#1) to hardest (#50)
              </p>
            </div>
            <div class="flex items-center space-x-4">
              <UInput 
                v-model="globalFilter" 
                placeholder="Filter songs, artists..." 
                icon="i-heroicons-magnifying-glass-20-solid"
                class="w-64"
              />
            </div>
          </div>
        </div>

        <UTable 
          v-model:sorting="sorting"
          v-model:global-filter="globalFilter"
          :data="tableData" 
          :columns="columns"
          :loading="pending"
        />
      </div>
    </div>

    <!-- Score Update Modal -->
    <ScoreModal
      v-if="showScoreModal"
      :song-id="modalProps.songId"
      :player-id="modalProps.playerId"
      :current-score="modalProps.currentScore"
      :song-title="modalProps.songTitle"
      :artist="modalProps.artist"
      @close="handleModalClose"
      @submit="handleScoreSubmit"
    />
  </div>
</template>

<script setup>
import { h, resolveComponent } from 'vue'

// Reactive data
const songs = ref([])
const players = ref([])
const pending = ref(true)
const error = ref(null)
const sorting = ref([
  {
    id: 'ordinal',
    desc: false
  }
])

const globalFilter = ref('')

// Score modal state
const showScoreModal = ref(false)
const modalProps = ref({
  songId: null,
  playerId: null,
  currentScore: null,
  songTitle: '',
  artist: ''
})

// Open score modal
function openScoreModal(songId, playerId, currentScore, songTitle, artist) {
  modalProps.value = {
    songId,
    playerId,
    currentScore,
    songTitle,
    artist
  }
  showScoreModal.value = true
}

// Handle modal events
function handleModalClose() {
  showScoreModal.value = false
}

async function handleScoreSubmit(data) {
  await updateScore(data.songId, data.playerId, data.score)
  showScoreModal.value = false
}

// Row action items for dropdown
function getRowItems(row) {
  const song = row.original
  return [
    {
      type: 'label',
      label: `${song.title} - ${song.artist}`
    },
    {
      label: 'Update Player 1 Score',
      icon: 'i-heroicons-user',
      onSelect() {
        openScoreModal(song.id, 1, song.player1_score, song.title, song.artist)
      }
    },
    {
      label: 'Update Player 2 Score',
      icon: 'i-heroicons-user',
      onSelect() {
        openScoreModal(song.id, 2, song.player2_score, song.title, song.artist)
      }
    }
  ]
}

// Table configuration
const UButtonComponent = resolveComponent('UButton')
const UDropdownMenu = resolveComponent('UDropdownMenu')

const columns = [
  {
    accessorKey: 'ordinal',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButtonComponent, {
        color: 'neutral',
        variant: 'ghost',
        label: '#',
        icon: isSorted
          ? isSorted === 'asc'
            ? 'i-lucide-arrow-up-narrow-wide'
            : 'i-lucide-arrow-down-wide-narrow'
          : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    },
    cell: ({ row }) => h('span', { class: 'font-bold text-gray-900 dark:text-white' }, `#${row.getValue('ordinal')}`)
  },
  {
    accessorKey: 'title',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButtonComponent, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Song',
        icon: isSorted
          ? isSorted === 'asc'
            ? 'i-lucide-arrow-up-narrow-wide'
            : 'i-lucide-arrow-down-wide-narrow'
          : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    }
  },
  {
    accessorKey: 'artist',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButtonComponent, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Artist',
        icon: isSorted
          ? isSorted === 'asc'
            ? 'i-lucide-arrow-up-narrow-wide'
            : 'i-lucide-arrow-down-wide-narrow'
          : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    }
  },
  {
    accessorKey: 'year',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButtonComponent, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Year',
        icon: isSorted
          ? isSorted === 'asc'
            ? 'i-lucide-arrow-up-narrow-wide'
            : 'i-lucide-arrow-down-wide-narrow'
          : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    }
  },
  {
    accessorKey: 'player1_score',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButtonComponent, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Player 1',
        icon: isSorted
          ? isSorted === 'asc'
            ? 'i-lucide-arrow-up-narrow-wide'
            : 'i-lucide-arrow-down-wide-narrow'
          : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    },
    cell: ({ row }) => {
      const score = row.original.player1_score
      const complete = row.original.player1_complete
      const scoreText = score ? `${score}%` : 'Not attempted'
      const badgeClass = complete ? 'completed-badge' : 'pending-badge'
      
      return h('div', { class: 'flex items-center space-x-2' }, [
        h('span', { class: badgeClass }, scoreText),
        complete ? h('span', { class: 'text-green-600 text-xs' }, '✓') : null
      ])
    }
  },
  {
    accessorKey: 'player2_score',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      return h(UButtonComponent, {
        color: 'neutral',
        variant: 'ghost',
        label: 'Player 2',
        icon: isSorted
          ? isSorted === 'asc'
            ? 'i-lucide-arrow-up-narrow-wide'
            : 'i-lucide-arrow-down-wide-narrow'
          : 'i-lucide-arrow-up-down',
        class: '-mx-2.5',
        onClick: () => column.toggleSorting(column.getIsSorted() === 'asc')
      })
    },
    cell: ({ row }) => {
      const score = row.original.player2_score
      const complete = row.original.player2_complete
      const scoreText = score ? `${score}%` : 'Not attempted'
      const badgeClass = complete ? 'completed-badge' : 'pending-badge'
      
      return h('div', { class: 'flex items-center space-x-2' }, [
        h('span', { class: badgeClass }, scoreText),
        complete ? h('span', { class: 'text-green-600 text-xs' }, '✓') : null
      ])
    }
  },
  {
    id: 'actions',
    cell: ({ row }) => {
      return h(
        'div',
        { class: 'text-right' },
        h(
          UDropdownMenu,
          {
            content: {
              align: 'end'
            },
            items: getRowItems(row),
            'aria-label': 'Actions dropdown'
          },
          () =>
            h(UButtonComponent, {
              icon: 'i-lucide-ellipsis-vertical',
              color: 'neutral',
              variant: 'ghost',
              class: 'ml-auto',
              'aria-label': 'Actions dropdown'
            })
        )
      )
    }
  }
]

// Computed table data (UTable handles sorting internally)
const tableData = computed(() => {
  // Handle both direct array and wrapped response
  let rawData = []
  if (Array.isArray(songs.value)) {
    rawData = songs.value
  } else if (songs.value?.results && Array.isArray(songs.value.results)) {
    rawData = songs.value.results
  } else {
    return []
  }
  
  // Convert reactive objects to plain objects for UTable
  return rawData.map(song => ({
    id: song.id,
    ordinal: song.ordinal,
    title: song.title,
    artist: song.artist,
    year: song.year,
    player1_score: song.player1_score,
    player1_complete: song.player1_complete,
    player2_score: song.player2_score,
    player2_complete: song.player2_complete,
    player1_status: song.player1_score, // Add for column reference
    player2_status: song.player2_score, // Add for column reference
    created_at: song.created_at
  }))
})

// Fetch data on client side only
onMounted(async () => {
  try {
    // Fetch songs and players data
    const [songsData, playersData] = await Promise.all([
      $fetch('/api/songs'),
      $fetch('/api/players')
    ])
    
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

// Update score for a player
async function updateScore(songId, playerId, score) {
  if (score === undefined || score === null || score < 0 || score > 100) {
    alert('Please enter a valid score between 0 and 100')
    return
  }
  
  try {
    await $fetch('/api/progress', {
      method: 'POST',
      body: {
        player_id: playerId,
        song_id: songId,
        score: score
      }
    })
    
    // Refresh the data
    const [songsData, playersData] = await Promise.all([
      $fetch('/api/songs'),
      $fetch('/api/players')
    ])
    
    songs.value = songsData
    players.value = playersData
  } catch (error) {
    console.error('Error updating score:', error)
    alert('Failed to update score. Please try again.')
  }
}
</script>