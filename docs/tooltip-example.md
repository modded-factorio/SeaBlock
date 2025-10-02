# Tooltip Component Example

This page demonstrates the usage of the Tooltip component with data from the en-tooltips.json file and the new sprite map functionality.

## Basic Usage

The Tooltip component can be used to display information about items, recipes, buildings, and other game elements. Icons are now displayed using the generated sprite map for better performance.

### Items

<Tooltip item-id="iron-ore" category="items">
  Iron ore
</Tooltip>

<Tooltip item-id="copper-ore" category="items">
  Copper ore
</Tooltip>

<Tooltip item-id="steel-plate" category="items">
  Steel plate
</Tooltip>

<Tooltip item-id="coal" category="items">
  Coal
</Tooltip>

<Tooltip item-id="stone" category="items">
  Stone
</Tooltip>

### Recipes

<Tooltip item-id="speed-module" category="recipes">
  Speed module recipe
</Tooltip>

<Tooltip item-id="productivity-module" category="recipes">
  Productivity module recipe
</Tooltip>

### Buildings

<Tooltip item-id="assembling-machine-1" category="buildings">
  Assembling machine 1
</Tooltip>

<Tooltip item-id="electric-furnace" category="buildings">
  Electric furnace
</Tooltip>

## Different Positions

You can specify different tooltip positions:

<Tooltip item-id="iron-ore" category="items" position="top">
  Top tooltip
</Tooltip>

<Tooltip item-id="copper-ore" category="items" position="bottom">
  Bottom tooltip
</Tooltip>

<Tooltip item-id="steel-plate" category="items" position="left">
  Left tooltip
</Tooltip>

<Tooltip item-id="coal" category="items" position="right">
  Right tooltip
</Tooltip>

## Custom Delay

You can also customize the delay before showing the tooltip:

<Tooltip item-id="wood" category="items" :delay="100">
  Fast tooltip (100ms delay)
</Tooltip>

<Tooltip item-id="stone" category="items" :delay="1000">
  Slow tooltip (1000ms delay)
</Tooltip>

## Usage in Text

You can use tooltips inline with text, like this: <Tooltip item-id="iron-ore" category="items">iron ore</Tooltip> is a basic resource, while <Tooltip item-id="steel-plate" category="items">steel plate</Tooltip> is a more advanced material.

## SpriteIcon Component

The SpriteIcon component can be used independently to display icons from the sprite map:

### Different Sizes

<SpriteIcon sprite-key="item-iron-ore" :size="16" title="Iron ore (16px)" />
<SpriteIcon sprite-key="item-copper-ore" :size="24" title="Copper ore (24px)" />
<SpriteIcon sprite-key="item-steel-plate" :size="32" title="Steel plate (32px)" />
<SpriteIcon sprite-key="item-coal" :size="48" title="Coal (48px)" />
<SpriteIcon sprite-key="item-stone" :size="64" title="Stone (64px)" />

### Building Icons

<SpriteIcon sprite-key="entity-assembling-machine-1" :size="32" title="Assembling machine 1" />
<SpriteIcon sprite-key="entity-electric-furnace" :size="32" title="Electric furnace" />
<SpriteIcon sprite-key="entity-chemical-plant" :size="32" title="Chemical plant" />
<SpriteIcon sprite-key="entity-oil-refinery" :size="32" title="Oil refinery" />

### Recipe Icons

<SpriteIcon sprite-key="recipe-automation-science-pack" :size="32" title="Automation science pack" />
<SpriteIcon sprite-key="recipe-chemical-science-pack" :size="32" title="Chemical science pack" />
<SpriteIcon sprite-key="recipe-military-science-pack" :size="32" title="Military science pack" />

## Pinning Functionality

Tooltips can be pinned open by clicking on them or the pin button. When pinned:

- The tooltip stays visible even when you move your mouse away
- A visual indicator (colored border and pin icon) shows the pinned state
- Click the pin button or the tooltip trigger again to unpin

Try hovering over these items and clicking to pin them:

<Tooltip item-id="iron-ore" category="items">
  Iron ore (click to pin)
</Tooltip>

<Tooltip item-id="assembling-machine-1" category="buildings">
  Assembling machine 1 (click to pin)
</Tooltip>

## Features

- **Dynamic Loading**: Tooltip data is loaded dynamically from `/data/en-tooltips.json`
- **Sprite Map**: Icons are loaded from a single optimized sprite map image
- **Pinning**: Click to pin tooltips open for easy reference
- **Caching**: Data is cached globally to avoid repeated requests
- **Accessibility**: Supports keyboard navigation and screen readers
- **Responsive**: Automatically positions tooltips to stay within viewport
- **Customizable**: Supports different positions and delays
- **Dark Mode**: Automatically adapts to VitePress dark/light theme
