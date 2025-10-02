<template>
  <div v-if="shouldShow" :class="$style.entitySection">
    <slot />
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  name: { type: String, default: null },
  type: { type: String, default: null },
  variant: { type: String, default: 'default' }
})

const shouldShow = computed(() => {
  return props.name && props.type
})
</script>

<style module>
.entitySection {
  margin-bottom: 12px;
}
</style>
