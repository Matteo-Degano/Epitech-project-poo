<template>
  <div>
    <form @submit.prevent="login">
      <input type="email" v-model="email" placeholder="Email" />
      <input type="password" v-model="password" placeholder="Password" />
      <button type="submit">Login</button>
    </form>
  </div>
</template>

<script lang="ts">
import { useAuthStore } from "@/stores/auth.store"

export default {
  data() {
    return {
      email: "",
      password: ""
    }
  },
  methods: {
    async login() {
      const authStore = useAuthStore()
      try {
        await authStore.login(this.email, this.password)
        this.$router.push("/")
      } catch (error) {
        console.error("Login failed", error)
      }
    }
  }
}
</script>
