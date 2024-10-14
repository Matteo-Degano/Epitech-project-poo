import "./assets/main.css"
import { createApp } from "vue"
import App from "./App.vue"
import router from "./router"
import VueApexCharts from "vue3-apexcharts"
import { createPinia } from "pinia"
import "vuetify/styles"

// Create the app instance
const app = createApp(App)

// Create Pinia instance for the store
const pinia = createPinia()

// Use the necessary plugins
app.use(router)
app.use(pinia)
app.use(VueApexCharts)

// Mount the app
app.mount("#app")
