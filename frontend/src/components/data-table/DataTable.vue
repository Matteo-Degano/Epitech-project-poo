<script setup lang="ts" generic="TData, TValue">
import type { ColumnDef, ColumnFiltersState, Updater, SortingState } from "@tanstack/vue-table"
import { ref, type Ref } from "vue"
import { Input } from "@/components/ui/input"
import DataTablePagination from "@/components/data-table/DataTablePagination.vue"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from "@/components/ui/table"

import {
  FlexRender,
  getCoreRowModel,
  useVueTable,
  getFilteredRowModel,
  getPaginationRowModel,
  getSortedRowModel
} from "@tanstack/vue-table"

function valueUpdater<T extends Updater<any>>(updaterOrValue: T, ref: Ref) {
  ref.value = typeof updaterOrValue === "function" ? updaterOrValue(ref.value) : updaterOrValue
}

const props = defineProps<{
  columns: ColumnDef<TData, TValue>[]
  data: TData[]
  filters: { column: string; fieldName: string }[]
}>()

const columnFilters = ref<ColumnFiltersState>([])
const sorting = ref<SortingState>([])

const table = useVueTable({
  get data() {
    return props.data
  },
  get columns() {
    return props.columns
  },
  getCoreRowModel: getCoreRowModel(),
  getPaginationRowModel: getPaginationRowModel(),
  onColumnFiltersChange: (updaterOrValue) => valueUpdater(updaterOrValue, columnFilters),
  getFilteredRowModel: getFilteredRowModel(),
  getSortedRowModel: getSortedRowModel(),
  onSortingChange: (updaterOrValue) => valueUpdater(updaterOrValue, sorting),
  state: {
    get columnFilters() {
      return columnFilters.value
    },
    get sorting() {
      return sorting.value
    }
  }
})
</script>

<template>
  <div class="flex items-center space-x-4">
    <Input
      v-for="filter in filters"
      class="max-w-sm"
      :placeholder="`Filter by ${filter.fieldName}...`"
      :model-value="table.getColumn(filter.column)?.getFilterValue() as string"
      @update:model-value="table.getColumn(filter.column)?.setFilterValue($event)"
    />
  </div>

  <div class="border rounded-md">
    <Table>
      <TableHeader>
        <TableRow v-for="headerGroup in table.getHeaderGroups()" :key="headerGroup.id">
          <TableHead v-for="header in headerGroup.headers" :key="header.id">
            <FlexRender
              v-if="!header.isPlaceholder"
              :render="header.column.columnDef.header"
              :props="header.getContext()"
            />
          </TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <template v-if="table.getRowModel().rows?.length">
          <TableRow
            v-for="row in table.getRowModel().rows"
            :key="row.id"
            :data-state="row.getIsSelected() ? 'selected' : undefined"
          >
            <TableCell v-for="cell in row.getVisibleCells()" :key="cell.id">
              <FlexRender :render="cell.column.columnDef.cell" :props="cell.getContext()" />
            </TableCell>
          </TableRow>
        </template>
        <template v-else>
          <TableRow>
            <TableCell :colspan="columns.length" class="h-24 text-center"> No results. </TableCell>
          </TableRow>
        </template>
      </TableBody>
    </Table>
  </div>
  <DataTablePagination :table="table" />
</template>
