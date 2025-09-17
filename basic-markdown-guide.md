# Basic Markdown Guide for VitePress Wikis

This guide covers the **core Markdown features** that every contributor will use. Keep it simple — you don’t need to know everything to start writing pages.

---

## 1. Headings

Use `#` for titles and `##` or `###` for sections.

```md
# Page Title

## Section Title

### Subsection Title
```

Headings automatically appear in the sidebar outline.

---

## 2. Paragraphs & Line Breaks

Just write text as you would normally. Leave an empty line between paragraphs.

```md
This is the first paragraph.

This is the second paragraph.
```

---

## 3. Emphasis

```md
*italic* or _italic_
**bold** or __bold__
~~strikethrough~~
```

---

## 4. Lists

### Bulleted list

```md
- First
- Second
  - Nested item
```

### Numbered list

```md
1. Step one
2. Step two
3. Step three
```

---

## 5. Links

### Internal link

```md
[Go to Getting Started](/getting-started/)
```

### External link

```md
[Factorio Wiki](https://wiki.factorio.com/)
```

---

## 6. Images

```md
![Alt text](/images/example.png)
```

Alt text is important for accessibility.

---

## 7. Blockquotes

```md
> This is a quoted line.
```

> This is a quoted line.

---

## 8. Code

### Inline code

```md
Use `iron-plate` as input.
```

### Code block

````md
```lua
/c game.speed = 2
```
````

---

## 9. Tables (simple)

```md
| Item | Cost |
|------|------|
| Iron | 1 ore |
| Copper | 1 ore |
```

| Item   | Cost  |
| ------ | ----- |
| Iron   | 1 ore |
| Copper | 1 ore |

---

## 10. Task Lists

```md
- [x] Finished task
- [ ] Unfinished task
```

-

---

## 11. Horizontal Rule

```md
---
```

---

## 12. Escaping

If you want to show raw Markdown characters, add a backslash:

```md
\*This will not be italic.\*
```

---

👉 With just these basics, you can write almost any wiki page!

