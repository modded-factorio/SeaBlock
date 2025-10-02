# Building Component

The Building component displays detailed information about Factorio buildings with integrated tooltips and sprite icons.

## Basic Usage

<Building building-id="assembling-machine-1" />

<Building building-id="assembling-machine-2" />

<Building building-id="assembling-machine-3" />

## Animated Sprites

Showcasing the real animated sprites from Factorio:

<Building building-id="assembling-machine-1" variant="animated" />

<Building building-id="inserter" variant="animated" />

<Building building-id="chemical-plant" variant="animated" />

## Sprite-Focused Display

Showcasing the static sprite rendering with larger, more prominent icons:

<Building building-id="assembling-machine-1" variant="sprite-focused" :icon-size="64" />

<Building building-id="inserter" variant="sprite-focused" :icon-size="64" />

<Building building-id="chemical-plant" variant="sprite-focused" :icon-size="64" />

## Different Variants

### Compact Variant

<Building building-id="inserter" variant="compact" />

<Building building-id="fast-inserter" variant="compact" />

<Building building-id="long-handed-inserter" variant="compact" />

### Detailed Variant

<Building building-id="chemical-plant" variant="detailed" />

<Building building-id="oil-refinery" variant="detailed" />

## Different Icon Sizes

<Building building-id="steel-furnace" :icon-size="32" />

<Building building-id="electric-furnace" :icon-size="64" />

<Building building-id="stone-furnace" :icon-size="96" />

## Without Tooltip

<Building building-id="lab" :show-tooltip="false" />

<Building building-id="radar" :show-tooltip="false" />

## Building Types

### Assembling Machines

<Building building-id="assembling-machine-1" variant="compact" />
<Building building-id="assembling-machine-2" variant="compact" />
<Building building-id="assembling-machine-3" variant="compact" />

### Furnaces

<Building building-id="stone-furnace" variant="compact" />
<Building building-id="steel-furnace" variant="compact" />
<Building building-id="electric-furnace" variant="compact" />

### Inserters

<Building building-id="inserter" variant="compact" />
<Building building-id="fast-inserter" variant="compact" />
<Building building-id="long-handed-inserter" variant="compact" />

### Power Generation

<Building building-id="boiler" variant="compact" />
<Building building-id="steam-engine" variant="compact" />
<Building building-id="solar-panel" variant="compact" />

## Component Props

| Prop                 | Type          | Default   | Description                                                                        |
| -------------------- | ------------- | --------- | ---------------------------------------------------------------------------------- |
| `building-id`        | String        | Required  | The ID of the building to display                                                  |
| `icon-size`          | Number/String | 48        | Size of the building icon in pixels                                                |
| `show-tooltip`       | Boolean       | true      | Whether to show the tooltip trigger button                                         |
| `variant`            | String        | 'default' | Display variant: 'default', 'compact', 'detailed', 'sprite-focused', or 'animated' |
| `showAnimatedSprite` | Boolean       | false     | Force display of animated sprite instead of static icon                            |

## Features

- **Sprite Icons**: Displays building icons from the spritemap
- **Building Stats**: Shows health, mining time, and flags
- **Tooltip Integration**: Click "View Details" to see full tooltip information
- **Multiple Variants**: Compact, default, and detailed display options
- **Responsive Design**: Adapts to different screen sizes
- **Dark Mode Support**: Automatically adapts to VitePress theme
- **Loading States**: Shows loading spinner while fetching data
- **Error Handling**: Displays error message if building data fails to load

## Usage Examples

```vue
<!-- Basic building display -->
<Building building-id="assembling-machine-1" />

<!-- Compact variant with smaller icon -->
<Building building-id="inserter" variant="compact" :icon-size="32" />

<!-- Detailed variant without tooltip -->
<Building building-id="chemical-plant" variant="detailed" :show-tooltip="false" />
```
