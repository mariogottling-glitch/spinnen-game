# Design QA — Main Menu Variant 1

## Evidence

- Source visual truth: `assets/ui/menu/main-menu-variant-1.png`
- Source pixels: 853 × 1844
- Implementation screenshot: `artifacts/start-menu-current.png`
- Implementation pixels: 540 × 960
- Design viewport: 1080 × 1920 portrait
- Capture density: 0.5 relative to the design viewport
- Normalization: source center-cropped with aspect-cover to 1080 × 1920; implementation capture scaled from 540 × 960 to 1080 × 1920
- State: initial main menu, no submenu open
- Full-view comparison: `artifacts/menu-qa/full-comparison.png`
- Focused controls comparison: `artifacts/menu-qa/controls-comparison.png`

## Findings

No actionable P0, P1, or P2 differences remain.

- Fonts and typography: the illustrated title and German control labels are preserved directly from the selected visual; hierarchy, wrapping, and optical weight match.
- Spacing and layout rhythm: the source is center-cropped consistently for the 9:16 Godot viewport. Hero, logo, primary action, and both secondary controls retain the selected proportions and alignment.
- Colors and visual tokens: emerald forest, ivory logo, honey-gold CTA, warm highlights, and dark organic controls match the source without replacement gradients or generic panels.
- Image quality and asset fidelity: the selected generated artwork is used as a project-owned raster asset. The Godot capture retains detail, crop, sharpness, and contrast at the intended mobile size.
- Copy and content: “WEB WEAVER”, “JAGD BEGINNEN”, “SO SPIELST DU”, and “EINSTELLUNGEN” are present once and remain legible.
- Affordances: the illustrated CTA and charms have matching real Godot touch regions plus hover/pressed highlight states. Existing Anleitung and Einstellungen flows remain connected.

## Comparison History

1. Initial normalized comparison exposed an evidence-preparation error: the source crop was top-aligned while Godot correctly used a centered aspect-cover crop. This was not an implementation defect.
2. The comparison source was corrected to centered aspect-cover. Post-fix evidence in `full-comparison.png` shows the implementation and selected target aligned across all major regions.
3. A focused control crop was corrected for the implementation capture’s 0.5 density. `controls-comparison.png` confirms matching CTA and secondary-control positions.

## Verification

- Gameplay smoke test: passed (`GAMEPLAY_SMOKE_TEST_OK`)
- Main-menu render capture: passed (`MENU_VISUAL_CAPTURE_OK`)
- Primary interaction paths tested: start/continue, Anleitung open/close, Einstellungen open/close, reduced-motion toggle, return to game
- Runtime parse/import errors: none

## Follow-up Polish

- P3: the Anleitung and Einstellungen overlay art can receive the same organic shrine treatment in a later iteration; these states were not part of the selected main-screen reference.

final result: passed
