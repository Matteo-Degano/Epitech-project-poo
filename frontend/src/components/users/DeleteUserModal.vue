<script setup lang="ts">
import { ref} from "vue"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
  DialogDescription
} from "@/components/ui/dialog"

// Props
const props = defineProps({
  id: Number, 
  function: Function
})

const emit = defineEmits(["close"])

const isModalOpen = ref(false)

</script>

<template>
  <Dialog>
    <DialogTrigger as-child>
      <Button variant="destructive">Delete</Button>
    </DialogTrigger>
    <DialogContent>
      <DialogHeader>
        <DialogTitle>Delete User</DialogTitle>
        <DialogDescription></DialogDescription>
      </DialogHeader>
      <p>Are you sure you want to delete this user?</p>
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
