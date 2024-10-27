<script setup lang="ts">
import { h, onMounted, ref } from 'vue';
import type { Team } from "@/types/api.type"
import { fetchData } from '@/services/api';
import type { ColumnDef } from "@tanstack/vue-table"
import { Button } from '../ui/button';
import { ArrowUpDown } from 'lucide-vue-next';
import DataTable from "@/components/data-table/DataTable.vue"
import TeamModal from "@/components/teams/TeamsModal.vue"
import DeleteTeamModal from "@/components/teams/DeleteTeamModal.vue"

const isLoading = ref<boolean>(true)
const teamsData = ref<Team[]>([])

async function fetchTeams() {
  try {
    const response = await fetchData("GET", "/teams")
    teamsData.value = response.data.data
    console.log("Teams fetched successfully", teamsData.value)
  } catch (error) {
    console.log(error)
  } finally {
    isLoading.value = false
  }
}

onMounted(() => {
  fetchTeams()
})

const columns: ColumnDef<Team>[] = [
  {
    accessorKey: "id",
    header: ({ column }) => {
      return h(
      Button,
      {
        variant: "ghost",
        onClick: () => column.toggleSorting(column.getIsSorted() === "asc")
      },
      () => ["ID", h(ArrowUpDown, { class: "ml-2 h-4 w-4" })]
      )
    },
    cell: ({ row }) => h("div", { class: "text-left font-medium" }, row.getValue("id"))
  },
  {
    accessorKey: "name",
    header: ({ column }) => {
      return h(
      Button,
      {
        variant: "ghost",
        onClick: () => column.toggleSorting(column.getIsSorted() === "asc")
      },
      () => ["Name", h(ArrowUpDown, { class: "ml-2 h-4 w-4" })]
      )
    },
    cell: ({ row }) => h("div", { class: "text-left font-medium" }, row.getValue("name"))
  },
  {
    id: "actions",
    enableHiding: false,
    cell: ({ row }) => {
      return h("div", { class: "flex gap-4 float-right" }, [
      h(TeamModal, {
        mode: "update",
        data: row.original,
        onRefresh: fetchTeams
      }),
      h(DeleteTeamModal, { id: row.original.id, onRefresh: fetchTeams })
      ])
    }
  }
  ]
  
  const filterColumns = [
  { column: "id", fieldName: "ID" },
  { column: "name", fieldName: "Name" }
  ]
</script>

<template>
  <div class="flex flex-col gap-2 w-full">
    <div v-if="isLoading" class="flex justify-center items-center h-full">
      <Spinner/>
    </div>
    

    <DataTable v-else :columns="columns" :data="teamsData" :filters="filterColumns" @refresh="fetchTeams" />
</div>

</template>