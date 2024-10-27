<script setup lang="ts">
import {
  NavigationMenu,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList
} from "@/components/ui/navigation-menu"
import ClockManager from "../ClockManager.vue"
import { useAuthStore } from "@/stores/auth.store"
import { House, Clock, Users, ChartSpline, LogOut, BookUser } from "lucide-vue-next"
import { useRoute, useRouter } from "vue-router"

const authStore = useAuthStore()
const route = useRoute()
const router = useRouter()

const logoutHandler = async () => {
  await authStore.logout()
  router.push("/login")
}

// Function to check if the link is active
const isActive = (path: string) => route.path === path

const role = authStore.role
const employee = 1
const manager = 2
const generalManager = 3
const admin = 4
</script>

<template>
  <NavigationMenu class="p-2 min-w-full border-b shadow-sm">
    <div class="flex justify-between items-center w-full">
      <NavigationMenuList class="flex gap-4">
        <NavigationMenuItem>
          <router-link to="/" :class="['nav-link', { 'text-primary': isActive('/') }]">
            <NavigationMenuLink as="div">
              <div class="flex gap-1 items-center"><House :size="18" /> Home</div>
            </NavigationMenuLink>
          </router-link>
        </NavigationMenuItem>

        <NavigationMenuItem>
          <router-link
            to="/working-times"
            :class="['nav-link', { 'text-primary': isActive('/working-times') }]"
          >
            <NavigationMenuLink as="div">
              <div class="flex gap-1 items-center"><Clock :size="18" /> Working Hours</div>
            </NavigationMenuLink>
          </router-link>
        </NavigationMenuItem>

        <NavigationMenuItem v-if="role === admin || role === generalManager">
          <router-link to="/users" :class="['nav-link', { 'text-primary': isActive('/users') }]">
            <NavigationMenuLink as="div">
              <div class="flex gap-1 items-center"><Users :size="18" /> Users</div>
            </NavigationMenuLink>
          </router-link>
        </NavigationMenuItem>

        <NavigationMenuItem v-if="role === admin || role === generalManager || role === manager">
          <router-link to="/teams" :class="['nav-link', { 'text-primary': isActive('/teams') }]">
            <NavigationMenuLink as="div">
              <div class="flex gap-1 items-center"><BookUser :size="18" /> Teams</div>
            </NavigationMenuLink>
          </router-link>
        </NavigationMenuItem>

        <NavigationMenuItem>
          <router-link to="/charts" :class="['nav-link', { 'text-primary': isActive('/charts') }]">
            <NavigationMenuLink as="div">
              <div class="flex gap-1 items-center"><ChartSpline :size="18" /> Charts</div>
            </NavigationMenuLink>
          </router-link>
        </NavigationMenuItem>

        <NavigationMenuItem>
          <NavigationMenuLink :class="['nav-link2', 'text-red-600']">
            <button @click="logoutHandler">
              <div class="flex gap-1 items-center"><LogOut :size="18" /> Logout</div>
            </button>
          </NavigationMenuLink>
        </NavigationMenuItem>
      </NavigationMenuList>

      <ClockManager />
    </div>
  </NavigationMenu>
</template>
