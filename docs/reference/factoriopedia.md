---
layout: page
---

<style>
/* Match main site styling for page layout */
.VPPage {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1rem;
  line-height: 1.6;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Fira Sans', 'Droid Sans', 'Helvetica Neue', sans-serif;
}

.VPPage h1 {
  font-size: 2.25rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #2c3e50;
  border-bottom: 1px solid #e2e8f0;
  padding-bottom: 0.5rem;
  background: linear-gradient(135deg, #00d4aa, #fdcb6e);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.VPPage h2 {
  font-size: 1.875rem;
  font-weight: 600;
  margin-top: 2rem;
  margin-bottom: 1rem;
  color: #2c3e50;
  border-bottom: 1px solid #e2e8f0;
  padding-bottom: 0.5rem;
}

.VPPage p {
  margin-bottom: 1rem;
  color: #2c3e50;
}

.VPPage ul {
  margin: 1rem 0;
  padding-left: 2rem;
}

.VPPage li {
  margin: 0.25rem 0;
  color: #2c3e50;
}

.VPPage strong {
  font-weight: 600;
  color: #00d4aa;
}

.VPPage code {
  background-color: #f1f5f9;
  padding: 0.125rem 0.25rem;
  border-radius: 0.25rem;
  font-family: 'Fira Code', 'Monaco', 'Consolas', 'Ubuntu Mono', monospace;
  font-size: 0.875rem;
  color: #2c3e50;
}

/* Dark mode support */
.dark .VPPage h1,
.dark .VPPage h2 {
  color: #f9fafb;
  border-bottom-color: #4a5568;
}

.dark .VPPage p,
.dark .VPPage li {
  color: #f9fafb;
}

.dark .VPPage code {
  background-color: #2d3748;
  color: #e2e8f0;
}
</style>

# Factoriopedia

The Factoriopedia is an in-game encyclopedia that provides detailed information about all items, recipes, and technologies in SeaBlock. This web version replicates the same interface and functionality as the in-game Factoriopedia.

## Features

- **Item Browser**: Browse all items in a grid layout with category filters
- **Detailed Information**: View comprehensive details about each item including:
  - Basic properties (stack size, fuel value, etc.)
  - Sources (where the item can be obtained)
  - Usage (what recipes use this item)
  - Alternative recipes
- **Recipe Information**: Detailed recipe breakdowns with ingredients, crafting time, and required buildings
- **Navigation**: Use URL hash parameters to link directly to specific items

## Usage

- Click on any item in the left panel to view its details
- Use the category filters at the top to narrow down items
- The URL will update automatically, allowing you to bookmark or share specific items
- Use the search functionality to quickly find items by name

## URL Parameters

- `#item=<item-name>` - Direct link to a specific item
- `#category=<category-name>` - Filter by item category

<Factoriopedia />
