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

const props = defineProps({
  id: Number, 
})

const emit = defineEmits(["close", "refresh"])

async function deleteTeam(id: number) {
  try {
    const response = await fetchData("DELETE", `/teams/${id}`)
    if (response.status === 204) {
      toast({
          description: `Team successfully deleted !`
        })
      emit("refresh")
    } else {
      toast({
          description: `Failed to delete team.`,
          variant: "destructive"
        })
    }
  } catch (error) {
    toast({
        description: `Error deleting team. Check if any members are still in the team.`,
        variant: "destructive"
      })
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
        <DialogTitle>Delete Team</DialogTitle>
        <DialogDescription></DialogDescription>
      </DialogHeader>
      <p>Are you sure you want to delete this team?</p>
      <DialogFooter>
        <DialogClose as-child>
            <Button variant="destructive" @click="deleteTeam(props.id); isModalOpen = false">Delete</Button>
        </DialogClose>
        <DialogClose as-child>
            <Button variant="secondary" @click="isModalOpen = false">Cancel</Button>
        </DialogClose>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
