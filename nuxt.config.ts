export default defineNuxtConfig({
  modules: ['@nuxthub/core', '@nuxt/ui'],
  devtools: { enabled: true },
  hub: {
    database: true
  },
  css: ['~/assets/css/main.css']
})