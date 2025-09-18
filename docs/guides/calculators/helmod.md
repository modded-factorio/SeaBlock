# Helmod Calculator

Helmod is a reliable calculator included in the Sea Block Pack, and Kiwi is working to make it even easier to use. While Helmod offers some in-game help, more documentation and updates are planned for the wiki. For step-by-step instructions, check out the video tutorials below:

## Video Tutorials

### Beginner

<iframe width="560" height="315" src="https://www.youtube.com/embed/9VNa1gEENSw" title="Helmod Beginner Tutorial" frameborder="0" allowfullscreen></iframe>

### Intermediate

<iframe width="560" height="315" src="https://www.youtube.com/embed/ifpOCjaf8G0" title="Helmod Intermediate Tutorial" frameborder="0" allowfullscreen></iframe>

## Circular Recipes (Recycling Outputs)

<div style="float: right; margin-left: 2em; max-width: 340px; text-align: center;">
  <img src="/images/charcoal_using_slag_1.png" alt="Ctrl+Click on Charcoal in Matrix Mode because it's produced and used within the block. Helmod may not automatically recycle the output." style="max-width: 100%; height: auto; cursor: zoom-in;" onclick="document.getElementById('charcoal-dialog').showModal()" />
  <div style="font-style: italic; font-size: 0.95em; margin-top: 0.5em;">
    Ctrl+Click on Charcoal in Matrix Mode if it’s both produced and consumed in the block, since Helmod may not recycle outputs automatically.
  </div>
</div>

<dialog id="charcoal-dialog" style="padding:0; border:none; background:transparent;" onclick="if(event.target === this) this.close()">
  <div style="background:white; border-radius:8px; box-shadow:0 2px 16px rgba(0,0,0,0.3); padding:1em; text-align:center;">
    <img src="/images/charcoal_using_slag_1.png" alt="Charcoal in Matrix Mode" style="max-width:90vw; max-height:80vh;" />
    <div style="margin-top:0.5em; font-style:italic; font-size:1em;">Click anywhere outside the image to close.</div>
  </div>
</dialog>

When working with recipes that recycle outputs (like charcoal):

1. Enable matrix mode.
2. Temporarily disable output product filtering, then Ctrl+Click on Charcoal.
3. Re-enable filtering if needed.
4. Add another basic resource (e.g., water).
5. Use Ctrl+Click or Shift+Click on the item to recycle it.
6. Ctrl+Click the output to tell Helmod to use the recipe for that specific output, unless using Matrix Solver.

## Helmod Hotkeys

Helmod includes several shortcuts to make managing production easier:

- **Ctrl+Click / Shift+Click:** In matrix mode, use these to specify dependencies or exclude items/recipes from calculations.
- **Toggle Matrix Mode:** Press `M` to switch matrix mode on or off.
- **Toggle Filters:** Press `F` to show or hide filters.
- **Ctrl+Mouse Wheel:** Zoom in and out in matrix mode.
- **Ctrl+Z / Ctrl+Y:** Undo or redo your changes.
- **Ctrl+C / Ctrl+V:** Copy and paste parts of your design.

---

[Helmod on Factorio Mods Portal](https://mods.factorio.com/mod/helmod)
