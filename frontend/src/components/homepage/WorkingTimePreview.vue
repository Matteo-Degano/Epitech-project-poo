<script setup lang="ts">
import { h, ref, onMounted} from "vue"
import { type ColumnDef } from "@tanstack/vue-table"
import { ArrowUpDown } from "lucide-vue-next"
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


const fetchWorkingTimes = async () => {
    try {
        const response = await fetchData("GET", `/workingtime`)
        workingTimeData.value = response.data
        workingTimeData.value = workingTimeData.value.filter(entry => entry.user.id === useAuth.user.id).sort()
        console.log(workingTimeData.value)
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
        header: ({ column }) => {
            return h(
            Button,
            {
                variant: "ghost",
                onClick: () => column.toggleSorting(column.getIsSorted() === "asc")
            },
            () => ["Start Date & Time", h(ArrowUpDown, { class: "ml-2 h-4 w-4" })]
            )
        },
        cell: ({ row }) =>
        h("div", { class: "text-left font-medium" }, formatDateTime(row.getValue("start")))
    },
    {
        accessorKey: "end",
        header: ({ column }) => {
            return h(
            Button,
            {
                variant: "ghost",
                onClick: () => column.toggleSorting(column.getIsSorted() === "asc")
            },
            () => ["End Date & Time", h(ArrowUpDown, { class: `ml-2 h-4 w-4 ` })]
            )
        },
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
        <div v-else>
            <h2>Latest working times</h2>
            <DataTable
            @refresh="fetchWorkingTimes"
            :columns="columns"
            :data="workingTimeData.slice(-5)"
            :filters="[]"
            />
            <router-link to="/working-times" :class="[{ 'text-primary': isActive('/working-times') }]">
                <p class="text-right text-primary">View more...</p>
            </router-link>
        </div>
    </div>
</template>
