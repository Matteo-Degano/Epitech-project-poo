<script setup lang="ts">
import HoursWorkedChart from "@/components/charts/HoursWorkedChart.vue"
import { fetchData } from "@/services/api"
import { useAuthStore } from "@/stores/auth.store"
import { onMounted, ref, computed, watch } from "vue"
import { useToast } from "@/components/ui/toast/use-toast"

const authStore = useAuthStore()
const { toast } = useToast()
const dayTime = ref(null)
const isLoading = ref(true)
const error = ref(null)

const props = defineProps({
    startTime: Date,
    endTime: Date
})

const fetchChart = async () => {
    try {
        isLoading.value = true
        const response = await fetchData("GET", `/chartmanager/${authStore.userId}?start=${props.startTime}&end=${props.endTime}`)
        if (response.status === 200) {
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
    await fetchChart()
})

</script>

<template>
    <p v-if="isLoading">Loading...</p>
    <div v-else>
        <HoursWorkedChart v-if="dayTime" :data="dayTime" class="w-full h-60" />
    </div>
</template>
