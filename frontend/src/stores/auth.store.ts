import router from "@/router"
import { fetchData } from "@/services/api"
import type { APIResponse, User } from "@/types/api.type"
import { defineStore } from "pinia"

export const useAuthStore = defineStore("auth", {
  state: () => ({
    // Initialize user data from sessionStorage
    user: JSON.parse(sessionStorage.getItem("user") || "null"),
    role: parseInt(sessionStorage.getItem("role") || "0"),
    teams: JSON.parse(sessionStorage.getItem("teams") || "[]"),
    email: sessionStorage.getItem("email") || "",
    username: sessionStorage.getItem("username") || "",
    userId: parseInt(sessionStorage.getItem("userId") || "0")
  }),

  actions: {
    async login(email: string, password: string): Promise<APIResponse> {
      try {
        const response = await fetchData("POST", "/login", { email, password })
        if (response.status !== 200) {
          return response
        }

        console.log("Login response", response)
        const user: User = response.data

        console.log("Login successful", user)
        // Store user data in the store
        this.user = user
        this.userId = user.id
        this.role = user.role_id
        this.teams = user.teams
        this.email = user.email
        this.username = user.username

        // Persist user data in sessionStorage
        sessionStorage.setItem("user", JSON.stringify(user))
        sessionStorage.setItem("userId", user.id.toString())
        sessionStorage.setItem("role", user.role_id.toString())
        sessionStorage.setItem("teams", JSON.stringify(user.teams))
        sessionStorage.setItem("email", user.email)
        sessionStorage.setItem("username", user.username)

        router.push("/")
        return response
      } catch (error) {
        console.error("Login failed", error)
        return { status: 500, data: null, message: "Login failed" } as APIResponse
      }
    },

    async logout() {
      const response = await fetchData("POST", "/logout")
      if (response.status !== 200) return

      this.user = null
      this.role = 0
      this.teams = []
      this.userId = 0
      this.email = ""
      this.username = ""

      // Remove user data from sessionStorage
      sessionStorage.removeItem("user")
      sessionStorage.removeItem("userId")
      sessionStorage.removeItem("role")
      sessionStorage.removeItem("teams")
      sessionStorage.removeItem("email")
      sessionStorage.removeItem("username")
      router.push("/login")
    }
  },

  getters: {
    // Getters for each state value
    getUser: (state) => state.user,
    getRole: (state) => state.role,
    getTeams: (state) => state.teams,
    getEmail: (state) => state.email,
    getUsername: (state) => state.username,
    getUserId: (state) => state.userId,

    // Additional computed getters
    isLoggedIn: (state) => !!state.user,
    hasRole: (state) => (roleId: number) => state.role === roleId,
    isInTeam: (state) => (teamId: number) => state.teams.includes(teamId)
  }
})
