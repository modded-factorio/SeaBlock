# Editor Test Page

This page tests the integrated VitePress browser editor.

## Test Features

Click the ✏️ button in the bottom-right corner to open the editor and test:

### Custom Containers

::: tip
This is a tip container that should render properly in the editor.
:::

::: warning Warning Title
This is a warning container with a title.
:::

::: danger
This is a danger container.
:::

::: details Click to Expand
This is a details container that should be collapsible.
:::

### Code with Line Numbers

```javascript:line-numbers
function greet(name) {
  console.log(`Hello, ${name}!`);
  return `Welcome, ${name}!`;
}
```

```javascript:line-numbers=10
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(n => n * 2);
console.log(doubled);
```

### Tables

| Feature           | Status | Notes   |
| ----------------- | ------ | ------- |
| Custom Containers | ✅     | Working |
| Line Numbers      | ✅     | Working |
| Tables            | ✅     | Working |
| Vue Components    | ✅     | Working |

### Vue Components

<VueComponent title="Test Component" count="5">
This is slot content for the Vue component.
</VueComponent>

## Instructions

1. Click the ✏️ button in the bottom-right corner
2. The editor should open with a split-pane interface
3. Try typing markdown in the left pane
4. The right pane should show a live preview
5. Test all the features listed above

The editor should show "✅ Ready" in the header when it's properly initialized.
