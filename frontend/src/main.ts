import "./assets/main.css"
import { createApp } from "vue"
import App from "./App.vue"
import router from "./router"
import { createPinia } from "pinia"
import VueApexCharts from "vue3-apexcharts"

// Create the app instance
const app = createApp(App)

// Create Pinia instance for the store
const pinia = createPinia()

// Use the necessary plugins
app.use(router)
app.use(pinia)

//Use ApexCharts
app.use(VueApexCharts)
app.component("ApexChart", VueApexCharts)

// Mount the app
app.mount("#app")
