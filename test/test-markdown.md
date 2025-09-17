---
title: 'Test VitePress Markdown Processing'
description: 'Testing front matter, containers, and code blocks'
layout: 'doc'
sidebar: true
---

# Test VitePress Markdown Processing

This is a test of our improved VitePress-compatible markdown processing.

## Front Matter Test

The front matter above should be properly parsed and available to the VitePress components.

## Container Test

::: tip
This is a tip container. It should be styled with a green border and background.
:::

::: warning
This is a warning container. It should be styled with a yellow border and background.
:::

::: danger
This is a danger container. It should be styled with a red border and background.
:::

::: details
This is a details container. It should be collapsible.
:::

## Code Block Test

Here's some inline `code` that should be styled properly.

```javascript
// This is a JavaScript code block
function hello() {
  console.log('Hello, VitePress!')
  return 'success'
}

hello()
```

```python
# This is a Python code block
def hello():
    print("Hello, VitePress!")
    return "success"

hello()
```

## Table Test

| Feature      | Status | Notes                           |
| ------------ | ------ | ------------------------------- |
| Front Matter | ✅     | Should be parsed                |
| Containers   | ✅     | Should be styled                |
| Code Blocks  | ✅     | Should have syntax highlighting |
| Tables       | ✅     | Should be properly formatted    |

## Task List Test

- [x] Front matter processing
- [x] Container support
- [ ] Syntax highlighting (needs Shiki)
- [x] Table formatting
- [x] Task lists
