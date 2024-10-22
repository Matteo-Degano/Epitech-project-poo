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
import { DateFormatter, getLocalTimeZone, CalendarDate } from "@internationalized/date"
import { Calendar } from "@/components/ui/calendar"
import { Popover, PopoverTrigger, PopoverContent } from "@/components/ui/popover"
import { useAuthStore } from "@/stores/auth.store"
import DialogDescription from "../ui/dialog/DialogDescription.vue"
import { useToast } from "../ui/toast/use-toast"
import { CirclePlus } from "lucide-vue-next"
import type { APIResponse } from "@/types/api.type"

const props = defineProps({
  mode: String,
  data: Object,
  workingTimeData: Array
})

const { toast } = useToast()
const authStore = useAuthStore()
const isModalOpen = ref(false)
const selectedDate = ref(getInitialDate() || null)
const emit = defineEmits(["close", "refresh"])

function getInitialDate() {
  const date = props.data?.start.split("T")[0]
  if (date) {
    let [year, month, day] = date.split("-").map(Number)
    return new CalendarDate(year, month, day)
  }
}

const timeRange = ref({
  start: props.data?.start.split("T")[1].split(".")[0] || "",
  end: props.data?.end.split("T")[1].split(".")[0] || ""
})

const df = new DateFormatter("en-US", {
  dateStyle: "long"
})

watch(
  () => props.data,
  (newValue) => {
    if (newValue) {
      timeRange.value.start = newValue.start
      timeRange.value.end = newValue.end
    }
  }
)

const isSaveDisabled = computed(() => {
  return !selectedDate.value || !timeRange.value.start || !timeRange.value.end
})

function clearInputs() {
  selectedDate.value = null
  timeRange.value.start = ""
  timeRange.value.end = ""
}

async function submitWorkingTime() {
  const formattedDate = `${selectedDate?.value?.year}-${String(selectedDate?.value?.month).padStart(2, "0")}-${String(selectedDate?.value?.day).padStart(2, "0")}`

  const requestData = {
    start: `${formattedDate} ${timeRange.value.start}`,
    end: `${formattedDate} ${timeRange.value.end}`
  }

  try {
    let response: APIResponse
    let description: string
    if (props.mode === "create") {
      response = await fetchData("POST", `/workingtime/${authStore.user.id}`, requestData)
      description = "Working time created successfully"
    } else {
      response = await fetchData("PUT", `/workingtime/${props?.data?.id}`, requestData)
      description = "Working time updated successfully"
    }

    if (response.status === 201 || response.status === 200) {
      clearInputs()
      emit("close")
      emit("refresh")
      isModalOpen.value = false
      toast({
        description: description
      })
    } else {
      toast({
        variant: "destructive",
        description: "Failed to save working time"
      })
    }
  } catch (error) {
    toast({
      variant: "destructive",
      description: "Error in working time operation: " + error
    })
  }
  clearInputs()
  emit("close")
  isModalOpen.value = false
}
</script>

<template>
  <Dialog>
    <DialogTrigger as-child>
      <Button v-if="props.mode === 'create'" class="flex gap-2 bg-green-600 hover:bg-green-500"
        ><CirclePlus />Add a new Working Time
      </Button>
      <Button v-if="props.mode === 'update'">Update</Button>
    </DialogTrigger>
    <DialogContent class="max-w-96">
      <DialogHeader>
        <DialogTitle>{{
          props.mode === "create" ? "Create Working Time" : "Update Working Time"
        }}</DialogTitle>
      </DialogHeader>
      <DialogDescription>Select a date, a start time and a end time</DialogDescription>
      <div class="flex flex-col gap-4 my-8">
        <Popover>
          <PopoverTrigger as-child>
            <Button variant="outline" class="justify-start w-full text-left font-normal">
              {{
                selectedDate ? df.format(selectedDate.toDate(getLocalTimeZone())) : "Pick a date"
              }}
            </Button>
          </PopoverTrigger>
          <PopoverContent class="w-auto p-0">
            <Calendar v-model="selectedDate" initial-focus />
          </PopoverContent>
        </Popover>

        <div class="flex flex-col gap-2">
          <p>Start time:</p>
          <input
            type="time"
            v-model="timeRange.start"
            class="p-1 border border-gray-300 rounded-md h-full cursor-pointer"
          />
          <p>End time:</p>
          <input
            type="time"
            v-model="timeRange.end"
            class="p-1 border border-gray-300 rounded-md h-full cursor-pointer"
          />
        </div>
      </div>
      <DialogFooter>
        <DialogClose as-child>
          <Button type="button" variant="destructive">Cancel</Button>
        </DialogClose>
        <DialogClose as-child>
          <Button
            type="button"
            class="bg-green-600 hover:bg-green-500"
            @click="submitWorkingTime"
            :disabled="isSaveDisabled"
          >
            {{ props.mode === "create" ? "Create" : "Update" }}
          </Button>
        </DialogClose>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
