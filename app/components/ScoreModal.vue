<template>
  <UModal 
    v-model:open="isOpen"
    title="Update Score"
    :description="`Enter score for Player ${playerId} - ${songTitle} by ${artist}`"
  >
    <template #body>
        <div class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
              Score Percentage
            </label>
            <UInput
              v-model="scoreInput"
              type="number"
              min="0"
              max="100"
              placeholder="Enter score (0-100)"
              @keyup.enter="submitScore"
            >
              <template #trailing>
                %
              </template>
            </UInput>
          </div>
        </div>
    </template>

    <template #footer="{ close }">
      <div class="flex justify-end gap-2">
        <UButton label="Cancel" color="neutral" @click="handleClose" />
        <UButton 
          label="Update Score"
          color="primary"
          :disabled="!scoreInput || Number(scoreInput) < 0 || Number(scoreInput) > 100"
          @click="submitScore"
        />
      </div>
    </template>
  </UModal>
</template>

<script setup>
const props = defineProps({
  songId: {
    type: Number,
    required: true
  },
  playerId: {
    type: Number,
    required: true
  },
  currentScore: {
    type: Number,
    default: null
  },
  songTitle: {
    type: String,
    required: true
  },
  artist: {
    type: String,
    required: true
  }
})

const emit = defineEmits(['close', 'submit'])

const isOpen = ref(true)
const scoreInput = ref(props.currentScore ? props.currentScore.toString() : '')

const handleClose = () => {
  isOpen.value = false
  emit('close')
}

const submitScore = () => {
  const score = Number(scoreInput.value)
  if (score >= 0 && score <= 100) {
    emit('submit', {
      songId: props.songId,
      playerId: props.playerId,
      score: score
    })
  }
}

// Watch for modal close
watch(isOpen, (newValue) => {
  if (!newValue) {
    emit('close')
  }
})
</script>