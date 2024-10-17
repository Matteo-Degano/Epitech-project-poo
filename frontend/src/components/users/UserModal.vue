<script setup lang="ts">
import { reactive, ref } from "vue"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from "@/components/ui/dialog"
import {fetchData} from "@/services/api"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Select } from "@/components/ui/select"

const isModalOpen = ref(false)

const props = defineProps({
  mode: String, // 'create' or 'update'
  data: Object // UserObject
})

type TeamType = {
    id: number
    name: string
}

// Sample data
const data: TeamType[] = reactive([
  {
    id: 1,
    name: "Team A"
  },
  {
    id: 2,
    name: "Team B"
  }
])

</script>

<template>
  <Dialog>
    <DialogTrigger class="space-x-4">
      <Button>
        {{ props.mode === "create" ? "Create user" : "Update" }}
      </Button>
    </DialogTrigger>
    <DialogContent>
      <DialogHeader>
        <DialogTitle>
          {{ props.mode === "create" ? "Create user" : "Update user" }}
        </DialogTitle>
      </DialogHeader>
    </DialogContent>
  </Dialog>
</template>
