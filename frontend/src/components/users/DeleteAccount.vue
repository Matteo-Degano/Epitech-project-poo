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
import { UserX } from "lucide-vue-next"
import { toast } from "../ui/toast/use-toast";
import { fetchData } from "@/services/api";
import { useAuthStore } from "@/stores/auth.store";
import { useRouter } from "vue-router";

const authStore = useAuthStore()
const router = useRouter()

async function deleteUser() {
  try {
    const response = await fetchData("DELETE", `/users/${authStore.user.id}`)
    if (response.status === 204) {
        await authStore.logout()
        router.push("/login")
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
        <div class="flex gap-1 items-center text-red-600 cursor-pointer"><UserX/> Delete account</div>
    </DialogTrigger>
    <DialogContent>
      <DialogHeader>
        <DialogTitle>Are you sure ?</DialogTitle>
        <DialogDescription>
            This action cannot be undone. This will permanently delete your
            account and remove your data from our servers.
        </DialogDescription>
      </DialogHeader>
      <DialogFooter>
        <DialogClose as-child>
            <Button variant="destructive" @click="deleteUser">Delete</Button>
        </DialogClose>
        <DialogClose as-child>
            <Button variant="secondary" @click="isModalOpen = false">Cancel</Button>
        </DialogClose>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
