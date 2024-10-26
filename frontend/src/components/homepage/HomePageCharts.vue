<script setup lang="ts">
import DayWorkedChart from "@/components/charts/DayWorkedChart.vue"
import HoursWorkedChart from "@/components/charts/HoursWorkedChart.vue"
import { fetchData } from "@/services/api"
import { useAuthStore } from "@/stores/auth.store"
import { onMounted, ref, computed, watch } from "vue"
import { useRoute, useRouter } from "vue-router"
import { useToast } from "@/components/ui/toast/use-toast"

const authStore = useAuthStore()
const { toast } = useToast()
const route = useRoute()
const chartId = Number(route.params.id)
const workedDay = ref(null)
const dayTime = ref(null)
const isLoading = ref(true)
const error = ref(null)

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

const fetchChart = async (
start = selectedMonth.value.start,
end = selectedMonth.value.end,
id = chartId || authStore.userId
) => {
    try {
        isLoading.value = true
        const response = await fetchData("GET", `/chartmanager/${id}?start=${start}&end=${end}`)
        if (response.status === 200) {
            workedDay.value = response.data.chart_1
            dayTime.value = response.data.chart_2
        }
    } catch (err) {
        error.value = err.message || "Error fetching data"
        toast({ variant: "destructive", description: error.value })
    } finally {
        isLoading.value = false
    }
}

onMounted(async () => {
    await fetchChart(selectedMonth.value.start, selectedMonth.value.end)
})

</script>

<template>
    <p v-if="isLoading">Loading...</p>
    <div v-else>
        <h2>This month data</h2>
        <div class="flex h-64 g-3 p-4 justify-around w-full">
            <HoursWorkedChart v-if="dayTime" :data="dayTime" class="w-full" />
            <DayWorkedChart v-if="workedDay" :data="workedDay" class="w-96" />
        </div>
    </div>
</template>
