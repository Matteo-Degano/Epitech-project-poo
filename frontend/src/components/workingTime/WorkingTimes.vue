<script setup lang="ts">
import { h, ref, reactive } from "vue"
import {
  createColumnHelper,
  getCoreRowModel,
  useVueTable,
  getSortedRowModel
} from "@tanstack/vue-table"
import { Button } from "@/components/ui/button"
import { fetchData } from "@/services/api"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from "@/components/ui/table"
import WorkingTime from "./WorkingTime.vue"

// Define the structure of your working time
type WorkingTimeType = {
  id: number
  start: string
  end: string
  user_id: number
}

// Sample data
const data: WorkingTimeType[] = reactive([
  {
    id: 27,
    start: "2024-10-11T09:30:00",
    end: "2024-10-11T17:30:00",
    user_id: 1
  },
  {
    id: 28,
    start: "2024-10-11T09:30:00",
    end: "2024-10-11T17:30:00",
    user_id: 2
  }
])

const columnHelper = createColumnHelper<WorkingTimeType>()

// Define the columns
const columns = [
  columnHelper.accessor("user_id", {
    header: "User ID",
    cell: (info) => info.getValue()
  }),
  columnHelper.accessor("start", {
    header: "Start Time",
    cell: (info) =>
      new Date(info.getValue()).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })
  }),
  columnHelper.accessor("end", {
    header: "End Time",
    cell: (info) =>
      new Date(info.getValue()).toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })
  }),
  columnHelper.display({
    id: "actions",
    cell: ({ row }) => {
      return h("div", { class: "flex gap-2" }, [
        h(Button, { variant: "outline", size: "sm" }, "Update"),
        h(
          Button,
          { variant: "destructive", size: "sm", onClick: () => deleteWorkingTime(row.original.id) },
          "Delete"
        )
      ])
    }
  })
]

// Set up the table instance
const sorting = ref([])
const table = useVueTable({
  data,
  columns,
  getCoreRowModel: getCoreRowModel(),
  getSortedRowModel: getSortedRowModel(),
  state: {
    sorting
  }
})

// Function to handle working time deletion
async function deleteWorkingTime(id: number) {
  try {
    const response = await fetchData("DELETE", `/workingtime/${id}`)
    if (response.status === 200) {
      console.log("Working time deleted successfully")
      const index = data.findIndex((item) => item.id === id)
      if (index !== -1) data.splice(index, 1)
    } else {
      console.error("Failed to delete working time")
    }
  } catch (error) {
    console.error("Error deleting working time", error)
  }
}
</script>

<template>
  <div class="w-full">
    <!-- Add Create button at the top -->
    <div class="flex justify-end mb-4">
      <WorkingTime :mode="'create'" :data="null" />
    </div>

    <!-- Table to display the working times -->
    <div class="w-full overflow-auto">
      <div class="rounded-md border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>ID</TableHead>
              <TableHead>Date</TableHead>
              <TableHead>Start Time</TableHead>
              <TableHead>End Time</TableHead>
              <TableHead>Actions</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            <TableRow v-for="row in table.getRowModel().rows" :key="row.id">
              <TableCell>{{ row.original.id }}</TableCell>
              <TableCell>{{ new Date(row.original.start).toLocaleDateString() }}</TableCell>
              <TableCell>{{
                new Date(row.original.start).toLocaleTimeString([], {
                  hour: "2-digit",
                  minute: "2-digit"
                })
              }}</TableCell>
              <TableCell>{{
                new Date(row.original.end).toLocaleTimeString([], {
                  hour: "2-digit",
                  minute: "2-digit"
                })
              }}</TableCell>
              <TableCell class="flex gap-2">
                <WorkingTime :mode="'update'" :data="row.original" />
                <Button @click="deleteWorkingTime(row.original.id)" variant="destructive" size="sm"
                  >Delete</Button
                >
              </TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </div>
    </div>
  </div>
</template>
