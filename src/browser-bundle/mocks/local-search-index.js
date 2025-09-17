// Mock local search index for browser bundle
// This provides a minimal implementation for components that expect local search

export const localSearchIndex = {
  search: () => [],
  add: () => {},
  remove: () => {},
  clear: () => {}
}

export default localSearchIndex
