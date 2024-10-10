<script setup lang="ts">
import { computed } from 'vue';

// Define the userId prop
const props = defineProps<{
  userId?: number;
}>();

// Chart options
const options = {
  chart: {
    id: 'working-times',
  },
  xaxis: {
    categories: ["1/01", "2/01", "3/01", "4/01", "5/01"]
  }
};

// Use a computed property to update the series dynamically
const series = computed(() => [{
  name: props.userId || 'default user',
  data: [7.30, 7.30, 7, 8, 6]
}]);

</script>

<template>
  <div class="flex flex-col gap-6 p-6">
    <div class="flex flex-col">
      <h2>Working Times</h2>
      <p>User ID: {{ userId }}</p>
    </div>
    <div class="w-3/4 mx-auto">
      <apexchart width="100%" type="bar" :options="options" :series="series"></apexchart>
    </div>
  </div>
</template>