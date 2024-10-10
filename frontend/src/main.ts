import "./assets/main.css"
import { createApp } from "vue"
import App from "./App.vue"
import router from "./router"
import VueApexCharts from "vue3-apexcharts"
import { createPinia } from "pinia"

const app = createApp(App)

//implentation of pinia, our store
const pinia = createPinia()

app.use(router)
app.use(pinia)
app.use(VueApexCharts)

app.mount("#app")
