<script setup lang="ts">
import { h, ref, onMounted, computed } from "vue"
import { type ColumnDef } from "@tanstack/vue-table"
import { ArrowUpDown } from "lucide-vue-next"
import { Button } from "@/components/ui/button"
import { fetchData } from "@/services/api"
import WorkingTime from "./WorkingTime.vue"
import DeleteWorkingTimeModal from "./DeleteWorkingTimeModal.vue"
import DataTable from "@/components/data-table/DataTable.vue"
import { useToast } from "../ui/toast/use-toast"
import { formatDateTime } from "@/utils/dateFormat"
import type { WorkingTimeType } from "@/types/api.type"
import { useAuthStore } from "@/stores/auth.store"
import { useRoute } from "vue-router"

const route = useRoute()
const { toast } = useToast()
const useAuth = useAuthStore()
const workingTimeData = ref<WorkingTimeType[]>([])
const isLoading = ref(true)
const isEmployee: boolean = useAuth.isEmployee

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
    console.log(workingTimeData)
    if (isEmployee) {
      workingTimeData.value = workingTimeData.value.map((entry) => ({
        ...entry,
        user: {
          ...entry.user,
          username: "me"
        }
      }))
    }
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

// Define the columns using a computed property
const columns = computed<ColumnDef<WorkingTimeType>[]>(() => {
  const baseColumns: ColumnDef<WorkingTimeType>[] = [
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

  if (!isEmployee) {
    baseColumns.unshift({
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
    })

    baseColumns.push({
      id: "actions",
      cell: ({ row }) => {
        return h("div", { class: "flex gap-4 float-right" }, [
          h(WorkingTime, { mode: "update", data: row.original, id: row.original.id }),
          h(DeleteWorkingTimeModal, { id: row.original.id, function: deleteWorkingTime })
        ])
      }
    })
  }

  return baseColumns
})

const filterColumns = [
  ...(!isEmployee ? [{ column: "user.username", fieldName: "User" }] : []),
  { column: "start", fieldName: "Start" },
  { column: "end", fieldName: "End" }
]
</script>

<template>
  <div class="flex flex-col gap-2 w-full">
    <div v-if="isLoading" class="flex justify-center items-center h-full">
      <p>Loading...</p>
    </div>
    <DataTable
      v-else
      @refresh="fetchWorkingTimes"
      :columns="columns"
      :data="route.path === '/working-times' ? workingTimeData : workingTimeData.slice(0, 5)"
      :filters="filterColumns"
    />
  </div>
</template>
