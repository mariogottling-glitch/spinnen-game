# Web Weaver AI Asset Manifest

Generated with the built-in ImageGen tool from the rules in `design.md`.

## `backgrounds/forest-morning-v1.png`

Use case: stylized-concept. Premium portrait mobile-game environment for Web
Weaver. Early-morning miniature forest with layered leaves, branches, moss,
dew, pollen and warm sun rays. The central 65 percent remains calm and open for
the dynamic web. Modern minimal 2D illustration with subtle painterly gradients,
a slightly tilted top-down camera and this palette: `#2F6B45`, `#214233`,
`#6DAE5B`, `#F8F5EB`, `#F4C556`, `#7DC7E8`. No UI, text, characters, insects,
web, neon, pixel art, 3D-render look, harsh contrast or watermark.

## `sprites/spider-v2.png`

Use case: stylized-concept. Main playable character sprite on a flat magenta
chroma background for removal. One full-body spider from a slightly tilted
top-down camera: warm-orange rounded abdomen, honey-gold head, soft fluffy
surface, thin curved legs and expressive cream eyes. Curious, diligent, slightly
clumsy and brave, like a tiny craftsperson. Premium minimal 2D mobile-game
illustration with a readable silhouette at small size. No scenery, shadow, web,
extra insects, text, horror anatomy, childish mascot treatment, pixel art,
3D-render look or watermark.

The final `v2` PNG uses local chroma removal with soft matte, despill and a
one-pixel edge contraction.

## `sprites/spider-crawl-sheet-v1.png`

Use case: production asset. A 2 x 2 sprite sheet derived from `spider-v2` with
four alternating contact and passing poses. Identity, camera, body scale,
palette, lighting, and facial expression remain fixed while opposite leg groups
change position. Generated against solid magenta and converted locally to alpha
with a soft matte, despill, and one-pixel edge contraction.

## `sprites/spider-jump-sheet-v1.png`

Use case: production asset. A 2 x 2 sprite sheet derived from `spider-v2` with
anticipation crouch, takeoff, tucked airborne pose, and landing pose. Identity,
camera, palette, and facial expression remain fixed. Generated against solid
magenta and converted locally to alpha with a soft matte, despill, and one-pixel
edge contraction.

## `sprites/fly-v1.png`

Use case: stylized-concept. Common forest-fly sprite on a flat magenta chroma
background for removal. Slightly tilted top-down, compact dark-moss body,
illustrated cream wings and restrained honey/sky accents. Designed as the
smallest, most common one-XP prey with a clear silhouette at roughly 32 pixels.
No scenery, web, spider, extra insects, text, cartoon face, 3D-render look,
pixel art or watermark.

## `sprites/bee-v1.png`

Use case: stylized-concept. Uncommon valuable bee sprite on a flat magenta
chroma background for removal. Slightly tilted top-down, warm honey body,
dark-moss bands and four simplified cream wings. Designed as a faster, rarer
six-XP target with a clear silhouette at roughly 40 pixels. No scenery, web,
spider, extra insects, text, mascot face, 3D-render look, pixel art or watermark.

## `sprites/moth-v2.png`

Use case: stylized-concept. Common catchable moth sprite on a flat magenta chroma
background for removal. One complete moth in a neutral flying pose, slightly
tilted top-down, with warm-cream wings, honey markings, dark-moss body details
and tiny sky-blue accents. Premium minimal 2D mobile-game illustration with a
clear silhouette at 45 pixels. No scenery, flowers, web, spider, extra insects,
text, cartoon face, pixel art, 3D-render look or watermark.

The final `v2` PNG uses local chroma removal with soft matte, despill and a
one-pixel edge contraction.

## Upgrade card illustrations

`ui/upgrade-silk-v1.png`, `ui/upgrade-sticky-v1.png`, and
`ui/upgrade-speed-v1.png` are individual production assets derived from the
selected Web-Deck level-up mockup. They depict a golden silk spool, a blue
dew-covered web, and three fast orange spider legs. Each was generated without
text or card background against solid magenta, then converted locally to RGBA
with soft matte, despill, and validated transparent corners.

The selected no-spider visual target is archived as
`artifacts/upgrade-web-deck-target-v1.png`.

## `ui/shelter-leaf-v1.png`

Generated with the built-in image generation tool as a premium mobile-game
environment prop. The asset depicts one naturally curled green autumn leaf,
stitched and wrapped with pale spider silk, forming a cozy organic pocket with
a small dark entrance and subtle amber interior glow. The prompt explicitly
excluded envelopes, houses, geometric icons, UI containers, rings, text,
characters, and scenery. The supplied frost-phase screenshot was used only as
a style and palette reference.

The source was generated against a perfectly flat magenta chroma background and
converted locally to RGBA with the imagegen skill's soft-matte and despill
workflow. `ui/shelter-leaf-source-v1.png` preserves the generated chroma source.

## Web-thread textures

`web/thread-natural-v1.png`, `web/thread-reinforced-v1.png`, and
`web/thread-sticky-v1.png` are stretchable horizontal game textures generated
with the built-in ImageGen tool. Their prompts specify uninterrupted strands
running through both image edges: delicate pearl microfibers for normal silk,
a tight ivory-and-honey braid for reinforced silk, and silvery-cyan fibers with
small dew beads for sticky silk. `web/thread-knot-v1.png` is a compact radial
silk rosette with a warm honey center for junctions and endpoints.

The source images used flat green or magenta chroma backgrounds. They were
converted locally with soft matte and despill, cropped to their visible alpha
bounds, and resized to mobile-friendly 1024 x 64 strips and a 128 x 128 knot.
