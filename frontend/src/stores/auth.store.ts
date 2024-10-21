import router from "@/router"
import { fetchData } from "@/services/api"
import type { APIResponse } from "@/types/api.type"
import { defineStore } from "pinia"

export const useAuthStore = defineStore("auth", {
  state: () => ({
    // Initialize user, role, team, email, and username from sessionStorage
    user: JSON.parse(sessionStorage.getItem("user") || "null"),
    role: parseInt(sessionStorage.getItem("role") || "0"),
    team: parseInt(sessionStorage.getItem("team") || "0"),
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
        const user = response.data

        console.log("Login successful", user)
        // Store user, role_id, team_id, email, and username in Pinia
        this.user = user
        this.userId = user.id
        this.role = user.role_id
        this.team = user.team_id
        this.email = user.email
        this.username = user.username

        // Persist user, role_id, team_id, email, and username in sessionStorage
        sessionStorage.setItem("user", JSON.stringify(user))
        sessionStorage.setItem("userId", user.id.toString())
        sessionStorage.setItem("role", user.role_id.toString())
        sessionStorage.setItem("team", user.team_id.toString())
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
      this.team = 0
      this.userId = 0
      this.email = ""
      this.username = ""

      // Remove user, role_id, team_id, email, and username from sessionStorage
      sessionStorage.removeItem("user")
      sessionStorage.removeItem("userId")
      sessionStorage.removeItem("role")
      sessionStorage.removeItem("team")
      sessionStorage.removeItem("email")
      sessionStorage.removeItem("username")
      router.push("/login")
    }
  },

  getters: {
    // Getters for each state value
    getUser: (state) => state.user,
    getRole: (state) => state.role,
    getTeam: (state) => state.team,
    getEmail: (state) => state.email,
    getUsername: (state) => state.username,
    getUserId: (state) => state.userId,

    // Additional computed getters
    isLoggedIn: (state) => !!state.user, // Check if user is logged in
    hasRole: (state) => (roleId: number) => state.role === roleId, // Check role
    isInTeam: (state) => (teamId: number) => state.team === teamId // Check team
  }
})
