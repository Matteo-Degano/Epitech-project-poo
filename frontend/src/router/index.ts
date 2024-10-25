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

// Define roles
const employee = 1
const manager = 2
const generalManager = 3
const admin = 4

const routes = [
  { path: "/login", component: LoginView },
  {
    path: "/",
    component: NavbarLayout,
    children: [
      {
        path: "",
        component: HomeView,
        meta: { requiresAuth: true, roles: [employee, manager, generalManager, admin] }
      },
      {
        path: "working-times",
        component: WorkingTimesView,
        meta: { requiresAuth: true, roles: [employee, manager, generalManager, admin] }
      },
      {
        path: "users",
        component: UsersView,
        meta: { requiresAuth: true, roles: [generalManager, admin] }
      },
      {
        path: "charts",
        component: ChartsView,
        meta: { requiresAuth: true, roles: [employee, manager, generalManager, admin] }
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
    const isLoggedIn = !!authStore.user
    const userRole = authStore.role

    // If the route requires authentication and the user is not logged in, redirect to login
    if (to.meta.requiresAuth && !isLoggedIn) {
      return next("/login")
    }

    // If the user is logged in and tries to access the login page, redirect to home
    if (isLoggedIn && to.path === "/login") {
      return next("/")
    }

    // If the route has roles defined, check if the user's role is authorized
    if (to.meta.roles && !to.meta.roles.some((role: number) => role === userRole)) {
      return next("/") // Redirect to home if user role is not authorized
    }

    // Otherwise, allow the navigation
    next()
  }
)

export default router
