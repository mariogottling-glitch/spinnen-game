# Design QA — Fadenschnitt-System

## Evidence

- Source visual truth: `artifacts/fadenschnitt-style-target-v1.png`
- Source pixels: 853 × 1844
- Primary implementation screenshot: `artifacts/contract-selection-current.png`
- Implementation pixels: 540 × 960
- Design viewport: 1080 × 1920 portrait; implementation captured at 0.5 density
- State: Jagdvertragswahl, three randomized contracts, reveal animation complete after 0.55 seconds
- Normalization: both source and implementation were aspect-contained into equal 540 × 960 comparison cells; no device chrome was included
- Full-view comparison: `artifacts/fadenschnitt-contract-comparison-v1.png`
- Global consistency overview: `artifacts/fadenschnitt-implementation-overview-v1.png`
- Creature asset comparison: `artifacts/fadenschnitt-creature-audit-v1.png`
- Target-to-gameplay comparison: `artifacts/fadenschnitt-gameplay-comparison-v2.png`
- Gameplay creature evidence: `artifacts/special-prey-current.png`, `artifacts/brood-build-current.png`, `artifacts/wasp-bite-current.png`

## Findings

No actionable P0, P1, or P2 differences remain.

- Fonts and typography: Barlow Condensed SemiBold reproduces the tall block-print hierarchy of the approved target; Barlow Medium keeps small effect copy readable. No truncation or accidental wrapping is visible.
- Spacing and layout rhythm: the three horizontal dossiers preserve the selected structure, thumb-sized targets and alternating dark/light rhythm. The 9:16 implementation uses slightly shorter cards than the taller Imagegen frame so all persistent controls remain visible.
- Colors and visual tokens: Tannenschwarz, Moos, Flechte, Seide, Spinnenorange and Warnkoralle are used consistently. Risk and reward retain fixed semantic colors across all randomized contracts.
- Image quality and asset fidelity: the beetle, dragonfly and firefly are individual alpha assets in the approved block-print language. Edges remain clean at the capture density and show no magenta fringe. The new menu and gameplay backgrounds share the same cut-paper texture and palette.
- Creature consistency: protagonist, crawl and jump frames, helper spiders, common prey, elite wasp and all three bosses now use native Fadenschnitt alpha assets. The live gameplay captures confirm readable silhouettes against the forest without old painterly lighting.
- Perk consistency: all 29 distinct perk illustrations are fully quantized to the six-color palette in the upgrade screen. Their subject identity remains intact while legacy gloss and off-palette color are removed.
- Copy and content: dynamic contract titles and modifiers remain accurate to the active contract database. The target's sample contracts are not hard-coded; randomization is an intentional product constraint.
- Affordances and interaction: each complete dossier is a real Godot Button. Menu start, Anleitung, Einstellungen, Update, contract choice and upgrade choice signals are covered by the gameplay smoke test.

## Comparison History

1. First implementation pass matched palette and card hierarchy but used a flat background and had no continuous silk signature. This was recorded as P2 visual drift.
2. A real Fadenschnitt forest asset and a transparent continuous-thread asset were added to contract and upgrade overlays.
3. The first thread placement crossed central text and icons. Opacity was reduced and the thread was shifted toward the right edge.
4. The post-fix comparison shows readable content, the intended forest depth and a restrained silk signature. No P0/P1/P2 issue remains.

## Verification

- Gameplay smoke test: passed (`GAMEPLAY_SMOKE_TEST_OK`)
- Main-menu render capture: passed (`MENU_VISUAL_CAPTURE_OK`)
- Contract/gameplay render capture: passed (`WEB_VISUAL_CAPTURE_OK`)
- Upgrade render capture: passed (`UPGRADE_VISUAL_CAPTURE_OK`)
- Primary interactions tested: menu start/continue, Anleitung open/close, Einstellungen open/close, reduced-motion toggle, contract selection, upgrade selection and return to gameplay
- Focused region comparison was not required: at 540 × 960, all contract typography, image edges and card controls are legible in the full-view composite.

## Follow-up Polish

- P3: dedicated native redraws for all 29 perk illustrations can eventually replace the current full-strength six-color normalization; no visible off-palette artwork remains in this pass.
- P3: custom clipped-corner card masks could move the executable cards even closer to the paper-tag silhouette of the style target.

final result: passed
