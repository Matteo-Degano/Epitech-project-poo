<script setup lang="ts">
import { computed, ref, watch } from "vue"
import { fetchData } from "@/services/api"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from "@/components/ui/dialog"

// Props for mode and data
const props = defineProps({
  id: Number, // Working time data when updating
  function: Function // Function to delete the working time
})

const emit = defineEmits(["close"])

// Modal visibility state
const isModalOpen = ref(false)

</script>

<template>
  <Dialog>
    <DialogTrigger as-child>
      <Button variant="destructive">Delete</Button>
    </DialogTrigger>
    <DialogContent>
      <DialogHeader>
        <DialogTitle>Delete Working Time</DialogTitle>
        <DialogClose />
      </DialogHeader>
      <p>Are you sure you want to delete this working time?</p>
      <DialogFooter>
        <DialogClose as-child>
            <Button variant="destructive" @click="props.function(props.id); isModalOpen = false">Delete</Button>
        </DialogClose>
        <DialogClose as-child>
            <Button variant="secondary" @click="isModalOpen = false">Cancel</Button>
        </DialogClose>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
