<script setup lang="ts">
import { computed, ref, watch } from "vue"
import { fetchData } from "@/services/api"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from "@/components/ui/dialog"
import { DateFormatter, getLocalTimeZone, CalendarDate } from "@internationalized/date"
import { Calendar } from "@/components/ui/calendar"
import { Popover, PopoverTrigger, PopoverContent } from "@/components/ui/popover"

// Props for mode and data
const props = defineProps({
  mode: String, // 'create' or 'update'
  data: Object // Working time data when updating
})

const emit = defineEmits(["close"])

// Modal visibility state
const isModalOpen = ref(false)

// Reactive state for date and time range
function getInitialDate() {
  const date = props.data?.start.split('T')[0];
  if (date) {
    let [year, month, day] = date.split('-');
    return new CalendarDate('AD', year, month, day);
  }
}

const selectedDate = ref(getInitialDate() || null) // Date picker state
const timeRange = ref({
  start: props.data?.start.split('T')[1].split('.')[0] || "",
  end: props.data?.end.split('T')[1].split('.')[0] || ""
})

// DateFormatter to format the selected date
const df = new DateFormatter("en-US", {
  dateStyle: "long"
})

// Watch for changes in props to update date and timeRange values
watch(
  () => props.data,
  (newValue) => {
    if (newValue) {
      timeRange.value.start = newValue.start
      timeRange.value.end = newValue.end
    }
  }
)

const isSaveDisabled = computed(() => {
  return !selectedDate.value || !timeRange.value.start || !timeRange.value.end;
});

function clearInputs() {
  selectedDate.value = null;
  timeRange.value.start = "";
  timeRange.value.end = "";
}

// Function to handle the submission (create or update)
async function submitWorkingTime() {
  const requestData = {
    start: `${selectedDate.value ? (selectedDate.value.toDate()).toISOString().split('T')[0] : null}T${timeRange.value.start}:00Z`,
    end: `${selectedDate.value ? (selectedDate.value.toDate()).toISOString().split('T')[0] : null}T${timeRange.value.end}:00Z` 
  }

  if (props.mode === "create") {
    // POST request for creating a new working time
    await fetchData("POST", `/workingtime/1`, requestData)
  } else {
    // PUT request for updating an existing working time
    await fetchData("PUT", `/workingtime/${props.data.id}`, requestData)
  }

  clearInputs()
  // Emit close event and close modal
  emit("close")
  isModalOpen.value = false
}
</script>

<template>
  <Dialog>
    <DialogTrigger as-child>
      <!-- Trigger button text changes based on mode -->
      <Button variant="outline">
        {{ props.mode === "create" ? "Create Working Time" : "Update Working Time" }}
      </Button>
    </DialogTrigger>
    <DialogContent class="sm:max-w-md">
      <DialogHeader>
        <DialogTitle>{{
          props.mode === "create" ? "Create Working Time" : "Update Working Time"
        }}</DialogTitle>
      </DialogHeader>
      <div class="flex flex-col gap-4">
        <!-- Date Picker -->
        <Popover>
          <PopoverTrigger as-child>
            <Button variant="outline" class="w-[280px] justify-start text-left font-normal">
              {{
                selectedDate ? df.format(selectedDate.toDate(getLocalTimeZone())) : "Pick a date"
              }}
            </Button>
          </PopoverTrigger>
          <PopoverContent class="w-auto p-0">
            <Calendar v-model="selectedDate" initial-focus />
          </PopoverContent>
        </Popover>

        <!-- Time Inputs -->
        <div class="flex items-center gap-2">
          <p>Start:</p>
          <input
            type="time"
            v-model="timeRange.start"
            class="p-1 border border-gray-300 rounded-md h-full cursor-pointer"
          />
          <p>End:</p>
          <input
            type="time"
            v-model="timeRange.end"
            class="p-1 border border-gray-300 rounded-md h-full cursor-pointer"
          />
        </div>
      </div>

      <!-- Dialog footer with save and close buttons -->
      <DialogFooter class="sm:justify-start">
        <DialogClose as-child>
          <Button type="button" variant="outline" @click="submitWorkingTime" :disabled="isSaveDisabled"> Save </Button>
        </DialogClose>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
