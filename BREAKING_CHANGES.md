# Breaking Changes in Factorio Data Processing

This document outlines the breaking changes introduced by the refactoring of the Factorio data processing approach.

## Overview of Changes

The data processing has been refactored to return original Factorio objects with minimal transformation, rather than creating custom data structures. This provides better compatibility with Factorio's data model while still adding necessary frontend enhancements.

## Breaking Changes

### 1. Data Structure Changes

#### **Groups (`en-groups.json`)**

- **BEFORE**: Custom structure with renamed fields
- **AFTER**: Original Factorio group objects + enrichment
- **Changes**:
  - All original Factorio properties preserved (e.g., `icon_size`, `order`, etc.)
  - Added `displayName` (localized name)
  - Added `subgroups` array containing all subgroups for the group
  - Icon paths converted to spritemap references

#### **Recipes (`en-recipes.json`)**

- **BEFORE**: Custom structure with renamed fields (`energyRequired`, `stackSize`, etc.)
- **AFTER**: Original Factorio recipe objects + enrichment
- **Changes**:
  - All original Factorio properties preserved (e.g., `energy_required`, `stack_size`, etc.)
  - Added `displayName` and `description` (localized)
  - Added `icon` (spritemap reference)
  - Added `tooltip` (structured tooltip data)
  - Ingredients and results arrays preserved as-is

#### **Items (`en-items.json`)**

- **BEFORE**: Custom structure with renamed fields
- **AFTER**: Original Factorio item objects + enrichment
- **Changes**:
  - All original Factorio properties preserved (e.g., `stack_size`, `fuel_value`, etc.)
  - Added `displayName` and `description` (localized)
  - Added `icon` (spritemap reference)
  - Added `tooltip` (structured tooltip data)

#### **Fluids (`en-fluids.json`)**

- **BEFORE**: Custom structure with renamed fields (`baseColor`, `flowColor`, etc.)
- **AFTER**: Original Factorio fluid objects + enrichment
- **Changes**:
  - All original Factorio properties preserved (e.g., `base_color`, `flow_color`, etc.)
  - Added `displayName` and `description` (localized)
  - Added `icon` (spritemap reference)
  - Added `tooltip` (structured tooltip data)

#### **Tiles (`en-tiles.json`)**

- **BEFORE**: Custom structure with renamed fields (`layerGroup`, `mapColor`, etc.)
- **AFTER**: Original Factorio tile objects + enrichment
- **Changes**:
  - All original Factorio properties preserved (e.g., `layer_group`, `map_color`, etc.)
  - Added `displayName` and `description` (localized)
  - Added `icon` (spritemap reference)
  - Added `tooltip` (structured tooltip data)

#### **Technologies (`en-technologies.json`)**

- **BEFORE**: Custom structure with renamed fields
- **AFTER**: Original Factorio technology objects + enrichment
- **Changes**:
  - All original Factorio properties preserved (e.g., `prerequisites`, `unit`, etc.)
  - Added `displayName` and `description` (localized)
  - Added `icons` (processed icon data)
  - Added `effects` (processed effects data)
  - Added `tooltip` (structured tooltip data)

#### **Buildings (`en-buildings.json`)**

- **BEFORE**: Custom structure with specific building types whitelist
- **AFTER**: Original Factorio entity objects + enrichment (blacklist approach)
- **Changes**:
  - All original Factorio properties preserved
  - Added `displayName` and `description` (localized)
  - Added `icon` (spritemap reference)
  - Added `tooltip` (structured tooltip data)
  - **Entity Type Filtering**: Now uses blacklist instead of whitelist
  - **Excluded Types**: `item`, `fluid`, `technology`, `recipe`, `item-group`, `item-subgroup`, `tile`, decorative entities
  - **Graphics**: Graphics paths are NOT modified in the data (see Graphics Path Mapping below)

### 2. New Files

#### **Graphics Path Mapping (`graphics-path-map.json`)**

- **NEW FILE**: Maps Factorio internal graphics paths to public paths
- **Purpose**: Allows frontend to convert Factorio graphics paths to public paths
- **Format**: `{ "factorio_path": "public_path", ... }`
- **Usage**: Frontend can use this mapping to convert graphics paths as needed

### 3. Removed Functionality

#### **Sprite Handling**

- **REMOVED**: `extractBuildingSprite()` method
- **REMOVED**: `fixGraphicsPaths()` method
- **REASON**: Graphics paths are now handled via the mapping approach

#### **Custom Field Renaming**

- **REMOVED**: All custom field renaming (e.g., `energy_required` → `energyRequired`)
- **REASON**: Preserve original Factorio field names for better compatibility

### 4. Frontend Impact

#### **Required Changes**

1. **Update data access patterns** to use original Factorio field names
2. **Implement graphics path conversion** using the graphics path mapping
3. **Update tooltip handling** to use the new tooltip structure
4. **Handle new enrichment properties** (`displayName`, `description`, `icon`, `tooltip`)

#### **Graphics Path Conversion**

```javascript
// Load the graphics path mapping
const graphicsPathMap = await fetch('/data/graphics-path-map.json').then(r => r.json())

// Convert Factorio path to public path
function convertGraphicsPath(factorioPath) {
  return graphicsPathMap[factorioPath] || factorioPath
}
```

#### **Data Access Examples**

```javascript
// OLD (custom fields)
recipe.energyRequired
item.stackSize
fluid.baseColor

// NEW (original Factorio fields)
recipe.energy_required
item.stack_size
fluid.base_color
```

### 5. Migration Guide

#### **For Frontend Components**

1. Update all field references to use original Factorio names
2. Implement graphics path conversion using the mapping
3. Use new enrichment properties (`displayName`, `description`, `icon`, `tooltip`)
4. Update any hardcoded field names in components

#### **For Data Processing**

1. No changes needed - the processor handles the conversion
2. Graphics files are still copied to the public directory
3. Spritemap generation remains the same

### 6. Benefits of Changes

1. **Better Compatibility**: Original Factorio data structure preserved
2. **Easier Maintenance**: No need to maintain custom field mappings
3. **More Flexible**: Frontend can choose when/how to use path conversions
4. **Cleaner Separation**: Graphics handling separated from data processing
5. **Future-Proof**: Changes to Factorio data structure won't break the processor

## Next Steps

1. **Update Frontend Components**: Modify all components to use original Factorio field names
2. **Implement Graphics Path Conversion**: Add graphics path mapping functionality
3. **Update Documentation**: Update any documentation that references the old field names
4. **Test Thoroughly**: Ensure all functionality works with the new data structure
