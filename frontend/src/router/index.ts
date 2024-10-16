import { useAuthStore } from "@/stores/auth.store"
import {
  createRouter,
  createWebHistory,
  type NavigationGuardNext,
  type RouteLocationNormalized
} from "vue-router"
import HomeView from "../views/HomeView.vue"
import LoginView from "../views/LoginView.vue"
import WorkingTimesView from "@/views/WorkingTimesView.vue"
import NavbarLayout from "@/components/navigation/NavbarLayout.vue"

const routes = [
  { path: "/login", component: LoginView },
  {
    path: "/",
    component: NavbarLayout,
    children: [
      {
        path: "",
        component: HomeView
        // beforeEnter: (
        //   to: RouteLocationNormalized,
        //   from: RouteLocationNormalized,
        //   next: NavigationGuardNext
        // ) => {
        //   const authStore = useAuthStore()
        //   if (!authStore.user) {
        //     next("/login")
        //   } else {
        //     next()
        //   }
        // }
      },
      {
        path: "working-times",
        component: WorkingTimesView
        // beforeEnter: (
        //   to: RouteLocationNormalized,
        //   from: RouteLocationNormalized,
        //   next: NavigationGuardNext
        // ) => {
        //   const authStore = useAuthStore()
        //   if (!authStore.user) {
        //     next("/login")
        //   } else {
        //     next()
        //   }
        // }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
