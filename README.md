# Web Weaver

Android-first 2D prototype of the one-tap web-building mechanic described in
[`design.md`](design.md) and [`gameplay.md`](gameplay.md).

## Current prototype

- Portrait layout at a 1080 × 1920 logical resolution
- Touch and mouse input
- A cycling preview anchor
- One tap creates a new thread and makes the spider jump
- Automatic graph movement along connected threads
- Four-frame leg animation while crawling, paced by movement speed
- Four-stage jump animation with arc, airborne shadow, squash, and landing bounce
- Flying insects with thread intersection and capture logic
- Three visual insect tiers: fly, moth, and bee
- Food, experience, multi-stage hunt levels, and three random upgrade choices
- Illustrated Web-Deck level-up cards with staggered reveal and press feedback
- Data-driven database with 16 upgrades, rarity, levels, prerequisites, and four builds
- Fortress, trap, hunter, and silk-economy synergies with real gameplay effects
- Limited silk resource with distance-based thread costs and capture recovery
- Permanent silk and XP progress bars with slower level pacing
- Thread health, aging, wind damage, and global web integrity
- Food objectives followed by a multi-hit boss moth that completes each level
- Increasing hunt targets while the web and chosen build persist between levels
- Run restart after complete web collapse
- AI-generated forest, spider, insects, and spider animation sheets based on `design.md`
- Rounded premium HUD and upgrade-card styling

AI asset prompts and processing notes are recorded in
[`assets/ASSET_MANIFEST.md`](assets/ASSET_MANIFEST.md).

## Run locally

1. Install Godot 4.x.
2. Import `project.godot` in the Godot Project Manager.
3. Run the main scene.

Mouse clicks emulate taps on desktop. For Android, install Godot's Android export
template and configure an Android SDK/JDK in the editor before exporting.

During desktop development, press `U` to open the upgrade selection immediately.
Press `B` to summon the current level's boss moth immediately for testing.

## Next vertical-slice milestones

1. Tune movement, anchor timing, capture rate, and run pacing from playtests.
2. Add several insects with distinct movement and weight.
3. Add visible thread tension and local break animations.
4. Replace generic upgrades with the first real build synergies.
5. Produce the first coherent art-direction pass.
