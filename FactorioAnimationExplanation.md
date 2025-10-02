Factorio is a heavily data‑driven game: almost everything that appears on screen is described as a prototype. Each prototype defines the behaviour, collision boxes, craftability and – crucially – the visuals. Animations in Factorio are not just simple sprites; they are flexible objects capable of layering frames, tinting them at runtime, rotating them, and applying them only for certain visual states. This primer collates the Lua prototype documentation and shows how the animation structures are used and how different entity types compose their visualisations.

Fundamental animation types
Type Purpose and key fields Key details (citations)
Animation Base struct for animated sprites. Inherits from AnimationParameters and ultimately from SpriteParameters. It can consist of a single animation or multiple layers. Important fields include layers (stacked animations), stripes (multiple atlas regions), filenames (multiple sprite sheets), run_mode (forward / backward / forward‑then‑backward), frame_count, line_length, animation_speed (speed modifier) and frame_sequence (custom frame order). The docs note that Animation is a generic animation used by many prototypes and that frames may share memory when they come from the same sheet
lua-api.factorio.com
. AnimationParameters adds properties such as max_advance, repeat_count, dice (random frame selection), shift, scale, drawing flags (shadow, glow, light), tint and blend mode
lua-api.factorio.com
.
RotatedAnimation An animation that rotates automatically with the entity. It inherits the same parameters as Animation but adds direction_count (number of orientations), still_frame (frame index for idle state), counterclockwise, middle_orientation and orientation_range
lua-api.factorio.com
. Rotated animations can also be specified through layers, stripes or multiple files. Used for belts, rails and other entities that need more than four directions.
Animation4Way / RotatedAnimationVariations Convenience types for directional animations. Animation4Way accepts either a single Animation (applied to all directions) or a table with keys north, north_east, east, etc.; unspecified directions default to north
lua-api.factorio.com
. RotatedAnimationVariations allows multiple rotated variations (e.g., corpses or projectiles)
lua-api.factorio.com
.
AnimationVariations / AnimationSheet Used when an entity has several animation variations that share a sheet. A variation_count defines how many variations are stacked vertically on the spritesheet. When multiple sheets are used, they must have the same variation_count
lua-api.factorio.com
lua-api.factorio.com
.
Stripe Alternative way to specify frames. Each stripe defines width_in_frames, height_in_frames and a filename (with optional x and y offsets). Useful for packing frames into large atlases
lua-api.factorio.com
.
AnimationFrameSequence A list of frame indices (1‑based) that override the default sequential order. Supports repeating or skipping frames and up to 255 entries
lua-api.factorio.com
. Combined with run_mode ("forward", "backward", "forward‑then‑backward") to control playback behaviour
lua-api.factorio.com
.
Working visualisations and graphics sets

Crafting machines, furnaces and many other complex entities use graphics sets rather than raw animations. A graphics set groups together the base animation, optional idle animation, working visualisations, tinting rules and motion paths.

WorkingVisualisations and derived graphics sets

WorkingVisualisations is an abstract structure that forms the base for CraftingMachineGraphicsSet and MiningDrillGraphicsSet
lua-api.factorio.com
. Its key fields are:

animation / idle_animation – four‑directional animations (Animation4Way). Idle animation must have the same frame count as the working animation
lua-api.factorio.com
.

working_visualisations – an array of WorkingVisualisation objects. Each defines a separate layer used only when the machine is running. You can specify per‑direction animations and positions, secondary draw order, lights, recipe tint application, and control how long the visualisation lasts
lua-api.factorio.com
.

states – optional array of VisualState structures defining named phases with durations and transitions
lua-api.factorio.com
. The machine cycles through these states while working.

shift_animation_waypoints – defines per‑direction paths for moving parts of the animation (e.g., the pistons in assembling machines). Each direction is a list of vectors, and the engine moves the sprite between waypoints over time
lua-api.factorio.com
. Accompanying fields shift_animation_waypoint_stop_duration and shift_animation_transition_duration control how long the sprite pauses at each waypoint and how long transitions last
lua-api.factorio.com
.

status_colors – colours used when applying status‑tint to working visualisations
lua-api.factorio.com
.

CraftingMachineGraphicsSet inherits all of the above and adds optional frozen_patch (a Sprite4Way drawn over the machine when it is inactive) and reset_animation_when_frozen to reset animations when the machine stops
lua-api.factorio.com
. MiningDrillGraphicsSet adds drilling_vertical_movement_duration for the up–down motion of the drill head
lua-api.factorio.com
.

WorkingVisualisation

A single working visualisation layer has many options:

Position‑specific animations (north_animation, east_animation, etc.) and their offsets.

render_layer and secondary_draw_order to control draw ordering
lua-api.factorio.com
.

effect (flicker, uranium‑glow or none), apply_recipe_tint (tint by recipe colour) and apply_tint (tint by resource colour, status colour, etc.)
lua-api.factorio.com
.

Flags such as fadeout, synced_fadeout, constant_speed, always_draw, animated_shift, and align_to_waypoint, which change when the visualisation appears and whether it respects the machine’s speed
lua-api.factorio.com
.

A VisualState has a name, durations and target states for active or inactive transitions
lua-api.factorio.com
. When states are defined, the engine cycles through them and the working visualisation can restrict itself to particular states via draw_in_states
lua-api.factorio.com
.

Belt animations

Transport belts (and any entity that can connect to belts) use the TransportBeltAnimationSet to compose their animations. A belt’s prototype points to a RotatedAnimation and then selects which frame indices correspond to straight segments, start/end pieces and corners.

TransportBeltAnimationSet

The base set contains:

animation_set – a RotatedAnimation (often with 32 or 64 directions) that holds all belt frames
lua-api.factorio.com
.

Indices – east_index, west_index, north_index, south_index plus separate indices for starting/ending segments (e.g., starting_south_index, ending_east_index)
lua-api.factorio.com
. Each index points into the animation_set and tells the game which frame to draw for that orientation. Optional \_frozen indices allow replacing frames when the belt is frozen (stopped) and a separate frozen_patch sprite can overlay a static patch
lua-api.factorio.com
.

alternate – if true, the belt uses alternate frames for half of the directions to avoid repeating patterns
lua-api.factorio.com
.

TransportBeltAnimationSetWithCorners extends the base set with indices for corners – east_to_north_index, north_to_west_index, etc., plus frozen variants
lua-api.factorio.com
. These indices refer to the same animation_set but pick the frames that display curved belt segments.

Example – basic transport belt animation

A transport belt prototype might specify its visuals like this (simplified):

{ type = "transport-belt", name = "transport-belt",
speed = 0.03125, -- items per tick
belt_animation_set = {
animation_set = {
filename = "path/to/belt/sprites.png",
direction_count = 32,
frame_count = 16,
line_length = 8,
width = 64, height = 64,
shift = {0, 0},
},
north_index = 1, south_index = 9, east_index = 17, west_index = 25,
starting_east_index = 33, ending_east_index = 41,
starting_west_index = 49, ending_west_index = 57,
starting_north_index = 65, ending_north_index = 73,
starting_south_index = 81, ending_south_index = 89,
-- corner indices omitted for brevity
}
}

The speed controls gameplay throughput, while animation_speed inside animation_set defines how fast the belts appear to move. Because belts connect to each other in arbitrary directions, the engine picks the correct index to draw based on the connection shape. When a belt is turned off (e.g., by a circuit), the \_frozen indices and frozen_patch come into play.

Inserters

Inserters are not animated through the prototype system. Instead, they provide static sprites, and the engine animates the mechanical arm programmatically. The InserterPrototype defines:

platform_picture – the base onto which the inserter sits (a Sprite4Way)
lua-api.factorio.com
.

hand_base_picture, hand_open_picture, hand_closed_picture and shadows – static sprites for the arm. The arm’s movement (swing, rotation, open/close) is handled by the game code rather than by Animation. As a result, there is no animation field for inserters.

Specialised inserters (e.g., logistic or filter inserters) use tinted sprites for these pictures but still rely on the same programmatic animation.

Containers and logistic chests

Ordinary chests (ContainerPrototype) have a single picture sprite with no animation
lua-api.factorio.com
. Logistic chests (LogisticContainerPrototype) extend containers by adding an animation field (an Animation). This animation runs when logistic robots interact with the chest (e.g., when a robot drops off items)
lua-api.factorio.com
. The animation can have multiple layers and can tint itself according to logistic status or recipe colours.

Furnaces

Furnaces are subclasses of CraftingMachinePrototype and share most of their animation logic with assembling machines. A furnace usually defines a CraftingMachineGraphicsSet containing:

A base four‑direction animation showing the furnace housing.

idle_animation – often identical to the base animation but drawn with lower intensity.

working_visualisations – typically a flame animation or glowing overlays. The flame can be tinted by the recipe (apply_recipe_tint = "primary") so that smelting iron looks orange while smelting stone looks grey. Visualisations can include lights to brighten the furnace when working. The states field may define phases like “lighting up”, “hot” and “cooling down”.

The property match_animation_speed_to_activity on the furnace prototype determines whether the animation speed is tied to crafting speed
lua-api.factorio.com
.

Assembling machines

Assembling machines (AssemblingMachinePrototype) use the same CraftingMachineGraphicsSet as furnaces but often have more complex working visualisations:

Mechanical arms – Many assembling machine graphics use shift_animation_waypoints to move the piston that pushes items into the machine. For example, the tier‑1 assembler defines two waypoints for each direction; the engine smoothly interpolates between them while crafting. shift_animation_waypoint_stop_duration and shift_animation_transition_duration control pause and movement time.
lua-api.factorio.com
.

Multiple visual states – Assembling machines can define several VisualState objects (e.g., idle, running, stalled) and assign different working visualisations to each state via draw_in_states
lua-api.factorio.com
.

Recipe tint – Working visualisations often set apply_recipe_tint or apply_tint to colour pipes, vats or fluid indicators based on the current recipe
lua-api.factorio.com
.

Chemical plants

Chemical plants are a type of crafting machine that processes fluids. Their prototypes use WorkingVisualisations to display animated bubbling vats, rotating mixers and flowing pipes. Key points:

Fluid‑coloured animations – Visualisations use apply_recipe_tint for the primary and secondary recipe colours so that the plant glows with the colours of the fluids being processed. Some layers set apply_tint = "input-fluid-base-color" or "input-fluid-flow-color" to separately tint the base and the flowing part of the animation
lua-api.factorio.com
.

Multiple layers – The base animation shows the plant body, while working visualisations overlay animated fluid tanks, spinning agitators and bubbling chemistry sets.

No mechanical shift – Chemical plants typically do not use shift_animation_waypoints; their working visualisations rely on tinted animations rather than moving parts.

Train tracks

Rails are entities but they do not animate like machines. A RailPrototype (e.g., StraightRailPrototype) has a pictures property of type RailPictureSet and optionally a fence_pictures (RailFenceGraphicsSet)
lua-api.factorio.com
. These define all directions and layers of a rail piece:

Directional pictures – RailPictureSet contains eight RailPieceLayers (north, northeast, east, southeast, south, southwest, west, northwest)
lua-api.factorio.com
. Each RailPieceLayers struct holds SpriteVariations for metals, backplates, ties, stone path and backgrounds, plus optional water reflections and shadow masks
lua-api.factorio.com
. Variation support allows the game to randomise rails to reduce repetition.

Rail endings – Optional front_rail_endings and back_rail_endings (each a Sprite16Way) or rail_endings define the sprites used when a rail dead‑ends
lua-api.factorio.com
.

Segment visualisation – segment_visualisation_endings (a RotatedAnimation) is used only in planning/ghost mode to show how rails will connect
lua-api.factorio.com
.

Fences – RailFenceGraphicsSet defines pictures for fence posts on both sides of the rail and the render layers they appear on
lua-api.factorio.com
. It is static and has no animation.

Rails therefore do not have moving animations; instead they use sprite variations and tinted sprites to blend into the environment. The only animated component is the segment visualisation used by the rail planner.

Conclusion

Factorio’s prototype system provides a versatile way to describe complex animations without writing any engine code. Simple entities like chests use a static Sprite, belts use RotatedAnimation with index‑based composition, and machines rely on WorkingVisualisations with layered animations, tinting, visual states and motion paths. By understanding these structures – Animation, RotatedAnimation, WorkingVisualisations, TransportBeltAnimationSet, RailPictureSet and the associated helpers – modders can create new content that integrates seamlessly with the game’s visual language.
