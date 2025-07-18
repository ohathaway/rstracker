<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- Enhanced Header with Background Image -->
    <div class="bass-header min-h-[400px] flex items-center">
      <!-- Animated Sound Wave Bars -->
      <div class="sound-waves">
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
        <div class="wave-bar"></div>
      </div>

      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 w-full">
        <div class="py-12">
          <!-- Main Title Section -->
          <div class="text-center mb-12">
            <h1 class="text-6xl md:text-7xl font-bold text-white mb-4 drop-shadow-lg">
              Bass Learning Tracker
            </h1>
            <p class="text-xl text-white/90 drop-shadow-md">
              Epic Bass Competition • {{ songs?.results?.length || 0 }} Songs Challenge
            </p>
          </div>

          <!-- Player Statistics and Race Visualization -->
          <div class="grid md:grid-cols-2 gap-8 mb-8">
            <!-- Player 1 Stats -->
            <div v-for="(player, index) in players?.results || []" :key="player.id" 
                 :class="['bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20',
                         index === 0 ? 'ring-2 ring-blue-400/50' : 'ring-2 ring-purple-400/50']">
              <div class="flex items-center justify-between mb-4">
                <div class="flex items-center space-x-3">
                  <div :class="['w-12 h-12 rounded-full flex items-center justify-center text-2xl',
                               index === 0 ? 'bg-blue-500' : 'bg-purple-500']">
                    🎸
                  </div>
                  <div>
                    <h3 class="text-2xl font-bold text-white">{{ player.name }}</h3>
                    <div class="flex items-center space-x-2">
                      <span class="text-white/80">{{ player.name }}</span>
                      <span v-if="isLeader(player)" class="text-yellow-400">👑</span>
                    </div>
                  </div>
                </div>
                <!-- Large Completion Number -->
                <div class="text-right">
                  <div class="text-5xl font-bold text-white drop-shadow-lg">
                    {{ player.completed_songs }}
                  </div>
                  <div class="text-white/80 text-sm">completed</div>
                </div>
              </div>
              
              <!-- Progress Bar -->
              <div class="mb-3">
                <div class="flex justify-between text-white/80 text-sm mb-2">
                  <span>Progress</span>
                  <span>{{ getCompletionPercentage(player) }}%</span>
                </div>
                <div class="progress-track">
                  <div 
                    :class="index === 0 ? 'progress-bar-player1' : 'progress-bar-player2'"
                    :style="{ width: `${getCompletionPercentage(player)}%` }"
                  ></div>
                </div>
              </div>
            </div>
          </div>

          <!-- Race Visualization -->
          <div class="bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20">
            <h3 class="text-xl font-bold text-white mb-4 text-center">🏁 Race to 50 Songs</h3>
            <div class="space-y-4">
              <div v-for="(player, index) in players?.results || []" :key="player.id" class="flex items-center space-x-4">
                <div class="w-20 text-right">
                  <span class="text-white font-medium">{{ player.name }}</span>
                </div>
                <div class="flex-1 relative">
                  <div class="progress-track">
                    <div 
                      :class="index === 0 ? 'progress-bar-player1' : 'progress-bar-player2'"
                      :style="{ width: `${getCompletionPercentage(player)}%` }"
                    ></div>
                  </div>
                  <!-- Finish Line Marker -->
                  <div class="absolute right-0 top-0 bottom-0 flex items-center">
                    <div class="bg-yellow-400 text-black px-2 py-1 rounded text-xs font-bold">
                      FINISH
                    </div>
                  </div>
                </div>
                <div class="w-12 text-white font-bold">
                  {{ player.completed_songs }}/50
                </div>
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

// Toast notifications (alternative approach without UNotifications)
const showToast = (title, description) => {
  // Simple alert-based notification for now
  alert(`${title}\n${description}`)
}

// Score modal state
const showScoreModal = ref(false)
const modalProps = ref({
  songId: null,
  playerId: null,
  currentScore: null,
  songTitle: '',
  artist: ''
})

// Animation triggers
const animationTriggers = ref(new Set())

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
  const oldPlayerData = players.value?.results?.find(p => p.id === data.playerId)
  const oldCompletedCount = oldPlayerData?.completed_songs || 0
  
  await updateScore(data.songId, data.playerId, data.score)
  
  // Check for celebrations if score >= 95%
  if (data.score >= 95) {
    const songData = songs.value?.results?.find(s => s.id === data.songId)
    const playerData = players.value?.results?.find(p => p.id === data.playerId)
    
    if (songData && playerData) {
      // Trigger animation for this specific cell
      const animationKey = `${data.songId}-${data.playerId}`
      animationTriggers.value.add(animationKey)
      
      // Remove animation trigger after animation completes
      setTimeout(() => {
        animationTriggers.value.delete(animationKey)
      }, 1000)
      
      // Note: Celebration animations and notifications removed for now
      // Can be re-enabled later when animation system is working properly
    }
  }
  
  showScoreModal.value = false
}

// Helper functions for header display
const getCompletionPercentage = (player) => {
  const totalSongs = songs.value?.results?.length || 50
  return Math.round((player.completed_songs / totalSongs) * 100)
}

const isLeader = (player) => {
  if (!players.value?.results) return false
  const maxCompleted = Math.max(...players.value.results.map(p => p.completed_songs))
  return player.completed_songs === maxCompleted && player.completed_songs > 0
}

// Celebration functions
const triggerConfetti = (playerId, element) => {
  const colors = playerId === 1 ? ['confetti-blue', 'confetti-green'] : ['confetti-purple', 'confetti-yellow']
  const rect = element.getBoundingClientRect()
  
  // Create confetti particles
  for (let i = 0; i < 15; i++) {
    const particle = document.createElement('div')
    particle.className = `confetti-particle ${colors[Math.floor(Math.random() * colors.length)]}`
    particle.style.left = `${rect.left + rect.width / 2}px`
    particle.style.top = `${rect.top}px`
    particle.style.animation = `confetti-fall ${1 + Math.random()}s ease-out forwards`
    particle.style.animationDelay = `${Math.random() * 0.3}s`
    
    // Random horizontal spread
    const spread = (Math.random() - 0.5) * 100
    particle.style.setProperty('--spread', `${spread}px`)
    
    document.body.appendChild(particle)
    
    // Remove particle after animation
    setTimeout(() => {
      if (particle.parentNode) {
        particle.parentNode.removeChild(particle)
      }
    }, 2000)
  }
}

const showCompletionToast = (playerName, songTitle, milestone = null) => {
  if (milestone) {
    showToast(
      `🏆 ${playerName} reached ${milestone} songs!`,
      `Fantastic progress on this bass journey!`
    )
  } else {
    showToast(
      `🎉 ${playerName} completed "${songTitle}"!`,
      `Another song mastered with 95%+ score!`
    )
  }
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
      label: `Update Garrett's Score`,
      icon: 'i-heroicons-user',
      onSelect() {
        openScoreModal(song.id, 1, song.player1_score, song.title, song.artist)
      }
    },
    {
      label: `Update Owen's Score`,
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
        label: 'Garrett',
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
      const animationKey = `${row.original.id}-1`
      const shouldAnimate = animationTriggers.value.has(animationKey)
      
      let badgeClass = complete ? 'completed-badge' : 'pending-badge'
      if (shouldAnimate) {
        badgeClass += ' completed-celebration'
      }
      
      return h('div', { class: 'flex items-center space-x-2' }, [
        h('span', { 
          class: badgeClass,
          key: shouldAnimate ? `animated-${Date.now()}` : 'static'
        }, scoreText),
        complete ? h('span', { 
          class: shouldAnimate ? 'text-green-600 text-xs checkmark-bounce' : 'text-green-600 text-xs',
          key: shouldAnimate ? `check-animated-${Date.now()}` : 'check-static'
        }, '✓') : null
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
        label: 'Owen',
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
      const animationKey = `${row.original.id}-2`
      const shouldAnimate = animationTriggers.value.has(animationKey)
      
      let badgeClass = complete ? 'completed-badge' : 'pending-badge'
      if (shouldAnimate) {
        badgeClass += ' completed-celebration'
      }
      
      return h('div', { class: 'flex items-center space-x-2' }, [
        h('span', { 
          class: badgeClass,
          key: shouldAnimate ? `animated-${Date.now()}` : 'static'
        }, scoreText),
        complete ? h('span', { 
          class: shouldAnimate ? 'text-green-600 text-xs checkmark-bounce' : 'text-green-600 text-xs',
          key: shouldAnimate ? `check-animated-${Date.now()}` : 'check-static'
        }, '✓') : null
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