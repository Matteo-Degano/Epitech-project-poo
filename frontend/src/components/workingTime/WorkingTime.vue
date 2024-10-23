<script setup lang="ts">
import { computed, onMounted, ref, watch } from "vue"
import { fetchData } from "@/services/api"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Check, ChevronsUpDown } from "lucide-vue-next"
import { cn } from "@/utils"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from "@/components/ui/dialog"
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList
} from "@/components/ui/command"
import { DateFormatter, getLocalTimeZone, CalendarDate } from "@internationalized/date"
import { Calendar } from "@/components/ui/calendar"
import { Popover, PopoverTrigger, PopoverContent } from "@/components/ui/popover"
import DialogDescription from "../ui/dialog/DialogDescription.vue"
import { useToast } from "../ui/toast/use-toast"
import { CirclePlus } from "lucide-vue-next"
import type { APIResponse, User } from "@/types/api.type"

const props = defineProps({
  mode: String,
  data: Object,
  workingTimeData: Array
})

const { toast } = useToast()
const isModalOpen = ref(false)
const selectedStartDate = ref(getInitialDate(props.data?.start) || null)
const selectedEndDate = ref(getInitialDate(props.data?.end) || null)
const selectedUser = ref(props.data?.user_id || "")
const usersList = ref<User[]>([])
const open = ref(false)
const emit = defineEmits(["close", "refresh"])

function getInitialDate(datetime: any): CalendarDate | null {
  const date = datetime?.split("T")[0]
  if (date) {
    let [year, month, day] = date.split("-").map(Number)
    return new CalendarDate(year, month, day)
  }
  return null
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
      selectedStartDate.value = getInitialDate(newValue.start) || null
      timeRange.value.start = newValue.start.split("T")[1]?.split(":").slice(0, 2).join(":") || "" // Only hours and minutes

      // Extract date and time for the end datetime
      selectedEndDate.value = getInitialDate(newValue.end)
      timeRange.value.end = newValue.end.split("T")[1]?.split(":").slice(0, 2).join(":") || "" // Only hours and minutes
    }
  },
  { immediate: true }
)
const isSaveDisabled = computed(() => {
  return (
    !selectedStartDate.value ||
    !timeRange.value.start ||
    !selectedEndDate.value ||
    !timeRange.value.end ||
    (props.mode === "create" && !selectedUser.value)
  )
})

function clearInputs() {
  selectedStartDate.value = null
  selectedEndDate.value = null
  timeRange.value.start = ""
  timeRange.value.end = ""
  selectedUser.value = ""
}

async function submitWorkingTime() {
  const formattedStartDate = `${selectedStartDate?.value?.year}-${String(selectedStartDate?.value?.month).padStart(2, "0")}-${String(selectedStartDate?.value?.day).padStart(2, "0")}`
  const formattedEndDate = `${selectedEndDate?.value?.year}-${String(selectedEndDate?.value?.month).padStart(2, "0")}-${String(selectedEndDate?.value?.day).padStart(2, "0")}`

  let userId = selectedUser.value

  if (props.mode === "create") {
    const matchedUser = usersList.value.find((user) => user.username === selectedUser.value)
    if (matchedUser) {
      userId = matchedUser.id
    }
  }

  const requestData = {
    start: `${formattedStartDate} ${timeRange.value.start}`,
    end: `${formattedEndDate} ${timeRange.value.end}`
  }

  try {
    let response: APIResponse
    let description: string
    if (props.mode === "create") {
      response = await fetchData("POST", `/workingtime/${userId}`, requestData)
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

const fetchUsersLists = async () => {
  try {
    const response = await fetchData("GET", "/users")
    usersList.value = response.data
    console.log(usersList)
  } catch (err: any) {
    toast({
      variant: "destructive",
      description: "Error fetching data"
    })
  }
}

onMounted(() => {
  fetchUsersLists()
  if (props.mode === "update") {
    selectedUser.value = props.data?.user_id
  }
})
</script>

<template>
  <Dialog>
    <DialogTrigger as-child>
      <Button v-if="props.mode === 'create'" class="flex gap-2 bg-green-600 hover:bg-green-500"
        ><CirclePlus />Add a new Working Time
      </Button>
      <Button v-if="props.mode === 'update'">Update</Button>
    </DialogTrigger>
    <DialogContent class="max-w-md">
      <DialogHeader>
        <DialogTitle>{{
          props.mode === "create" ? "Create Working Time" : "Update Working Time"
        }}</DialogTitle>
      </DialogHeader>
      <DialogDescription>Select a start datetime and end datetime</DialogDescription>

      <div v-if="props.mode === 'create'" class="flex justify-between items-center">
        <Label> User: </Label>
        <Popover v-model:open="open">
          <PopoverTrigger as-child>
            <Button
              variant="outline"
              role="combobox"
              :aria-expanded="open"
              class="w-[200px] justify-between"
            >
              {{
                selectedUser
                  ? usersList.find((user) => user.username === selectedUser)?.username
                  : "Select a user..."
              }}
              <ChevronsUpDown class="ml-2 h-4 w-4 shrink-0 opacity-50" />
            </Button>
          </PopoverTrigger>
          <PopoverContent class="w-[200px] p-0">
            <Command v-model="selectedUser">
              <CommandInput placeholder="Search user..." />
              <CommandEmpty>No users found.</CommandEmpty>
              <CommandList>
                <CommandGroup>
                  <CommandItem
                    v-for="user in usersList"
                    :key="user.id"
                    :value="user.username"
                    @select="open = false"
                  >
                    {{ user.username }}
                    <Check
                      :class="
                        cn(
                          'ml-auto h-4 w-4',
                          selectedUser.value === user.username ? 'opacity-100' : 'opacity-0'
                        )
                      "
                    />
                  </CommandItem>
                </CommandGroup>
              </CommandList>
            </Command>
          </PopoverContent>
        </Popover>
      </div>
      <div class="flex justify-between items-center mb-4">
        <Label>Start Date:</Label>
        <div class="flex gap-2">
          <Popover>
            <PopoverTrigger as-child>
              <Button variant="outline" class="justify-start w-auto text-left font-normal">
                {{
                  selectedStartDate
                    ? df.format(selectedStartDate.toDate(getLocalTimeZone()))
                    : "Pick a start date"
                }}
              </Button>
            </PopoverTrigger>
            <PopoverContent class="w-auto p-0">
              <Calendar v-model="selectedStartDate" initial-focus />
            </PopoverContent>
          </Popover>
          <Input
            type="time"
            step="60"
            v-model="timeRange.start"
            class="w-auto cursor-pointer hover:bg-gray-100"
          />
        </div>
      </div>
      <div class="flex justify-between items-center">
        <Label>End Date:</Label>
        <div class="flex gap-2">
          <Popover>
            <PopoverTrigger as-child>
              <Button variant="outline" class="justify-start w-auto text-left font-normal">
                {{
                  selectedEndDate
                    ? df.format(selectedEndDate.toDate(getLocalTimeZone()))
                    : "Pick an end date"
                }}
              </Button>
            </PopoverTrigger>
            <PopoverContent class="w-auto p-0">
              <Calendar v-model="selectedEndDate" initial-focus />
            </PopoverContent>
          </Popover>
          <Input
            type="time"
            step="60"
            v-model="timeRange.end"
            class="w-auto cursor-pointer hover:bg-gray-100"
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
