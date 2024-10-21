<script setup lang="ts">
import {
  NavigationMenu,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList,
  navigationMenuTriggerStyle
} from "@/components/ui/navigation-menu"
import ClockManager from "../ClockManager.vue"
import { useAuthStore } from "@/stores/auth.store"
import { House, Clock, Users, ChartSpline, LogOut } from "lucide-vue-next"
import { useRoute } from "vue-router" // Import useRoute to access the current route

const authStore = useAuthStore()
const route = useRoute() // Get the current route

const logoutHandler = async () => {
  authStore.logout()
}

// Function to check if the link is active
const isActive = (path: string) => route.path === path
</script>

<template>
  <NavigationMenu class="p-2 min-w-full border-b shadow-sm">
    <div class="flex justify-between items-center w-full">
      <NavigationMenuList>
        <NavigationMenuItem>
          <NavigationMenuLink
            href="/"
            :class="[navigationMenuTriggerStyle(), { 'text-primary': isActive('/') }]"
          >
            <div class="flex gap-1 items-center"><House :size="18" /> Home</div>
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink
            href="/working-times"
            :class="[navigationMenuTriggerStyle(), { 'text-primary': isActive('/working-times') }]"
          >
            <div class="flex gap-1 items-center"><Clock :size="18" /> Working Hours</div>
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink
            href="/users"
            :class="[navigationMenuTriggerStyle(), { 'text-primary': isActive('/users') }]"
          >
            <div class="flex gap-1 items-center"><Users :size="18" /> Users</div>
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink
            href="/charts"
            :class="[navigationMenuTriggerStyle(), { 'text-primary': isActive('/charts') }]"
          >
            <div class="flex gap-1 items-center"><ChartSpline :size="18" /> Charts</div>
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink
            :class="[
              navigationMenuTriggerStyle(),
              'text-red-600',
              'hover:bg-red-600',
              'hover:text-primary-foreground'
            ]"
          >
            <button @click="logoutHandler">
              <div class="flex gap-1 items-center"><LogOut :size="18" /> Logout</div>
            </button>
          </NavigationMenuLink></NavigationMenuItem
        >
      </NavigationMenuList>
      <ClockManager />
    </div>
  </NavigationMenu>
</template>
