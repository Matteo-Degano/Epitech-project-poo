<script setup lang="ts">
import DayWorkedChart from "@/components/charts/DayWorkedChart.vue"
import HoursWorkedChart from "@/components/charts/HoursWorkedChart.vue"
import ExtraTimeChart from "@/components/charts/ExtraTimeChart.vue"
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList
} from "@/components/ui/command"
import { Popover, PopoverTrigger, PopoverContent } from "@/components/ui/popover"
import { Button } from "@/components/ui/button"
import { fetchData } from "@/services/api"
import { useAuthStore } from "@/stores/auth.store"
import { onMounted, ref, computed, watch } from "vue"
import { useRoute, useRouter } from "vue-router"
import { useToast } from "@/components/ui/toast/use-toast"
import type { User } from "@/types/api.type"
import { cn } from "@/utils"
import { Select, SelectContent, SelectItem, SelectTrigger } from "@/components/ui/select"
import { Label } from "@/components/ui/label"
import { Separator } from "@/components/ui/separator"
import { Check, ChevronDown } from "lucide-vue-next"
import Spinner from "@/components/Spinner.vue"

const authStore = useAuthStore()
const { toast } = useToast()
const route = useRoute()
const router = useRouter()
const isEmployee = authStore.isEmployee
const usersList = ref<User[]>([])
const selectedUser = ref("")
const chartId = Number(route.params.id)
const workedDay = ref(null)
const dayTime = ref(null)
const nightTime = ref(null)
const extraTime = ref(null)
const isLoading = ref(true)
const error = ref(null)
const open = ref(false)

// Define month array with start and end days
const monthDefinitions = [
  { name: "January", startDay: "01", endDay: "31" },
  { name: "February", startDay: "01", endDay: "28" }, // Adjust for leap years
  { name: "March", startDay: "01", endDay: "31" },
  { name: "April", startDay: "01", endDay: "30" },
  { name: "May", startDay: "01", endDay: "31" },
  { name: "June", startDay: "01", endDay: "30" },
  { name: "July", startDay: "01", endDay: "31" },
  { name: "August", startDay: "01", endDay: "31" },
  { name: "September", startDay: "01", endDay: "30" },
  { name: "October", startDay: "01", endDay: "31" },
  { name: "November", startDay: "01", endDay: "30" },
  { name: "December", startDay: "01", endDay: "31" }
]

// Helper to determine if a year is a leap year
function isLeapYear(year: number): boolean {
  return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0
}

// Generate the last 12 months with fixed start and end dates
const months = ref(
  Array.from({ length: 12 }, (_, i) => {
    const currentDate = new Date()
    const monthIndex = (currentDate.getMonth() - i + 12) % 12
    const yearOffset = Math.floor((currentDate.getMonth() - i) / 12)
    const year = currentDate.getFullYear() + yearOffset

    const { startDay, endDay, name } = monthDefinitions[monthIndex]
    const adjustedEndDay = monthIndex === 1 && isLeapYear(year) ? "29" : endDay // Adjust February for leap years

    return {
      label: `${name} ${year}`,
      start: `${year}-${String(monthIndex + 1).padStart(2, "0")}-${startDay}T00:00:00.000Z`,
      end: `${year}-${String(monthIndex + 1).padStart(2, "0")}-${adjustedEndDay}T23:59:59.999Z`
    }
  })
)

const selectedMonth = ref(months.value[0])

// Computed totals
const daysWorked = computed(() => {
  if (!workedDay.value) return 0
  const workedDaysEntry = workedDay.value.data.find((entry) => entry.name === "Worked Days")
  return workedDaysEntry ? workedDaysEntry.value : 0
})

const totalHoursWorked = computed(() => {
  if (!dayTime.value) return "0h 0m"
  const totalSeconds = dayTime.value.data.reduce((sum, entry) => sum + entry.time_worked, 0)
  const hours = Math.floor(totalSeconds / 3600)
  const minutes = Math.floor((totalSeconds % 3600) / 60)
  return `${hours}h ${minutes}m`
})

const totalExtraHours = computed(() => {
  if (!extraTime.value) return "0h 0m"
  const totalSeconds = extraTime.value.data.reduce((sum, entry) => sum + entry.value, 0)
  const hours = Math.floor(totalSeconds / 3600)
  const minutes = Math.floor((totalSeconds % 3600) / 60)
  return `${hours}h ${minutes}m`
})

// Fetch functions
const fetchUsersLists = async () => {
  try {
    const response = await fetchData("GET", "/users")
    usersList.value = response.data
  } catch (err) {
    toast({ variant: "destructive", description: "Error fetching data" })
  }
}

const fetchChart = async (
  start = selectedMonth.value.start,
  end = selectedMonth.value.end,
  id = chartId || authStore.userId
) => {
  try {
    isLoading.value = true
    const response = await fetchData("GET", `/chartmanager/${id}?start=${start}&end=${end}`)
    if (response.status === 200) {
      console.log(response.data)
      workedDay.value = response.data.chart_1
      dayTime.value = response.data.chart_2
      nightTime.value = response.data.chart_3
      extraTime.value = response.data.chart_4
    }
  } catch (err) {
    error.value = err.message || "Error fetching data"
    toast({ variant: "destructive", description: error.value })
  } finally {
    isLoading.value = false
  }
}

// Watchers
watch(selectedMonth, (newVal) => {
  fetchChart(newVal.start, newVal.end)
})

watch(
  () => selectedUser.value,
  (newValue) => {
    const userId = usersList.value.find((user) => user.username === newValue)?.id
    if (userId !== undefined) {
      router.push(`/charts/${userId}`)
      fetchChart(selectedMonth.value.start, selectedMonth.value.end, userId)
    }
  }
)

onMounted(async () => {
  await fetchChart(selectedMonth.value.start, selectedMonth.value.end)
  if (!isEmployee) await fetchUsersLists()
})
</script>

<template>
  <div class="flex flex-col h-[calc(100vh-80px)] p-4">
    <Spinner v-if="isLoading"/>
    <div v-if="!isLoading" class="flex flex-col h-full gap-4">
      <div class="flex gap-4 bg-primary rounded-md p-4">
        <div class="flex items-center gap-2 flex-grow">
          <Label class="text-background text-xl">Month: </Label>
          <Select v-model="selectedMonth">
            <SelectTrigger>
              <span>{{ selectedMonth.label }}</span>
            </SelectTrigger>
            <SelectContent>
              <SelectItem v-for="(month, index) in months" :key="index" :value="month">
                {{ month.label }}
              </SelectItem>
            </SelectContent>
          </Select>
        </div>
        <div v-if="!isEmployee" class="flex items-center gap-2 w-1/2">
          <Label class="text-background text-xl"> User: </Label>
          <Popover v-model:open="open">
            <PopoverTrigger as-child>
              <Button
                variant="outline"
                role="combobox"
                :aria-expanded="open"
                class="w-full justify-between font-normal"
              >
                {{
                  selectedUser
                    ? usersList.find((user) => user.username === selectedUser)?.username
                    : "Select a user..."
                }}
                <ChevronDown class="ml-2 h-4 w-4 shrink-0 opacity-50" />
              </Button>
            </PopoverTrigger>
            <PopoverContent class="p-0">
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
      </div>
      <div class="flex flex-grow h-1/2 w-full gap-8 p-8 pl-0">
        <div class="flex flex-col border-4 rounded-md p-6 bg-secondary border-[#9c4ff5] w-96 gap-6">
          <div class="flex flex-col gap-2">
            <Label class="text-xl">Days Worked</Label>
            <p class="text-xl pl-4 text-primary font-semibold">{{ daysWorked }} days</p>
          </div>
          <div class="flex flex-col gap-2">
            <Label class="text-xl">Total Hours</Label>
            <p class="text-xl pl-4 text-primary font-semibold">{{ totalHoursWorked }}</p>
          </div>
          <div class="flex flex-col gap-2">
            <Label class="text-xl">Total Extra Hours</Label>
            <p class="text-xl pl-4 text-primary font-semibold">{{ totalExtraHours }}</p>
          </div>
        </div>
        <ExtraTimeChart v-if="extraTime" :data="extraTime" class="w-full" />
      </div>
      <Separator />
      <div class="flex items-center flex-grow h-1/2 w-full gap-12">
        <DayWorkedChart v-if="workedDay" :data="workedDay" class="w-96" />
        <HoursWorkedChart v-if="dayTime" :data="dayTime" class="w-full" />
      </div>
    </div>
  </div>
</template>
