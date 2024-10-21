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

// Ensure Pinia is ready before initializing the router
router.isReady().then(() => {
  const authStore = useAuthStore()

  // Global navigation guard
  router.beforeEach(
    (to: RouteLocationNormalized, from: RouteLocationNormalized, next: NavigationGuardNext) => {
      const isLoggedIn = !!authStore.user
      const userRole = authStore.role

      // Route requires authentication but user is not logged in
      if (to.meta.requiresAuth && !isLoggedIn) {
        next("/login")
      }

      // User is logged in but tries to access login page, redirect to home
      else if (isLoggedIn && to.path === "/login") {
        next("/")
      }

      // Role-based access control: check if the user's role is allowed for the route
      else if (to.meta.roles && !to.meta.roles.includes(userRole)) {
        next("/")
      }

      // Allow navigation
      else {
        next()
      }
    }
  )
})

export default router
