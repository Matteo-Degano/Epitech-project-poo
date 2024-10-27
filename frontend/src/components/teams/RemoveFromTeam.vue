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
  user: Object, 
  teamId: Number
})

const emit = defineEmits(["close", "refresh"])

async function removeFromTeam() {
    const updatedUser = {
        team_ids: props.user.teams
        .filter(team => team.id !== props.teamId)
        .map(team => team.id)
    }
  try {
    const response = await fetchData("PUT", `/users/${props.user.id}`, updatedUser)
    if (response.status === 200) {
      toast({
          description: `User successfully removed from team !`
        })
      emit("refresh")
    } else {
      toast({
          description: `Failed to remove user.`,
          variant: "destructive"
        })
    }
  } catch (error) {
    toast({
        description: `Error removing user : ${error}.`,
        variant: "destructive"
      })
  }
}

const isModalOpen = ref(false)

</script>

<template>
  <Dialog>
    <DialogTrigger as-child>
      <Button variant="destructive">Remove</Button>
    </DialogTrigger>
    <DialogContent>
      <DialogHeader>
        <DialogTitle>Remove from this team</DialogTitle>
        <DialogDescription></DialogDescription>
      </DialogHeader>
      <p>Are you sure you want to remove this user from this team?</p>
      <DialogFooter>
        <DialogClose as-child>
            <Button variant="destructive" @click="removeFromTeam(); isModalOpen = false">Remove</Button>
        </DialogClose>
        <DialogClose as-child>
            <Button variant="secondary" @click="isModalOpen = false">Cancel</Button>
        </DialogClose>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
