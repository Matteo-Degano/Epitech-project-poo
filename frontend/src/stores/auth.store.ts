import { fetchData } from "@/services/api"
import { defineStore } from "pinia"

export const useAuthStore = defineStore("auth", {
  state: () => ({
    // Initialize user, role, and team from sessionStorage
    user: JSON.parse(sessionStorage.getItem("user") || "null"),
    role: sessionStorage.getItem("role") || "",
    team: JSON.parse(sessionStorage.getItem("team") || "[]")
  }),

  actions: {
    async login(email: string, password: string) {
      try {
        const response = await fetchData("POST", "/login", { email, password })
        const { user } = response.data

        // Store user, role, and team in Pinia
        this.user = user
        this.role = user.role
        this.team = user.team

        // Persist role and team in sessionStorage
        sessionStorage.setItem("user", JSON.stringify(user))
        sessionStorage.setItem("role", user.role)
        sessionStorage.setItem("team", JSON.stringify(user.team))
      } catch (error) {
        console.error("Login failed", error)
      }
    },

    logout() {
      this.user = null
      this.role = ""
      this.team = []

      // Remove user, role, and team from sessionStorage
      sessionStorage.removeItem("user")
      sessionStorage.removeItem("role")
      sessionStorage.removeItem("team")
    },

    // Check if the user has a specific role
    hasRole(role: string) {
      return this.role === role
    },

    // Check if the user has any of the allowed roles
    hasAnyRole(roles: string[]) {
      return roles.includes(this.role)
    },

    // Check if the user belongs to a specific team
    isInTeam(teamName: string) {
      return this.team.includes(teamName)
    }
  }
})
