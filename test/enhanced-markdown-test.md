---
title: Enhanced Markdown Test
description: Testing all the new features implemented in markdown.js
tags: [test, markdown, features]
---

# Enhanced Markdown Features Test

This document tests all the newly implemented features in our markdown.js implementation.

## GitHub Alerts

> [!NOTE]
> This is a note alert using the new GitHub Alerts plugin.

> [!TIP]
> This is a tip alert with helpful information.

> [!IMPORTANT]
> This is an important alert that should be noticed.

> [!WARNING]
> This is a warning alert about potential issues.

> [!CAUTION]
> This is a caution alert for dangerous operations.

## Math Support

Inline math: $E = mc^2$

Block math:

$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$

## Vue Integration

Here's a Vue component with enhanced attributes:

<script setup lang="ts">
import { ref } from 'vue'

const count = ref(0)
const message = ref('Hello from Vue!')

function increment() {
  count.value++
}
</script>

<template>
  <div class="vue-component">
    <h3>{{ message }}</h3>
    <button @click="increment" v-if="count < 10">
      Count: {{ count }}
    </button>
    <p v-show="count >= 10">Maximum count reached!</p>
  </div>
</template>

<style scoped>
.vue-component {
  padding: 1rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  margin: 1rem 0;
}

button {
  background: #007acc;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background: #005a9e;
}
</style>

## Image and Link Processing

Here's an image with lazy loading:
![Factorio Logo](https://www.factorio.com/assets/img/logo.png)

External link with proper attributes: [Factorio Official Site](https://www.factorio.com)

Internal link: [Back to top](#enhanced-markdown-features-test)

## CJK Support

This text should work well with CJK languages:

**日本語の太字** - Japanese bold text
**中文粗体** - Chinese bold text  
**한국어 굵은 글씨** - Korean bold text

## Code Highlighting

```lua
-- Factorio modding example
local function create_entity(name, position)
    local entity = game.surfaces[1].create_entity{
        name = name,
        position = position
    }
    return entity
end
```

```javascript
// JavaScript example
function calculateThroughput(items, time) {
  return items / time
}

const result = calculateThroughput(1000, 60)
console.log(`Throughput: ${result} items/second`)
```

## Custom Containers

::: tip Custom Tip
This is a custom tip container with enhanced styling.
:::

::: warning Custom Warning
This is a custom warning container.
:::

::: danger Custom Danger
This is a custom danger container.
:::

::: details Custom Details
This is a collapsible details container with custom content.
:::

## Task Lists

- [x] Implement GitHub Alerts
- [x] Add MathJax3 support
- [x] Enhance Vue integration
- [x] Add image/link processing
- [x] Implement CJK support
- [x] Add performance optimizations
- [ ] Test all features
- [ ] Update documentation

## Performance Features

The implementation now includes:

- LRU cache for compiled results
- Enhanced error handling
- Optimized Vue component processing
- Responsive image handling
- External link security

## Conclusion

All major features have been implemented and should be working correctly. The markdown.js implementation now has significantly improved functionality and performance.
