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
import { format, subMonths, endOfMonth, startOfMonth } from "date-fns"
import { Select, SelectTrigger, SelectContent, SelectItem } from "@/components/ui/select"
import Separator from "@/components/ui/separator/Separator.vue"
import Label from "@/components/ui/label/Label.vue"
import { useRoute, useRouter } from "vue-router"
import { useToast } from "@/components/ui/toast/use-toast"
import type { User } from "@/types/api.type"
import { cn } from "@/utils"

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

// Generate the last 12 months with start and end dates
const months = ref(
  Array.from({ length: 12 }, (_, i) => {
    const date = subMonths(new Date(), i)
    const start = startOfMonth(date).toISOString().split("T")[0] + "T00:00:01Z"
    const end = endOfMonth(date).toISOString().split("T")[0] + "T23:59:59Z"
    return {
      label: format(date, "MMMM yyyy"),
      start,
      end
    }
  })
)

const selectedMonth = ref(months.value[0])

// Computed properties to calculate totals
const totalHoursWorked = computed(() => {
  if (!dayTime.value) return 0
  const totalSeconds = dayTime.value.data.reduce((sum, entry) => sum + entry.time_worked, 0)
  return (totalSeconds / 3600).toFixed(2) // Convert to hours
})

const totalExtraHours = computed(() => {
  if (!extraTime.value) return 0
  const totalSeconds = extraTime.value.data.reduce((sum, entry) => sum + entry.value, 0)
  return (totalSeconds / 3600).toFixed(2) // Convert to hours
})

const daysWorked = computed(() => {
  if (!workedDay.value) return 0
  const workedDaysEntry = workedDay.value.data.find((entry) => entry.name === "Jours travaillés")
  return workedDaysEntry ? workedDaysEntry.value : 0
})

watch(selectedMonth, async (newVal) => {
  await fetchChart(newVal.start, newVal.end)
})

const fetchUsersLists = async () => {
  try {
    const response = await fetchData("GET", "/users")
    usersList.value = response.data
  } catch (err: any) {
    toast({
      variant: "destructive",
      description: "Error fetching data"
    })
  }
}

const fetchChart = async (id = chartId || authStore.userId) => {
  try {
    isLoading.value = true
    const response = await fetchData("GET", `/chartmanager/${id}`)
    if (response.status === 200) {
      workedDay.value = response.data.chart_1
      dayTime.value = response.data.chart_2
      nightTime.value = response.data.chart_3
      extraTime.value = response.data.chart_4
    }
  } catch (err: any) {
    error.value = err.message || "Error fetching data"
  } finally {
    isLoading.value = false
  }
}

// Watch selectedUser for changes and update route
watch(
  () => selectedUser.value,
  (newValue) => {
    const userId = usersList.value.find((user) => user.username === newValue)?.id
    if (userId !== undefined) {
      router.push(`/charts/${userId}`)
    }
    fetchChart(userId)
  },
  { immediate: true }
)

onMounted(async () => {
  await fetchChart()
  if (!isEmployee) await fetchUsersLists()
})
</script>

<template>
  <div class="flex flex-col h-[calc(100vh-80px)] p-4">
    <p v-if="isLoading">Loading...</p>
    <div v-if="!isLoading" class="flex flex-col h-full gap-4">
      <div class="flex gap-2">
        <div class="flex items-center gap-2">
          <Label>Choose a month: </Label>
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
        <div v-if="!isEmployee" class="flex items-center gap-2">
          <Label> User: </Label>
          <Popover v-model:open="open">
            <PopoverTrigger as-child>
              <Button
                variant="outline"
                role="combobox"
                :aria-expanded="open"
                class="w-[200px] justify-between font-normal"
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
      </div>
      <div class="flex flex-grow h-1/2 w-full gap-8 p-8 pl-0">
        <div class="flex flex-col border rounded-md p-8 text-background bg-[#9c4ff5] w-96 gap-12">
          <div class="flex flex-col gap-2">
            <Label class="text-2xl">Days Worked</Label>
            <p class="text-xl pl-4">{{ daysWorked }} days</p>
          </div>
          <div class="flex flex-col gap-2">
            <Label class="text-2xl">Total Hours</Label>
            <p class="text-xl pl-4">{{ totalHoursWorked }} hours</p>
          </div>
          <div class="flex flex-col gap-2">
            <Label class="text-2xl">Total Extra Hours</Label>
            <p class="text-xl pl-4">{{ totalExtraHours }} hours</p>
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
