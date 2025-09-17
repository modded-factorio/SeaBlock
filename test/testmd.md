::: warning
wibble
:::

## This editor took more time than the rest of the project :tada: :100:

::: details
asfsdfdsf
:::

| Tables        |      Are      |  Cool |
| ------------- | :-----------: | ----: |
| col 3 is      | right-aligned | $1600 |
| col 2 is      |   centered    |   $12 |
| zebra stripes |   are neat    |    $1 |

Includes work but not here

<!--@include: .{3,}-->

# ⚙️ Factorio Recipe Demo

<div class="p-4 rounded-xl bg-gray-100 border">
  <h3>🔧 Crafting: Electronic Circuits</h3>
  
  <p>Adjust ingredient counts:</p>
  <label>
    Iron Plates: 
    <input type="number" v-model="ironPlates" min="0" class="border rounded px-2 w-20">
  </label>
  <label>
    Copper Plates: 
    <input type="number" v-model="copperPlates" min="0" class="border rounded px-2 w-20">
  </label>

  <p class="mt-3 font-bold">
    ✅ Circuits craftable: <input :value="circuits" />
  </p>
</div>

<script setup>
import { ref, computed } from 'vue'

const ironPlates = ref(2)
const copperPlates = ref(3)

const circuits = computed(() => {
  // Example: 2 iron + 3 copper = 1 circuit
  const sets = Math.min(
    Math.floor(ironPlates.value / 2),
    Math.floor(copperPlates.value / 3)
  )
  return sets
})
</script>

<div class="notice">
  <strong>Heads up:</strong> raw HTML is allowed.
</div>
<svg width="20" height="20" fill="currentColor">
  <circle cx="10" cy="10" r="8" />
</svg> Inline SVG works!
Even youtube!
<iframe width="560" height="315"
  src="https://www.youtube.com/embed/dQw4w9WgXcQ"
  frameborder="0" allowfullscreen>
</iframe>
