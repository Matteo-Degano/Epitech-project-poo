<script setup lang="ts">
import { h, ref } from "vue"
import { type ColumnDef } from "@tanstack/vue-table"
import { fetchData } from "@/services/api"
import DataTable from "@/components/data-table/DataTable.vue"
import { formatDateTime } from "@/utils/dateFormat"
import type { WorkingTimeType } from "@/types/api.type"
import { useAuthStore } from "@/stores/auth.store"

const useAuth = useAuthStore()
const workingTimeData = ref<WorkingTimeType[]>([])

const props = defineProps({
    data: Array,
})

const fetchWorkingTimes = async () => {
    try {
        const response = await fetchData("GET", `/workingtime/${useAuth.user.id}?start=${props.startTime}&end=${props.endTime}`)
        workingTimeData.value = response.data
    } catch (err: any) {
        console.log(err)
    }
}

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
        <div class="flex flex-col gap-1 w-full">
            <h2 class="font-bold">Latest working times</h2>
            <DataTable
            @refresh="fetchWorkingTimes"
            :columns="columns"
            :data="props.data"
            :filters="[]"
            />
        </div>
    </div>
</template>
