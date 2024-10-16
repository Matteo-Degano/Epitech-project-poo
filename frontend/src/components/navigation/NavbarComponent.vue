<script setup lang="ts">
import {
  NavigationMenu,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList,
  navigationMenuTriggerStyle
} from "@/components/ui/navigation-menu"
import ClockManager from "../ClockManager.vue"
</script>

<template>
  <NavigationMenu class="p-2 min-w-full border-b shadow-sm">
    <div class="flex justify-between items-center w-full">
      <NavigationMenuList>
        <NavigationMenuItem>
          <NavigationMenuLink href="/" :class="navigationMenuTriggerStyle()">
            Home
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink href="/working-times" :class="navigationMenuTriggerStyle()">
            Working Hours
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink href="/users" :class="navigationMenuTriggerStyle()">
            Users
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink href="/charts" :class="navigationMenuTriggerStyle()">
            Charts
          </NavigationMenuLink>
        </NavigationMenuItem>
        <NavigationMenuItem>
          <NavigationMenuLink href="/login" :class="navigationMenuTriggerStyle()">
            Login
          </NavigationMenuLink>
        </NavigationMenuItem>
      </NavigationMenuList>
      <ClockManager />
    </div>
  </NavigationMenu>
</template>
