import "./assets/main.css"
import { createApp } from "vue"
import App from "./App.vue"
import router from "./router"
import { createPinia } from "pinia"

// Create the app instance
const app = createApp(App)

// Create Pinia instance for the store
const pinia = createPinia()

// Use the necessary plugins
app.use(router)
app.use(pinia)

// Mount the app
app.mount("#app")
