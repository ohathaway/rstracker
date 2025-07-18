<template>
  <div class="p-8">
    <h1 class="text-2xl font-bold mb-4">Test Page</h1>
    <p>This is a simple test page to verify the app is working.</p>
    
    <div class="mt-8">
      <h2 class="text-xl font-semibold mb-4">API Test</h2>
      <button @click="testAPI" class="bg-blue-500 text-white px-4 py-2 rounded">
        Test API
      </button>
      <div v-if="apiResult" class="mt-4 p-4 bg-gray-100 rounded">
        <pre>{{ apiResult }}</pre>
      </div>
    </div>
  </div>
</template>

<script setup>
const apiResult = ref(null)

async function testAPI() {
  try {
    const songs = await $fetch('/api/songs')
    apiResult.value = { success: true, count: songs.length, first: songs[0] }
  } catch (error) {
    apiResult.value = { success: false, error: error.message }
  }
}
</script>