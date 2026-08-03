class_name UpgradeDatabase
extends RefCounted


static func all() -> Array[Dictionary]:
	return [
		{
			"id": "strong_silk", "title": "STARKE SEIDE", "value": "+20 FADENSTÄRKE",
			"description": "Repariert das Netz und erhöht dauerhaft seine Belastbarkeit.",
			"build": "FESTUNG", "rarity": "common", "max_level": 3, "weight": 10,
			"icon": "strong_silk", "requires": {}
		},
		{
			"id": "elastic_threads", "title": "ELASTISCHE FÄDEN", "value": "-22 % ALTERUNG",
			"description": "Fäden verlieren deutlich langsamer ihre Haltbarkeit.",
			"build": "FESTUNG", "rarity": "common", "max_level": 3, "weight": 10,
			"icon": "elastic_threads", "requires": {}
		},
		{
			"id": "reinforced_knots", "title": "VERSTÄRKTE KNOTEN", "value": "-35 % WINDSCHADEN",
			"description": "Windstöße beschädigen dein Netz wesentlich weniger.",
			"build": "FESTUNG", "rarity": "uncommon", "max_level": 2, "weight": 6,
			"icon": "reinforced_knots", "requires": {"strong_silk": 1}
		},
		{
			"id": "fortress_core", "title": "FESTUNGSKERN", "value": "+35 STÄRKE · -30 % KAMPF",
			"description": "Vollständige Reparatur. Kämpfende Beute richtet weniger Schaden an.",
			"build": "FESTUNG", "rarity": "rare", "max_level": 1, "weight": 2,
			"icon": "fortress_core", "requires": {"strong_silk": 2, "elastic_threads": 1}
		},
		{
			"id": "sticky_web", "title": "KLEBRIGES NETZ", "value": "+18 % FANGZONE",
			"description": "Größere Fangzone und etwas längere Fluchtzeit für Beute.",
			"build": "FALLE", "rarity": "common", "max_level": 3, "weight": 10,
			"icon": "sticky_web", "requires": {}
		},
		{
			"id": "deep_glue", "title": "TIEFER KLEBER", "value": "+18 % FLUCHTZEIT",
			"description": "Getroffene Tiere kämpfen langsamer und bleiben länger hängen.",
			"build": "FALLE", "rarity": "uncommon", "max_level": 3, "weight": 6,
			"icon": "deep_glue", "requires": {"sticky_web": 1}
		},
		{
			"id": "vibration_sense", "title": "SEISMISCHER SINN", "value": "+8 % SELTENE BEUTE",
			"description": "Wertvolle Motten und Bienen erscheinen häufiger.",
			"build": "FALLE", "rarity": "uncommon", "max_level": 2, "weight": 5,
			"icon": "vibration_sense", "requires": {}
		},
		{
			"id": "perfect_ambush", "title": "PERFEKTER HINTERHALT", "value": "+40 % HALTEZEIT",
			"description": "Dein ausgebautes Klebenetz hält selbst schwere Beute lange fest.",
			"build": "FALLE", "rarity": "rare", "max_level": 1, "weight": 2,
			"icon": "perfect_ambush", "requires": {"sticky_web": 2, "deep_glue": 1}
		},
		{
			"id": "quick_legs", "title": "FLINKE BEINE", "value": "+16 % TEMPO",
			"description": "Schnelleres Krabbeln und kürzere Sprünge zur Beute.",
			"build": "JÄGERIN", "rarity": "common", "max_level": 3, "weight": 10,
			"icon": "quick_legs", "requires": {}
		},
		{
			"id": "hunting_instinct", "title": "JAGDINSTINKT", "value": "+30 TAPP-RADIUS",
			"description": "Beute lässt sich leichter auswählen und schneller anspringen.",
			"build": "JÄGERIN", "rarity": "common", "max_level": 3, "weight": 9,
			"icon": "hunting_instinct", "requires": {}
		},
		{
			"id": "critical_capture", "title": "KRITISCHER FANG", "value": "+18 % DOPPELTE BEUTE",
			"description": "Aktiv eingewickelte Tiere können doppelte Nahrung liefern.",
			"build": "JÄGERIN", "rarity": "uncommon", "max_level": 3, "weight": 6,
			"icon": "critical_capture", "requires": {"hunting_instinct": 1}
		},
		{
			"id": "venom_bite", "title": "GIFTBISS", "value": "+1 BOSS-SCHADEN",
			"description": "Jeder Angriff zählt doppelt gegen die Abschlussbeute.",
			"build": "JÄGERIN", "rarity": "rare", "max_level": 1, "weight": 2,
			"icon": "venom_bite", "requires": {"quick_legs": 2, "hunting_instinct": 1}
		},
		{
			"id": "silk_glands", "title": "SEIDENDRÜSEN", "value": "+20 MAXIMALE SEIDE",
			"description": "Erhöht den Vorrat und füllt ihn sofort vollständig auf.",
			"build": "ÖKONOMIE", "rarity": "common", "max_level": 3, "weight": 9,
			"icon": "silk_glands", "requires": {}
		},
		{
			"id": "fine_spinning", "title": "FEINSPINNEN", "value": "-18 % FADENKOSTEN",
			"description": "Neue Verbindungen verbrauchen weniger Seide.",
			"build": "ÖKONOMIE", "rarity": "common", "max_level": 3, "weight": 9,
			"icon": "fine_spinning", "requires": {}
		},
		{
			"id": "recycler", "title": "SEIDEN-RECYCLER", "value": "+30 % SEIDE PRO FANG",
			"description": "Jeder Fang repariert zusätzlich den schwächsten Faden.",
			"build": "ÖKONOMIE", "rarity": "uncommon", "max_level": 3, "weight": 6,
			"icon": "recycler", "requires": {"fine_spinning": 1}
		},
		{
			"id": "architect", "title": "ARCHITEKTIN", "value": "AUTOMATISCHE STÜTZFÄDEN",
			"description": "Neue Knoten verbinden sich kostenlos mit einem nahen Anker.",
			"build": "ÖKONOMIE", "rarity": "rare", "max_level": 1, "weight": 2,
			"icon": "architect", "requires": {"fine_spinning": 2, "silk_glands": 1}
		},
		{
			"id": "armored_knots", "title": "PANZERKNOTEN", "value": "+35 % START-HALTUNG",
			"description": "Neue Fäden beginnen überladen und halten den ersten Treffern länger stand.",
			"build": "FESTUNG", "rarity": "uncommon", "max_level": 2, "weight": 5,
			"icon": "armored_knots", "requires": {"reinforced_knots": 1}
		},
		{
			"id": "emergency_patch", "title": "NOTFALLFLICKEN", "value": "1 FADEN RETTET SICH",
			"description": "Ein gerissener Faden flickt sich regelmäßig automatisch auf 45 %.",
			"build": "FESTUNG", "rarity": "rare", "max_level": 2, "weight": 3,
			"icon": "emergency_patch", "requires": {"strong_silk": 1, "elastic_threads": 1}
		},
		{
			"id": "dew_trap", "title": "TAUFALLE", "value": "+1 MÜCKEN-NAHRUNG",
			"description": "Kleine Mücken liefern mehr Nahrung und deutlich mehr Seide.",
			"build": "FALLE", "rarity": "uncommon", "max_level": 3, "weight": 5,
			"icon": "dew_trap", "requires": {"sticky_web": 1}
		},
		{
			"id": "chain_capture", "title": "KETTENFANG", "value": "+20 % KOMBO-CHANCE",
			"description": "Ein aktiver Fang wickelt mit Glück sofort eine zweite gefangene Beute ein.",
			"build": "FALLE", "rarity": "rare", "max_level": 2, "weight": 3,
			"icon": "chain_capture", "requires": {"sticky_web": 2, "critical_capture": 1}
		},
		{
			"id": "predator_focus", "title": "JÄGERBLICK", "value": "+25 % AKTIV-BELOHNUNG",
			"description": "Selbst angesprungene Beute gibt mehr Nahrung und Erfahrung.",
			"build": "JÄGERIN", "rarity": "uncommon", "max_level": 3, "weight": 5,
			"icon": "predator_focus", "requires": {"quick_legs": 1}
		},
		{
			"id": "silk_dash", "title": "SEIDENSPRINT", "value": "-22 % SPRUNGZEIT",
			"description": "Beutesprünge werden schneller und reparieren den Landefaden.",
			"build": "JÄGERIN", "rarity": "rare", "max_level": 2, "weight": 3,
			"icon": "silk_dash", "requires": {"quick_legs": 1, "hunting_instinct": 1}
		},
		{
			"id": "emergency_reserve", "title": "NOTRESERVE", "value": "+35 SEIDE PRO LEVEL",
			"description": "Bei fast leerem Vorrat öffnet sich einmal je Jagdlevel eine Reserve.",
			"build": "ÖKONOMIE", "rarity": "uncommon", "max_level": 2, "weight": 5,
			"icon": "emergency_reserve", "requires": {"silk_glands": 1}
		},
		{
			"id": "rich_cocoon", "title": "PRACHTKOKON", "value": "+50 % BOSS-BEUTE",
			"description": "Abschlussmotten geben erheblich mehr Nahrung, XP und Seide.",
			"build": "ÖKONOMIE", "rarity": "rare", "max_level": 2, "weight": 3,
			"icon": "rich_cocoon", "requires": {"recycler": 1, "vibration_sense": 1}
		},
		{
			"id": "brood_nest", "title": "BRUTNEST", "value": "+1 HELFERSPINNE",
			"description": "Eine sichtbare Jungspinne patrouilliert dein Netz und hilft bei kleinen Reparaturen.",
			"build": "BRUT", "rarity": "common", "max_level": 3, "weight": 9,
			"icon": "brood_nest", "requires": {}
		},
		{
			"id": "silk_menders", "title": "FLICKENLÄUFER", "value": "+8 REPARATUR",
			"description": "Die Brut repariert regelmäßig den schwächsten aktiven Faden.",
			"build": "BRUT", "rarity": "uncommon", "max_level": 3, "weight": 6,
			"icon": "silk_menders", "requires": {"brood_nest": 1}
		},
		{
			"id": "young_hunters", "title": "JUNGJÄGER", "value": "AUTO-FANG ALLE 7 S",
			"description": "Eine Helferspinne wickelt regelmäßig festgehaltene normale Beute ein.",
			"build": "BRUT", "rarity": "uncommon", "max_level": 2, "weight": 5,
			"icon": "young_hunters", "requires": {"brood_nest": 1}
		},
		{
			"id": "swarm_instinct", "title": "SCHWARMTRIEB", "value": "+12 % TEMPO · +1 BRUT",
			"description": "Der ganze Schwarm bewegt sich schneller und eine weitere Jungspinne schlüpft.",
			"build": "BRUT", "rarity": "rare", "max_level": 2, "weight": 3,
			"icon": "swarm_instinct", "requires": {"brood_nest": 2, "quick_legs": 1}
		},
		{
			"id": "spider_queen", "title": "SPINNENKÖNIGIN", "value": "+2 BRUT · BOSS-BISSE",
			"description": "Die Königin verstärkt alle Helfer; sie beißen nun auch gefangene Abschlussbeute.",
			"build": "BRUT", "rarity": "rare", "max_level": 1, "weight": 2,
			"icon": "spider_queen", "requires": {"brood_nest": 3, "silk_menders": 1, "young_hunters": 1}
		}
	]
