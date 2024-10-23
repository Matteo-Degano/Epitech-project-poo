<script setup lang="ts">
import { h, ref, onMounted } from "vue"
import { type ColumnDef } from "@tanstack/vue-table"
import { ArrowUpDown } from "lucide-vue-next"
import { Button } from "@/components/ui/button"
import { fetchData } from "@/services/api"
import WorkingTime from "./WorkingTime.vue"
import DeleteWorkingTimeModal from "./DeleteWorkingTimeModal.vue"
import DataTable from "@/components/data-table/DataTable.vue"
import { useToast } from "../ui/toast/use-toast"
import { formatDateTime } from "@/utils/dateFormat"
import type { WorkingTimeType, User } from "@/types/api.type"

const { toast } = useToast()
const workingTimeData = ref<WorkingTimeType[]>([])
const userList = ref<User[]>([])
const isLoading = ref(true)

// Function to handle working time deletion
async function deleteWorkingTime(id: number) {
  try {
    const response = await fetchData("DELETE", `/workingtime/${id}`)
    if (response.status === 204) {
      fetchWorkingTimes()
      toast({
        description: "Working time deleted successfully"
      })
    } else {
      toast({
        variant: "destructive",
        description: "Failed to delete working time"
      })
    }
  } catch (error) {
    toast({
      variant: "destructive",
      description: "Error deleting working time: " + error
    })
  }
}

// Function to fetch working times
const fetchWorkingTimes = async () => {
  try {
    const response = await fetchData("GET", `/workingtime`)
    workingTimeData.value = response.data
  } catch (err: any) {
    toast({
      variant: "destructive",
      description: "Error fetching data"
    })
  }
}

onMounted(async () => {
  await fetchWorkingTimes()
  isLoading.value = false
})

// Define the columns
const columns: ColumnDef<WorkingTimeType>[] = [
  {
    accessorFn: (row) => row.user.username,
    id: "user.username",
    header: ({ column }) => {
      return h(
        Button,
        {
          variant: "ghost",
          onClick: () => column.toggleSorting(column.getIsSorted() === "asc")
        },
        () => ["User", h(ArrowUpDown, { class: "ml-2 h-4 w-4" })]
      )
    },
    cell: ({ row }) =>
      h("div", { class: "text-left font-medium capitalize" }, row.getValue("user.username"))
  },
  {
    accessorKey: "start",
    header: () => h("div", { class: "text-left" }, "Start Date & Time"),
    cell: ({ row }) =>
      h("div", { class: "text-left font-medium" }, formatDateTime(row.getValue("start")))
  },
  {
    accessorKey: "end",
    header: () => h("div", { class: "text-left" }, "End Date & Time"),
    cell: ({ row }) =>
      h("div", { class: "text-left font-medium" }, formatDateTime(row.getValue("end")))
  },
  {
    id: "actions",
    enableHiding: false,
    cell: ({ row }) => {
      return h("div", { class: "flex gap-4 float-right" }, [
        h(WorkingTime, { mode: "update", data: row.original, id: row.original.id }),
        h(DeleteWorkingTimeModal, { id: row.original.id, function: deleteWorkingTime })
      ])
    }
  }
]
const filterColumns = [
  { column: "user.username", fieldName: "User" },
  { column: "start", fieldName: "Start Date & Time" },
  { column: "end", fieldName: "End Date & Time" }
]
</script>

<template>
  <div class="flex flex-col gap-2 w-full">
    <div class="flex justify-end">
      <WorkingTime
        :mode="'create'"
        :workingTimeData="workingTimeData"
        @refresh="fetchWorkingTimes"
      />
    </div>
    <div v-if="isLoading" class="flex justify-center items-center h-full">
      <p>Loading...</p>
    </div>
    <DataTable v-else :columns="columns" :data="workingTimeData" :filters="filterColumns" />
  </div>
</template>
