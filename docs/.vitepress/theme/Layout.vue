<template>
  <div class="layout">
    <!-- Use the default VitePress layout -->
    <DefaultLayout>
      <template #layout-bottom>
        <!-- Editor Widget -->
        <EditorWidget
          ref="editorWidget"
          :initial-content="currentPageMarkdown"
        />

        <!-- Floating Editor Button -->
        <button
          class="editor-toggle-btn"
          title="Open WYSIWYG Editor (Ctrl+E)"
          @click="openEditor"
        >
          ✏️
        </button>
      </template>
    </DefaultLayout>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useData } from 'vitepress'
import DefaultLayout from 'vitepress/dist/client/theme-default/Layout.vue'

import EditorWidget from './components/EditorWidget.vue'

const editorWidget = ref(null)
const { frontmatter } = useData()

// Get the current page markdown content from the injected data
const currentPageMarkdown = computed(() => {
  // Get from base64 encoded content
  if (frontmatter.value.__encodedMarkdown) {
    try {
      // Decode using the exact reverse of the encoding method (Node.js Buffer.from(string, 'utf-8').toString('base64'))
      // Browser equivalent: atob() then convert binary string to UTF-8
      const binaryString = atob(frontmatter.value.__encodedMarkdown)
      const bytes = new Uint8Array(binaryString.length)
      for (let i = 0; i < binaryString.length; i++) {
        bytes[i] = binaryString.charCodeAt(i)
      }
      return new TextDecoder('utf-8').decode(bytes)
    } catch (error) {
      console.warn('Failed to decode markdown content:', error)
      return ''
    }
  }
  return ''
})

// Get editor metadata for debugging and status
const editorMetadata = computed(() => {
  return (
    frontmatter.value.__editorData || {
      hasContent: false,
      contentLength: 0,
      hasFrontmatter: false,
      lastModified: null,
      pagePath: 'unknown'
    }
  )
})

const openEditor = () => {
  if (editorWidget.value) {
    editorWidget.value.open()
  }
}

// Log the available markdown content and metadata for debugging
onMounted(() => {
  console.log('📄 Page Markdown Data:')
  console.log('  - Content available:', !!currentPageMarkdown.value)
  console.log('  - Content length:', currentPageMarkdown.value.length)
  console.log('  - Editor metadata:', editorMetadata.value)

  if (currentPageMarkdown.value) {
    console.log('  - Content preview:', `${currentPageMarkdown.value.substring(0, 100)  }...`)
    console.log('  - Has frontmatter:', editorMetadata.value.hasFrontmatter)
    console.log('  - Page path:', editorMetadata.value.pagePath)
  }

  // Log available frontmatter keys for debugging
  const frontmatterKeys = Object.keys(frontmatter.value).filter(key => key.startsWith('__'))
  console.log('  - Injected frontmatter keys:', frontmatterKeys)
})
</script>

<style>
.layout {
  position: relative;
}

.editor-toggle-btn {
  position: fixed;
  bottom: 2rem;
  right: 2rem;
  width: 3rem;
  height: 3rem;
  border-radius: 50%;
  background: #3b82f6;
  color: white;
  border: none;
  cursor: pointer;
  font-size: 1.25rem;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);
  transition: all 0.3s ease;
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
}

.editor-toggle-btn:hover {
  background: #2563eb;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(59, 130, 246, 0.6);
}

.editor-toggle-btn:active {
  transform: translateY(0);
}

/* Dark theme support */
:global(.dark) .editor-toggle-btn {
  background: #1f2937;
  border: 1px solid #374151;
}

:global(.dark) .editor-toggle-btn:hover {
  background: #374151;
}
</style>
