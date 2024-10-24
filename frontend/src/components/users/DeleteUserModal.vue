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
import { toast } from "../ui/toast/use-toast";
import { fetchData } from "@/services/api";

// Props
const props = defineProps({
  id: Number, 
})

const emit = defineEmits(["close", "refresh"])

async function deleteUser(id: number) {
  try {
    const response = await fetchData("DELETE", `/users/${id}`)
    if (response.status === 204) {
      toast({
          description: `User successfully deleted !`
        })
    emit("refresh")
    } else {
      toast({
          description: `Failed to delete user.`,
          variant: "destructive"
        })
    }
  } catch (error) {
    toast({
        description: `Error deleting user.`,
        variant: "destructive"
      })
    console.log(error)
  }
}

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
            <Button variant="destructive" @click="deleteUser(props.id); isModalOpen = false">Delete</Button>
        </DialogClose>
        <DialogClose as-child>
            <Button variant="secondary" @click="isModalOpen = false">Cancel</Button>
        </DialogClose>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
