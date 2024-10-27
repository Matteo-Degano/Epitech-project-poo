<script setup lang="ts">
import { useAuthStore } from "@/stores/auth.store"
import { cn } from "@/utils"
import {
  NavigationMenuViewport,
  type NavigationMenuViewportProps,
  useForwardProps
} from "radix-vue"
import { computed, type HTMLAttributes } from "vue"

const authStore = useAuthStore()
const role = authStore.getRole

const expend = role === 3 || role === 4

const props = defineProps<NavigationMenuViewportProps & { class?: HTMLAttributes["class"] }>()

const delegatedProps = computed(() => {
  const { class: _, ...delegated } = props

  return delegated
})

const forwardedProps = useForwardProps(delegatedProps)
</script>

<template>
  <div :class="['absolute top-full flex justify-center', expend ? 'left-[500px]' : 'left-[330px]']">
    <NavigationMenuViewport
      v-bind="forwardedProps"
      :class="
        cn(
          'origin-top-center relative mt-1.5 h-[--radix-navigation-menu-viewport-height] w-full overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-90 md:w-[--radix-navigation-menu-viewport-width]',
          props.class
        )
      "
    />
  </div>
</template>
