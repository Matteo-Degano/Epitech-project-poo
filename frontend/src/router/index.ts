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
import UsersView from "@/views/UsersView.vue"
import ChartsView from "@/views/ChartsView.vue"

const routes = [
  { path: "/login", component: LoginView },
  {
    path: "/",
    component: NavbarLayout,
    children: [
      {
        path: "",
        component: HomeView
      },
      {
        path: "working-times",
        component: WorkingTimesView
      },
      {
        path: "users",
        component: UsersView,
        beforeEnter (to: RouteLocationNormalized, from: RouteLocationNormalized, next: NavigationGuardNext) {
          const authStore = useAuthStore()
          if (authStore.user?.role_id === 1) {
            next("/")
          } else {
            next()
          }
        }
      },
      {
        path: "charts",
        component: ChartsView
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Global navigation guard
router.beforeEach(
  (to: RouteLocationNormalized, from: RouteLocationNormalized, next: NavigationGuardNext) => {
    const authStore = useAuthStore()

    // If the user is not logged in and trying to access a route other than login
    if (!authStore.user && to.path !== "/login") {
      next("/login")
    }
    // If the user is logged in and trying to access the login page
    else if (authStore.user && to.path === "/login") {
      next("/")
    }
    // Otherwise, allow the navigation
    else {
      next()
    }
  }
)

export default router
