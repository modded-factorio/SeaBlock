# Factorio Entity Graphics Sets (Working State Only)

This document summarizes the **graphics sets required for rendering entities in Factorio**, focusing only on their _working state_. It omits shadows, remnants, lights, smoke, and other special effects.

---

## 🔹 Core Graphics Structures

1. **`animation`**  
   Used for entities with animated working states (assemblers, furnaces, labs, inserters, belts, etc.).

   ```lua
   animation = {
     filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1.png",
     width = 108,
     height = 119,
     frame_count = 32,
     line_length = 8,
     shift = {0.4, -0.06}
   }
   ```

2. **`picture`**  
   Used for static graphics (chests, poles, lamps, simple machines).

   ```lua
   picture = {
     filename = "__base__/graphics/entity/iron-chest/iron-chest.png",
     width = 32,
     height = 40,
     shift = {0, -0.2}
   }
   ```

3. **`working_visualisations`** (optional)  
   Layered active effects for machines (e.g. furnace glow, assembler parts).

   ```lua
   working_visualisations = {
     {
       animation = {
         filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1-animation.png",
         width = 54,
         height = 54,
         frame_count = 32,
         line_length = 8
       }
     }
   }
   ```

4. **`pictures`**  
   For directional entities (belts, underground belts, pipes). Defined per direction.

   ```lua
   pictures = {
     north = { filename = "...", width = 40, height = 40 },
     east  = { filename = "...", width = 40, height = 40 },
     south = { filename = "...", width = 40, height = 40 },
     west  = { filename = "...", width = 40, height = 40 }
   }
   ```

---

## 🔹 Typical Entity Graphics Sets

- **Machines (assemblers, furnaces, labs):** `animation` + optional `working_visualisations`
- **Static entities (chests, poles, rails, lamps):** `picture`
- **Belts, pipes, underground belts:** `pictures` (+ `animation` for belts)
- **Inserters:** arm and platform graphics (see below)
- **Mining drills:** directional `animations`
- **Turrets:** `prepared_animation` (normal stance), others only if needed for folding/unfolding

---

## 🔹 Inserter Graphics Setup

Inserters are composed of multiple sprites that are animated together by the engine.

### 1. Hand (Arm) Graphics

```lua
hand_open_picture = {
  filename = "__base__/graphics/entity/inserter/inserter-hand-open.png",
  width = 18,
  height = 41
}

hand_closed_picture = {
  filename = "__base__/graphics/entity/inserter/inserter-hand-closed.png",
  width = 18,
  height = 41
}

hand_base_picture = {
  filename = "__base__/graphics/entity/inserter/inserter-hand-base.png",
  width = 8,
  height = 34
}
```

- **`hand_base_picture`** = lower arm, rotates around pivot.
- **`hand_open_picture`** = claw when not holding items.
- **`hand_closed_picture`** = claw when carrying items.

### 2. Platform Graphics

```lua
platform_picture = {
  sheet = {
    filename = "__base__/graphics/entity/inserter/inserter-platform.png",
    width = 46,
    height = 46
  }
}
```

- Static, the base the inserter is mounted on.

### 3. Shadows (optional)

Each of the above can have a shadow equivalent, but they can be omitted if focusing on minimal rendering.

---

## ✅ Minimal Working-State Summary

For rendering entities outside the game without effects:

- **Machines:** `animation` (+ `working_visualisations` if present)
- **Statics:** `picture`
- **Directional entities:** `pictures`
- **Inserters:** `hand_base_picture`, `hand_open_picture`, `hand_closed_picture`, `platform_picture`
- **Mining drills:** `animations`
- **Turrets:** `prepared_animation`

This setup is sufficient to reproduce the _core visuals_ of Factorio entities in their working state.
