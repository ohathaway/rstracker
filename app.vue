<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <NuxtPage />
  </div>
</template>

<script setup>
useHead({
  title: 'Bass Learning Tracker',
  meta: [
    { name: 'description', content: 'Track your bass learning progress with friends' }
  ]
})
</script>