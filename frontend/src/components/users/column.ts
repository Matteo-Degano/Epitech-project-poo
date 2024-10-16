import type { User } from '@/types/api.type'
import type { ColumnDef } from '@tanstack/vue-table'
import { h } from 'vue'

export const columns: ColumnDef<User>[] = [
  {
    accessorKey: 'name',
    header: () => h('div', { class: 'text-right' }, 'Name'),
    cell: ({ row }) => {
      const name = row.getValue('name')

      return h('div', { class: 'text-right font-medium' }, name)
    },
  }
]