<template>
  <div v-if="isVisible" class="editor-widget">
    <div class="editor-overlay" @click="closeEditor"></div>
    <div class="editor-container">
      <div class="editor-header">
        <h3>🚀 VitePress Browser Editor</h3>
        <div class="renderer-status">{{ rendererStatus }}</div>
        <button @click="closeEditor" class="close-btn">×</button>
      </div>

      <div class="editor-content">
        <div class="editor-pane">
          <div class="pane-header">Markdown Source</div>
          <textarea
            v-model="markdownContent"
            class="markdown-editor"
            placeholder="Enter your markdown content here..."
            @input="updatePreview"
          ></textarea>
        </div>

        <div class="splitter" @mousedown="startResize"></div>

        <div class="preview-pane">
          <div class="pane-header">
            VitePress Preview
            <span v-if="isProcessing" class="processing-indicator">⏳ Processing...</span>
          </div>
          <iframe
            ref="previewFrame"
            class="preview-frame"
            src="/SeaBlock/editor-iframe.html"
            sandbox="allow-scripts allow-same-origin allow-downloads"
            title="VitePress Preview"
            @load="onIframeLoad"
          ></iframe>
        </div>
      </div>

      <div class="editor-footer">
        <div class="editor-actions">
          <button @click="copyToGitHub" class="btn btn-primary">📋 Copy to GitHub</button>
          <button @click="toggleTheme" class="btn btn-secondary">
            {{ isDark ? '☀️ Light' : '🌙 Dark' }}
          </button>
          <button @click="updatePreview" class="btn btn-secondary">🔄 Update Preview</button>
          <button @click="fullscreenPreview" class="btn btn-secondary">
            {{ isFullscreen ? '📱 Exit Fullscreen' : '🔍 Fullscreen' }}
          </button>
        </div>
        <div class="editor-status">{{ markdownContent.length }} characters</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'

// Props
const props = defineProps({
  initialContent: {
    type: String,
    default: ''
  }
})

// Reactive state
const isVisible = ref(false)
const markdownContent = ref(props.initialContent)
const isDark = ref(false)
const isResizing = ref(false)
const previewFrame = ref(null)
const isProcessing = ref(false)
const rendererStatus = ref('Initializing...')
const iframeReady = ref(false)
const isFullscreen = ref(false)

// No legacy markdown processing - iframe handles all rendering

// Methods
const updatePreview = async () => {
  if (!previewFrame.value) return

  isProcessing.value = true
  rendererStatus.value = 'Processing...'

  try {
    // Send raw markdown content to iframe - let the iframe handle rendering
    rendererStatus.value = '🚀 Real VitePress Components'
    console.log('Sending raw markdown to iframe for processing')

    // Send raw markdown to iframe via postMessage
    const sendContentToIframe = () => {
      if (previewFrame.value?.contentWindow) {
        // Find the Vue bundle path from the current page's scripts
        const vueBundlePath = Array.from(document.scripts).find(
          script => script.src && script.src.includes('app.') && script.src.includes('.js')
        )?.src

        const message = {
          type: 'update-markdown',
          markdown: markdownContent.value,
          isDark: isDark.value,
          vueBundlePath: vueBundlePath
        }
        console.log('Sending raw markdown to iframe with Vue bundle path:', vueBundlePath)
        previewFrame.value.contentWindow.postMessage(message, '*')
      }
    }

    // Send immediately if iframe is ready, otherwise wait
    if (iframeReady.value) {
      sendContentToIframe()
    } else {
      console.log('Iframe not ready, waiting...')
      // Wait for iframe to be ready
      const checkReady = setInterval(() => {
        if (iframeReady.value) {
          clearInterval(checkReady)
          sendContentToIframe()
        }
      }, 50)

      // Timeout after 2 seconds
      setTimeout(() => {
        clearInterval(checkReady)
        if (!iframeReady.value) {
          console.warn('Iframe ready timeout, sending anyway')
          sendContentToIframe()
        }
      }, 2000)
    }
  } catch (error) {
    console.error('Error updating preview:', error)
    rendererStatus.value = '❌ Error'
    // Send error message to iframe via postMessage
    if (previewFrame.value?.contentWindow) {
      previewFrame.value.contentWindow.postMessage(
        {
          type: 'update-markdown',
          markdown: `# Error\n\nError rendering preview: ${error.message}`,
          isDark: isDark.value
        },
        '*'
      )
    }
  } finally {
    isProcessing.value = false
  }
}

const onIframeLoad = () => {
  console.log('Iframe loaded event fired')
  // The iframe-ready message handler will trigger initial rendering
  // This is just for logging purposes
}

const copyToGitHub = () => {
  let pagePath = window.location.pathname
  // Remove base if present
  const base = '/SeaBlock/'
  if (pagePath.startsWith(base)) pagePath = pagePath.slice(base.length)
  // Remove leading slash
  if (pagePath.startsWith('/')) pagePath = pagePath.slice(1)
  // If empty, set to index.md
  if (!pagePath) {
    pagePath = 'index.md'
  } else if (pagePath.endsWith('/')) {
    pagePath += 'index.md'
  } else if (!pagePath.endsWith('.md')) {
    pagePath += '.md'
  }
  // Always prefix with docs/
  pagePath = 'docs/' + pagePath
  const githubUrl = `https://github.com/modded-factorio/SeaBlock/new/wiki?filename=${pagePath}&value=${encodeURIComponent(markdownContent.value)}`
  window.open(githubUrl, '_blank')
}

const toggleTheme = () => {
  isDark.value = !isDark.value
  // Send the updated theme to the iframe
  updatePreview()
}

const fullscreenPreview = () => {
  // Toggle fullscreen mode on the existing iframe
  const editorContainer = document.querySelector('.editor-container')

  if (isFullscreen.value) {
    // Exit fullscreen
    editorContainer.classList.remove('fullscreen-mode')
    document.body.classList.remove('editor-fullscreen-active')
    isFullscreen.value = false
  } else {
    // Enter fullscreen
    editorContainer.classList.add('fullscreen-mode')
    document.body.classList.add('editor-fullscreen-active')
    isFullscreen.value = true
  }
}

const closeEditor = () => {
  isVisible.value = false
}

const startResize = e => {
  isResizing.value = true
  const startX = e.clientX
  const container = e.target.parentElement
  const leftPane = container.querySelector('.editor-pane')
  const rightPane = container.querySelector('.preview-pane')

  const handleMouseMove = e => {
    const deltaX = e.clientX - startX
    const containerWidth = container.offsetWidth
    const leftWidth = ((leftPane.offsetWidth + deltaX) / containerWidth) * 100
    const rightWidth = 100 - leftWidth

    if (leftWidth > 20 && rightWidth > 20) {
      leftPane.style.flex = `0 0 ${leftWidth}%`
      rightPane.style.flex = `0 0 ${rightWidth}%`
    }
  }

  const handleMouseUp = () => {
    isResizing.value = false
    document.removeEventListener('mousemove', handleMouseMove)
    document.removeEventListener('mouseup', handleMouseUp)
  }

  document.addEventListener('mousemove', handleMouseMove)
  document.addEventListener('mouseup', handleMouseUp)
}

// Keyboard shortcuts
const handleKeydown = e => {
  if (e.ctrlKey || e.metaKey) {
    switch (e.key) {
      case 's':
        if (isVisible.value) {
          e.preventDefault()
          copyToGitHub()
        }
        break
    }
  } else if (e.key === 'Escape' && isFullscreen.value) {
    // Exit fullscreen with Escape key
    e.preventDefault()
    fullscreenPreview()
  }
}

// Lifecycle
onMounted(async () => {
  document.addEventListener('keydown', handleKeydown)

  // Log initial content and metadata for debugging
  console.log('📝 EditorWidget mounted:')
  console.log('  - Initial content available:', !!props.initialContent)
  if (props.initialContent) {
    console.log('  - Initial content length:', props.initialContent.length)
    console.log('  - Initial content preview:', props.initialContent.substring(0, 100) + '...')
    console.log('  - Content type:', typeof props.initialContent)
    console.log('  - Has frontmatter:', props.initialContent.startsWith('---'))
  } else {
    console.log('  - No initial content provided')
  }

  // Listen for iframe ready messages
  window.addEventListener('message', event => {
    console.log('Received message:', event.data)
    if (event.data.type === 'iframe-ready') {
      iframeReady.value = true
      console.log('Iframe is ready')
      // Trigger initial render if we have content
      if (markdownContent.value.trim()) {
        updatePreview()
      }
    }
  })

  // Initialize preview when component mounts
  rendererStatus.value = '🚀 Real VitePress Components'
  nextTick(() => {
    updatePreview()
  })
})

onUnmounted(() => {
  document.removeEventListener('keydown', handleKeydown)
  // Clean up message listener
  window.removeEventListener('message', event => {
    if (event.data.type === 'iframe-ready') {
      iframeReady.value = true
    }
  })
})

// Expose methods for parent components
defineExpose({
  open: () => {
    console.log('📝 Opening editor with content:')
    console.log('  - Initial content available:', !!props.initialContent)

    // Update the markdown content with the initial content when opening
    if (props.initialContent) {
      markdownContent.value = props.initialContent
      console.log('  - Content loaded, length:', props.initialContent.length)
      console.log('  - Content preview:', props.initialContent.substring(0, 150) + '...')
    } else {
      console.log('  - No initial content, starting with empty editor')
      markdownContent.value = ''
    }

    isVisible.value = true
    console.log('  - Editor opened successfully')
  },
  close: closeEditor,
  setContent: content => {
    console.log('📝 Setting editor content, length:', content?.length || 0)
    markdownContent.value = content
  }
})
</script>

<style scoped>
.editor-widget {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
}

.editor-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  backdrop-filter: blur(4px);
}

.editor-container {
  position: relative;
  width: 90vw;
  height: 80vh;
  max-width: 1400px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.editor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  border-bottom: 1px solid #e5e7eb;
  background: #f9fafb;
}

.editor-header h3 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
}

.renderer-status {
  font-size: 0.875rem;
  color: #6b7280;
  font-weight: 500;
}

.processing-indicator {
  color: #3b82f6;
  font-weight: 500;
}

.close-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #6b7280;
  padding: 0.25rem;
  border-radius: 0.25rem;
  transition: all 0.2s;
}

.close-btn:hover {
  background: #e5e7eb;
  color: #374151;
}

.editor-content {
  flex: 1;
  display: flex;
  overflow: hidden;
}

.editor-pane,
.preview-pane {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0;
}

.pane-header {
  padding: 0.75rem 1rem;
  background: #f3f4f6;
  border-bottom: 1px solid #e5e7eb;
  font-weight: 500;
  color: #374151;
  font-size: 0.875rem;
}

.markdown-editor {
  flex: 1;
  border: none;
  padding: 1rem;
  font-family: 'Fira Code', 'Monaco', 'Consolas', 'Ubuntu Mono', monospace;
  font-size: 14px;
  line-height: 1.6;
  resize: none;
  outline: none;
  background: white;
  color: #2c3e50;
}

.preview-frame {
  flex: 1;
  border: none;
  width: 100%;
  height: 100%;
  background: white;
}

/* VitePress styling - handled by the real renderer */

/* VitePress custom containers - handled by the real renderer */

.splitter {
  width: 4px;
  background: #e5e7eb;
  cursor: col-resize;
  transition: background-color 0.2s;
  position: relative;
}

.splitter:hover,
.splitter.dragging {
  background: #3b82f6;
}

.editor-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  border-top: 1px solid #e5e7eb;
  background: #f9fafb;
}

.editor-actions {
  display: flex;
  gap: 0.5rem;
}

.btn {
  padding: 0.5rem 1rem;
  border: 1px solid #d1d5db;
  border-radius: 0.375rem;
  background: white;
  color: #374151;
  cursor: pointer;
  font-size: 0.875rem;
  transition: all 0.2s;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}

.btn:hover {
  background: #f9fafb;
  border-color: #9ca3af;
}

.btn-primary {
  background: #3b82f6;
  color: white;
  border-color: #3b82f6;
}

.btn-primary:hover {
  background: #2563eb;
}

.btn-secondary {
  background: #6b7280;
  color: white;
  border-color: #6b7280;
}

.btn-secondary:hover {
  background: #4b5563;
}

.editor-status {
  font-size: 0.75rem;
  color: #6b7280;
}

/* Fullscreen mode styles */
.editor-container.fullscreen-mode {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  right: 0 !important;
  bottom: 0 !important;
  width: 100vw !important;
  height: 100vh !important;
  max-width: none !important;
  z-index: 2000 !important;
  border-radius: 0 !important;
}

.editor-container.fullscreen-mode .editor-pane {
  display: none !important;
}

.editor-container.fullscreen-mode .splitter {
  display: none !important;
}

.editor-container.fullscreen-mode .preview-pane {
  flex: 1 !important;
  width: 100% !important;
  height: 100% !important;
}

.editor-container.fullscreen-mode .preview-frame {
  height: calc(100vh - 120px) !important; /* Account for header and footer */
}

.editor-container.fullscreen-mode .editor-footer {
  position: absolute !important;
  bottom: 0 !important;
  left: 0 !important;
  right: 0 !important;
  background: rgba(255, 255, 255, 0.95) !important;
  backdrop-filter: blur(8px) !important;
}

/* Dark theme support */
:global(.dark) .editor-container {
  background: #1f2937;
  color: #f9fafb;
}

:global(.dark) .editor-header,
:global(.dark) .editor-footer {
  background: #111827;
  border-color: #374151;
}

:global(.dark) .pane-header {
  background: #111827;
  border-color: #374151;
  color: #d1d5db;
}

:global(.dark) .markdown-editor {
  background: #1f2937;
  color: #f9fafb;
}

:global(.dark) .btn {
  background: #374151;
  color: #f9fafb;
  border-color: #4b5563;
}

:global(.dark) .btn:hover {
  background: #4b5563;
}

:global(.dark) .splitter {
  background: #374151;
}

:global(.dark) .splitter:hover,
:global(.dark) .splitter.dragging {
  background: #3b82f6;
}

:global(.dark) .editor-container.fullscreen-mode .editor-footer {
  background: rgba(31, 41, 55, 0.95) !important;
}
</style>
