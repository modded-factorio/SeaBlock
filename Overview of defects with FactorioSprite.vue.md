How the Factorio-style animation model maps onto your Vue component — and what to fix

Below is a focused, code-aware write-up that applies the Factorio prototype animation model to your FactorioSprite Vue component. I’ve called out exactly what your code already covers, what it misses, and a concrete set of remedial tasks (with suggested code changes) to reach “full compliance” with how Factorio prototypes express and compose animations.

1. What your component already does well

Detects several broad shapes of data (graphics_set.animation.layers, animation.layers, simple picture{,s}, some inserter fields, some pipe atlas-like shapes).

Renders layered sprites on a canvas, including shadows first and base sprites above.

Renders simple sprite sheets using frame_count and line_length.

Handles “directional sprite” in a minimalist way (but only selects north).

Provides a CSS path (withBase) suitable for static assets.

Splits simple CSS background vs. canvas rendering for complexity.

These are solid foundations, but Factorio’s prototype surface is bigger and more nuanced.

2. Big gaps vs. Factorio’s prototype surface (what’s missing)
   A) Sprite/Animation schema coverage

Rotated vs. Directional assets

Factorio uses RotatedSprite/RotatedAnimation (with 32/16/8 directions, plus direction_count, apply_runtime_tint, etc.).

Your code only checks for animations.north|east|south|west or 4-way pictures and then renders north only.

Run modes & frame sequencing

Prototypes can specify run_mode (e.g., forward, backward, ping-pong) and frame_sequence.

Your renderer always increments currentFrame forward modulo frameCount.

Stripes & sprite sources

Many animations are split as stripes or use layers[*].stripes instead of a single filename.

Your code assumes filename frames on a single sheet.

High-res (hr_version) fallbacks

Prototypes often offer layered hr_version entries and expect downscale/upsample handling.

Not considered at all.

Sprite variations / N-way

Things like SpriteVariations, Sprite4Way, Sprite16Way, SpriteNWaySheet are common.

Your code treats “directional” narrowly and doesn’t randomize or pick by orientation.

Tinting & blend types

apply_runtime_tint, blend_mode, draw_as_light, draw_as_glow, tint (RGBA).

You detect glow/light/shadow flags but don’t apply tinting or blend modes.

Shifts & scale fidelity

Shifts in Factorio are tile-space vectors (pixels/32 or pixels/64 semantics).

You treat shifts as pixel offsets directly without normalizing to canvas scale.

Perceived performance / animation speed linkage

Machines can set match_animation_speed_to_activity and perceived_performance.

Your code uses a fixed requestAnimationFrame cadence with no speed derivation.

B) System-specific surfaces not covered

Transport belts

Use TransportBeltAnimationSet{WithCorners} with indices for straight/corners/start/end and optional frozen patches.

Your detection only checks for belt_animation_set.animation_set.filename, and rendering ignores indices, corners, or frozen frames.

Crafting machines (assemblers, furnaces, chemical plants)

Rely on CraftingMachineGraphicsSet and WorkingVisualisations with stateful visuals (running/idle), tints per recipe, lights, and animation speed tied to working state.

You only render graphics_set.animation.layers for one direction and ignore visualisation states and tints.

Inserters

Hands are transforms (rotation, extension) + shadows, not frame-based only; often composed of multiple sprites (platform, hand base/open/closed) with runtime transforms.

Your inserter renderer loads images but only draws platform/hand base statically.

Rails

RailPictureSet provides 8 directions, front/back endings (Sprite16Way), segment visualisations (RotatedAnimation), and multiple layer stacks (metals, ties, backplates…).

Your atlas path doesn’t load or assemble rail piece layers/endings.

Pipes & heat pipes

Rich connection sprites with many configurations; you only sample a single entry and render one pose.

Accumulators, steam engines/turbines, generators

Have horizontal/vertical animations and frozen patches, run modes, and layered lights.

You handle H/V layers minimally and don’t account for frozen patches or run mode.

3. Entity-by-entity trace + the delta to close
   Transport belts (transport/underground/splitter)

What you detect: belt_animation_set.animation_set.filename → SPRITE_SHEET.

What full support requires:

Parse all indices (north/east/south/west, starting/ending, corners for splitters/turns).

Respect RotatedAnimation direction layout (often 16).

Support optional frozen_patch for paused belts; render “frozen” indices when needed.

Remedy highlights: add a handleBeltAnimationSet() that:

Loads animation_set (possibly layered), extracts frames per direction using the supplied indices.

Exposes API to select segment role (starting*, ending*, straight, corner).

Supports frozen indices and toggling at runtime.

Inserters

What you do: load platform/hand images and draw static platform + base hand.

What full support requires:

Rotate & extend the hand about a pivot according to state (open/closed, pickup/drop progress).

Render shadow layers with offset & alpha.

Optionally apply tints (circuit coloring) if provided.

Remedy highlights: in renderInserter():

Compute arm angle/extension from a prop (progress, angle, state) and draw with ctx.translate/rotate around pivot.

Add shadow pass (offset & lower alpha), then sprite.

Optionally lerp between handOpen / handClosed or render a single arm sprite rotated (closer to game logic).

Chests/containers

What you do: layered static sprites to CSS or canvas.

What full support requires:

Some logistic chests use animation (open/close).

Need run mode and frame sequencing (ping-pong) and support for layers with hr_version/tint.

Remedy highlights: treat chest animation.layers like other sheets; add runMode & frameSequence logic (see §4).

Furnaces / Assembling machines / Chemical plants

What you do: render graphics_set.animation.layers for “north” only.

What full support requires:

graphics_set also has working_visualisations (lights, pipe glow, flames), optional flipped set, integration patches, recipe tints, and perceived performance coupling.

Must support directional (4 or 8) variants and apply_runtime_tint.

Remedy highlights:

Add parsing for graphics_set.working_visualisations[*] (draw order, light/glow blend, apply_recipe_tint).

Add direction prop and choose directional block accordingly.

Multiply animation speed by a provided activity factor when match_animation_speed_to_activity is true.

Pipes / Heat pipes

What you do: pick 1 config from pictures or connection_sprites and draw.

What full support requires:

Resolve the actual connection shape at runtime (straight, corner, T, cross, endings) and draw corresponding sprite(s).

Some have glow/light layers.

Remedy highlights: accept a connectionMask prop (or explicit shape) and select the right sprite set; render glow/light layers with additive blending.

Rails

What you do: not supported beyond trivial atlas rendering.

What full support requires:

Load RailPictureSet: for each of the 8 directions, combine metals/ties/backplates/stone path variations, optional rail endings (Sprite16Way), and segment_visualisation_endings (RotatedAnimation).

Respect render layers ordering.

Remedy highlights: create handleRailPictures() to assemble the 8 direction stacks (prefer canvas rendering). Accept a direction/variant prop to pick which to draw in demos.

Steam engine / turbine / generator

What you do: basic H/V layered animations.

What full support requires: support frozen patches, run modes, lights, and speed coupling to performance.

Remedy highlights: same animation core improvements as §4.

4. Core animation engine upgrades (affects most entities)

Direction handling

Add a direction prop (0…15) and a resolver that:

Maps 4-way, 8-way, 16-way and RotatedAnimation to the correct frame index.

For simple directional maps (animations.north…), select by name.

Run mode & frame sequencing

Support run_mode: forward, backward, forward-then-backward (ping-pong), random.

Support frame_sequence (explicit per-frame indices).

Store frameClock (float), derive frameIndex via animation_speed and dt.

Stripes & sources

If stripes is present, compose the full sheet logically (or compute UVs per stripe) instead of assuming one filename.

Hi-res fallback

If hr_version exists and useHiRes (devicePixelRatio or user pref) is true, prefer it, else fallback to normal.

Tint & blend modes

Apply rgba tint (fillStyle pass or draw to offscreen then multiply).

Implement additive blending for draw_as_light/glow (ctx.globalCompositeOperation = 'lighter').

Shifts & pivots

Normalize shift to canvas pixels (respect base pixel-per-tile), and apply via ctx.translate.

Support per-layer rotation and scale when present.

Speed coupling

Accept activity (0..∞) and, when match_animation_speed_to_activity is true, multiply animation_speed by it.

Variation selection

If a layer is a SpriteVariations array, support picking a variation index (prop, seeded random).

5. Concrete remedial tasks & patches
   Task A — Add a direction system

New prop: direction (number | string), optional directions = 4|8|16.

Change: in renderSpriteSheet/renderLayeredSprite, compute direction frame offset:

// pseudo
const dir = normalizeDirection(props.direction, directions); // 0..directions-1
const framesPerDir = data.frameCount / directions;
const dirOffset = dir \* framesPerDir;
const frameIndex = dirOffset + localFrameIndex(runMode, frameSequence, framesPerDir);

Also: for simple directional maps (animations.north|…), choose by name.

Task B — Implement run modes & frame sequences

New utility: computeFrameIndex({t, animation_speed, frame_count, run_mode, frame_sequence})

Support forward, backward, forward-then-backward, random.

If frame_sequence is present, index into it instead of modulo frame_count.

Task C — Stripes support

Loader change: unify loadImageSource(layer) that can return:

a whole sheet (filename), or

computed UV regions across stripes (sum of stripes’ frames, width, height).

Render by selecting the correct stripe frame.

Task D — Hi-res (hr_version)

Layer resolve:

const L = preferHiRes && layer.hr_version ? layer.hr_version : layer;

Scale: if using hr assets, multiply scale appropriately (hr assets are typically 2×).

Task E — Tint & blend

Add layer fields: tint, apply_runtime_tint, draw_as_glow, draw_as_light, blend_mode.

Canvas: draw layer to offscreen, apply tint (multiply), then composite. For lights/glow:

ctx.globalCompositeOperation = 'lighter';

Reset to source-over after.

Task F — Shifts, pivots, rotation

Normalize shift: decide a pixels-per-unit (e.g., 32 px/tile), convert prototype shift vectors into pixels before ctx.translate.

Rotation: if layer has rotate/orientation, ctx.rotate(radians) around its pivot.

Task G — Transport belt animation set

New handler: handleBeltAnimationSet(graphicsData):

Parse animation*set and all indices (north_index, starting*..., ending\_..., corners when using …WithCorners).

Add optional frozen_patch indices.

Renderer: select the correct index based on props (segmentKind, cornerKind) and direction.

Task H — Working visualisations (assemblers/furnaces/chemical plant)

Parse: graphics_set.working_visualisations with fields like apply_recipe_tint, light/glow, animation (may be single frame with glow), visibility by state.

New prop: workingState ('idle'|'working'|'disabled'|…) and recipeTint.

Render: draw base animation layer(s) then overlay visualisations, applying tints & blend ops.

Task I — Inserter transforms

New props: armAngle, armExtension, showShadow.

Renderer: translate to pivot, rotate(armAngle), draw hand; apply extension via draw position; draw shadow first with offset & alpha.

Task J — Rails

New handler: handleRailPictures(graphicsData):

Build the 8-direction stacks from RailPictureSet (metals, ties, backplates, variations).

Support rail_endings (Sprite16Way).

Add direction prop (0..7) and endingKind to choose the correct sprite set.

Task K — Pipes & heat pipes

New prop: connectionMask/shape to map to the correct pictures[...] or connection_sprites[...].

Renderer: draw all layers for that shape, including glow/light.

Task L — Speed coupling

New prop: activity (0..∞). If the data implies match_animation_speed_to_activity, multiply animation_speed \*= activity.

Task M — Error handling & fallbacks

Stop assuming width/height=64. Fail fast if missing, or load image to read natural size.

Gracefully handle missing layers / malformed stripes with console warnings rather than silent defaults.

6. Minimal code diffs to get you moving
   Add direction + run-mode to sprite sheet renderer
   // new helpers
   function nextFrameIndex(state) { /_ compute with run_mode & frame_sequence _/ }
   function dirOffset(index, directions, framesPerDir) { return index \* framesPerDir; }

const directionsCount = animation.direction_count || 1; // 1, 4, 8, 16…
const framesPerDir = Math.floor(data.frameCount / directionsCount);
const dir = normalizeDirection(props.direction, directionsCount);
const local = nextFrameIndex({ /_ use animation.animation_speed, run_mode, frame_sequence _/ });
const frameIndex = dirOffset(dir, directionsCount, framesPerDir) + (local % framesPerDir);

Prefer hr_version
function resolveLayer(layer, useHiRes = window.devicePixelRatio >= 2) {
return (useHiRes && layer.hr_version) ? layer.hr_version : layer;
}

Apply tint / glow
ctx.save();
if (layer.draw_as_glow || layer.draw_as_light) {
ctx.globalCompositeOperation = 'lighter';
}
if (layer.tint) {
// draw to offscreen, multiply by tint, then draw back
}
ctx.drawImage(/_ … _/);
ctx.restore();

Inserter rotation
ctx.save();
ctx.translate(pivotX, pivotY);
ctx.rotate(props.armAngle || 0);
ctx.drawImage(handImg, -handPivotX, -handPivotY, w, h);
ctx.restore();

7. Public component API changes (to drive correctness)

direction: number | string (0..15, 'north'|'east'|...).

activity: number (used if match_animation_speed_to_activity).

workingState: string (for working_visualisations visibility).

recipeTint: {r,g,b,a} (applied when apply_recipe_tint).

segmentKind / cornerKind: strings for belt segments.

useHiRes: boolean (override auto HR selection).

shape / connectionMask: for pipes/heat pipes.

armAngle, armExtension, showShadow: for inserter demo rendering.

variationIndex: number (SpriteVariations).

8. Testing checklist (per entity)

Belts: straight/corner/start/end + frozen toggling; 4 rotations; indices pick correct frames.

Inserter: animate pickup→drop rotation; shadow offset; platform drawn under hand.

Assembler/Furnace/Chem plant: idle vs working; recipe tint; glow/light blended.

Chests: open/close animation ping-pong; hr_version fallback.

Pipes/Heat pipes: all shapes render; glow blended.

Rails: 8 directions, endings present; metals/ties/backplates stacked in order.

Steam engine/Turbine: H/V variants; frozen patches; run modes.

9. Prioritization (lowest effort → highest impact)

Direction + run-mode + frame sequence (core engine).

hr_version + stripes (asset correctness & crispness).

Tint/glow/light blend (visual parity).

Belts’ indices & frozen (high-visibility parity).

Working visualisations (assemblers/furnaces/plants).

Inserter transforms (accuracy over static images).

Rails & pipes full sets (completion).

If you want, I can turn these tasks into specific PR-ready patches (split by area), or wire the new props into your existing demos so you can verify direction, activity, and working states interactively.
