<script setup lang="ts">
import { h, ref, onMounted} from "vue"
import { type ColumnDef } from "@tanstack/vue-table"
import { Button } from "@/components/ui/button"
import { fetchData } from "@/services/api"
import DataTable from "@/components/data-table/DataTable.vue"
import { formatDateTime } from "@/utils/dateFormat"
import type { WorkingTimeType } from "@/types/api.type"
import { useAuthStore } from "@/stores/auth.store"
import { useRoute } from "vue-router"

const useAuth = useAuthStore()
const workingTimeData = ref<WorkingTimeType[]>([])
const isLoading = ref(true)
const route = useRoute()
const isActive = (path: string) => route.path === path

const props = defineProps({
  startTime: Date,
  endTime: Date
})

const fetchWorkingTimes = async () => {
    try {
        const response = await fetchData("GET", `/workingtime/${useAuth.user.id}?start=${props.startTime}&end=${props.endTime}`)
        console.log(response.data)
        workingTimeData.value = response.data
    } catch (err: any) {
        console.log(err)
    }
}

onMounted(async () => {
    await fetchWorkingTimes()
    isLoading.value = false
})

const columns: ColumnDef<WorkingTimeType>[] = [
    {
        accessorKey: "start",
        header: () => h('div', { class: 'ml-4' }, 'Start Date & Time'),
        cell: ({ row }) =>
        h("div", { class: "text-left font-medium" }, formatDateTime(row.getValue("start")))
    },
    {
        accessorKey: "end",
        header: () => h('div', { class: 'ml-4' }, 'End Date & Time'),
        cell: ({ row }) =>
        h("div", { class: "text-left font-medium" }, formatDateTime(row.getValue("end")))
    }
    ]
    
</script>

<template>
    <div class="flex flex-col gap-2 w-full">
        <div v-if="isLoading" class="flex justify-center items-center h-full">
            <p>Loading...</p>
        </div>
        <div v-else class="flex flex-col gap-1 w-full">
            <h2 class="font-bold">Latest working times</h2>
            <DataTable
            @refresh="fetchWorkingTimes"
            :columns="columns"
            :data="workingTimeData.slice(-5)"
            :filters="[]"
            />
            <router-link to="/working-times" :class="[{ 'text-primary': isActive('/working-times')}, , 'self-end']">
                <Button >View all</Button>
            </router-link>
        </div>
    </div>
</template>
