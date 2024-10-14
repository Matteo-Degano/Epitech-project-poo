<script setup lang="ts">
import { ref } from "vue"
import { fetchData } from "@/services/api"
import { User } from "lucide-vue-next"
import { useUserStore } from "@/stores/user"
import type { APIResponse } from "@/types/api.type"
import NavigationMenu from '@/components/ui/navigationMenu/NavigationMenu.vue'

const userStore = useUserStore()

// Utilisateur actuel
const user = ref({ id: 0, username: "null", email: "null" })

// Formulaire d'édition et de création
const userForm = ref({ username: "", email: "" })

// Mode "view", "edit", "create" pour contrôler l'affichage
const mode = ref("view")

// GET un user
async function getUser() {
  if (user.value.id === 0) {
    alert("Please enter an ID")
    return
  }
  const response: APIResponse = await fetchData("GET", "/users/" + user.value.id)
  user.value = response.data
  userStore.setUser(user.value.id, user.value.username, user.value.email)
  mode.value = "view"
}

// POST ou PUT un user
async function saveUser() {
  const url = mode.value === "create" ? "/users" : "/users/" + user.value.id
  const method = mode.value === "create" ? "POST" : "PUT"
  const response: APIResponse = await fetchData(method, url, { user: userForm.value })
  user.value = response.data
  userStore.setUserId(user.value.id)
  mode.value = "view"
}

// DELETE un user
async function deleteUser() {
  const response: APIResponse = await fetchData("DELETE", "/users/" + user.value.id)
  user.value = { id: 0, username: "null", email: "null" }
  mode.value = "view"
  if (response.status === 200) {
    console.log("User deleted successfully")
  }
}

// Toggle entre les modes vue (les infos quoi, et les boutons d'action), édition et création
function toggleMode(newMode: string) {
  if (newMode === mode.value) {
    mode.value = "view"
    return
  }
  if (newMode === "edit") {
    userForm.value = { ...user.value }
  } else {
    userForm.value = { username: "", email: "" }
  }
  mode.value = newMode
}
</script>

<template>
  <NavigationMenu />
  <div class="bg-white p-6 rounded-lg w-full h-full">
    <div class="flex items-center gap-2 mb-4">
      <User class="w-5 h-5 text-gray-500" />
      <h1 class="font-medium text-lg text-gray-800">Vous êtes connecté en tant que :</h1>
    </div>

    <input
      type="number"
      v-model="user.id"
      class="bg-gray-100 border border-gray-300 rounded-lg px-4 py-2 mb-3 w-full focus:outline-none focus:border-gray-400 transition"
      placeholder="User ID"
    />
    <span class="text-xs text-gray-500"
      >Entrer l'id de l'utilisateur pour obtenir les informations (système temporaire tant que y'a
      pas d'auth mdrr)</span
    >

    <div v-if="mode === 'view'" class="mt-5">
      <h2 class="font-medium text-gray-700">
        Username: <span class="text-gray-900">{{ user.username }}</span>
      </h2>
      <h2 class="font-medium text-gray-700">
        Email: <span class="text-gray-900">{{ user.email }}</span>
      </h2>
    </div>

    <div v-else class="mt-5">
      <h2 class="font-medium text-gray-800 mb-3">
        {{ mode === "edit" ? "Edit User" : "Create New User" }}
      </h2>
      <input
        type="text"
        v-model="userForm.username"
        class="bg-gray-100 border border-gray-300 rounded-lg px-4 py-2 mb-3 w-full focus:outline-none focus:border-gray-400 transition"
        placeholder="Enter Username"
      />
      <input
        type="email"
        v-model="userForm.email"
        class="bg-gray-100 border border-gray-300 rounded-lg px-4 py-2 mb-3 w-full focus:outline-none focus:border-gray-400 transition"
        placeholder="Enter Email"
      />
      <button
        class="w-full bg-gray-800 text-white py-2 rounded-lg hover:bg-gray-700 transition"
        @click="saveUser"
      >
        Confirm
      </button>
    </div>

    <div class="mt-5 flex gap-2">
      <button
        class="flex-1 bg-gray-100 text-gray-800 py-2 rounded-lg hover:bg-gray-200 transition"
        @click="getUser"
      >
        Get User
      </button>
      <button
        class="flex-1 bg-gray-100 text-gray-800 py-2 rounded-lg hover:bg-gray-200 transition"
        @click="() => toggleMode('edit')"
      >
        Edit
      </button>
      <button
        class="flex-1 bg-gray-100 text-red-600 py-2 rounded-lg hover:bg-gray-200 transition"
        @click="deleteUser"
      >
        Delete
      </button>
      <button
        class="flex-1 bg-gray-100 text-gray-800 py-2 rounded-lg hover:bg-gray-200 transition"
        @click="() => toggleMode('create')"
      >
        Create
      </button>
    </div>
  </div>
</template>
