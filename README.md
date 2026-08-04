# Web Weaver

Android-first 2D prototype of the one-tap web-building mechanic described in
[`design.md`](design.md) and [`gameplay.md`](gameplay.md).

## Current prototype

- Portrait layout at a 1080 × 1920 logical resolution
- Touch and mouse input
- Three stable, directly tappable web targets with visible silk costs
- Tactical target labels distinguish short, long, and trap-closing connections
- Automatic graph movement along connected threads
- Four-frame leg animation while crawling, paced by movement speed
- Four-stage jump animation with arc, airborne shadow, squash, and landing bounce
- Flying insects with thread intersection and capture logic
- Nine distinct illustrated creature sprites, from gnats and moths to specialist prey and bosses
- Food, experience, multi-stage hunt levels, and three random upgrade choices
- Illustrated Web-Deck level-up cards with staggered reveal and press feedback
- Data-driven database with 29 upgrades, rarity, levels, prerequisites, and five builds
- Visible brood build with animated helper spiders, repairs, auto-wrapping, and queen attacks
- Fortress, trap, hunter, and silk-economy synergies with real gameplay effects
- Limited silk resource with distance-based thread costs and capture recovery
- Permanent silk and XP progress bars with slower level pacing
- Thread health, aging, wind damage, and global web integrity
- Textured multi-fiber silk, reinforced braids, sticky dew strands, and illustrated web knots
- Food objectives followed by a rotating three-boss cycle with an active timing-based bite duel
- Living Web geometry: triangular capture pockets and self-repairing four-way silk hearts
- Calm early encounter pacing without flight-corridor overlays
- Player-triggered web pluck with escalating vibration, better prey, combos, and extra thread strain
- Three-of-six hunt contracts before every level, each changing risk, tempo, rewards, and prey mix
- Armored beetles, multi-pass dragonflies, and calming fireflies with distinct counterplay
- Unique production art for beetle, dragonfly, firefly, Wasp Queen, Titan Beetle, and Razor Hornet
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

## Android test channel

The current installable APK is published as a GitHub Release:

`https://github.com/mariogottling-glitch/spinnen-game/releases/latest/download/web-weaver-android.apk`

The `UPDATE` button in the main menu opens the latest GitHub Release page, where
the current APK can be downloaded without a stale file redirect. Android then
asks the player to confirm the downloaded APK update. Every published test
build must keep the package ID `com.mariogottling.webweaver`, use a higher version
code, and be signed with the same keystore so Android recognizes it as an update.

During desktop development, press `U` to open the upgrade selection immediately.
Press `B` to summon the current level's rotating miniboss immediately for testing.

## Next vertical-slice milestones

1. Tune Living Web rewards, vibration decay, and hunt pacing from Android playtests.
2. Add a second geometric glyph and tune the three specialist insects from mobile playtests.
3. Add visible local thread tension and break animations.
4. Add optional hunt contracts that remix risk and rewards between levels.
