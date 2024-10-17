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

const authStore = useAuthStore()

const logoutHandler = async () => {
  authStore.logout()
}
</script>

<template>
  <NavigationMenu class="p-2 min-w-full border-b shadow-sm">
    <div class="flex justify-between items-center w-full">
      <NavigationMenuList>
        <NavigationMenuItem>
          <NavigationMenuLink href="/" :class="navigationMenuTriggerStyle()">
            <div class="flex gap-1 items-center"><House :size="18" /> Home</div>
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink href="/working-times" :class="navigationMenuTriggerStyle()">
            <div class="flex gap-1 items-center"><Clock :size="18" /> Working Hours</div>
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink href="/users" :class="navigationMenuTriggerStyle()">
            <div class="flex gap-1 items-center"><Users :size="18" /> Users</div>
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink href="/charts" :class="navigationMenuTriggerStyle()">
            <div class="flex gap-1 items-center"><ChartSpline :size="18" /> Charts</div>
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink :class="navigationMenuTriggerStyle()">
            <button @click="logoutHandler">
              <div class="flex gap-1 items-center text-red-600"><LogOut :size="18" /> Logout</div>
            </button>
          </NavigationMenuLink>
        </NavigationMenuItem>
      </NavigationMenuList>
      <ClockManager />
    </div>
  </NavigationMenu>
</template>
