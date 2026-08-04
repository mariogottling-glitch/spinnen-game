# design.md
# Project: Web Weaver
Version: 1.0
Status: Living Design Document

---

# 1. Vision

**Web Weaver** ist ein entspannendes, aber überraschend tiefes Roguelite-Mobilegame, bei dem der Spieler eine kleine Spinne begleitet.

Die Besonderheit:

Der Spieler steuert **nicht die Spinne**, sondern lediglich **den nächsten Sprung**.

Mit jedem Sprung spannt die Spinne einen neuen Faden und erschafft Stück für Stück ein immer komplexeres Netz.

Das Netz ist gleichzeitig:

- Spielfeld
- Verteidigung
- Ressource
- Fortschritt
- Kunstwerk

Am Ende jeder Runde soll der Spieler sein fertiges Netz ansehen und denken:

> "Das habe ich gebaut."

---

# 2. Core Pillars

## 1. Easy to Learn

Ein Finger.

Ein Tap.

Keine komplizierte Steuerung.

## 2. Emergent Gameplay

Aus wenigen Regeln entstehen viele Möglichkeiten.

Jede Runde entwickelt sich anders.

## 3. Cozy statt Stress

Kein hektisches Bullet Hell.

Kein permanenter Zeitdruck.

Das Spiel lebt von Flow.

## 4. Das Netz ist der Star

Nicht die Spinne.

Nicht die Gegner.

Das Netz ist der eigentliche Hauptcharakter.

---

# 3. Zielgruppe

- Fans von Roguelites
- Casual Gamer
- Spieler von Vampire Survivors
- Luck be a Landlord
- Mini Motorways
- Alto's Odyssey
- Monument Valley

Alter:

10–45 Jahre

Sessions:

3–15 Minuten

---

# 4. Art Direction

## Gesamtstil: Fadenschnitt

**Fadenschnitt** ist die verbindliche visuelle Identität von Web Weaver.

- moderne 2D-Siebdruck- und Scherenschnittoptik
- große, bewusst vereinfachte Silhouetten
- leicht unperfekte Druckkanten statt glatter KI-Oberflächen
- sparsame Rasterpunkte und minimale Farbversätze
- zwei bis drei flache Papierebenen statt gemalter Tiefe
- eine durchgehende Seidenlinie als wiederkehrendes Markenelement

Die Optik ist illustrativ, organisch und hochwertig, aber weder realistisch noch
ornamental. Sie darf charmant sein, ohne kindlich oder maskottchenhaft zu wirken.

Ausgeschlossen sind fotorealistische Wälder, glänzende 3D-Renderings, gemaltes
Fantasy-Gold, pseudo-mittelalterliche Rahmen, Lichtstrahlen, Bokeh und dekorative
Details ohne spielerische Funktion.

---

# 5. Inspirationsquellen

## Grafik

Die Referenzen dienen nur für Klarheit, Rhythmus und mobile Lesbarkeit. Web Weaver
kopiert keine fremde Formensprache. Maßgeblich sind das eigene Sechsfarbensystem,
die Fadenschnitt-Silhouetten und die durchgehende Seidenlinie.

## Animation

Ori

Hollow Knight

Spiritfarer

---

# 6. Farbwelt

## Verbindliche Sechsfarbenpalette

- **Tannenschwarz** `#102A24`: Hintergrund, maximale Tiefe
- **Moos** `#315A45`: Flächen, Karten, Weltboden
- **Flechte** `#A7C46A`: Fortschritt, positive Zustände, Belohnungen
- **Seide** `#F2E8D5`: Text, Fäden, helle Karten
- **Spinnenorange** `#F28C28`: Charakter, Primäraktion, Energie
- **Warnkoralle** `#E3564A`: Risiko, Schaden, Gefahr

Zusätzliche Farben sind für Produktionsassets nicht erlaubt. Transparenz und
unterschiedliche Rasterdichten dürfen die sechs Grundfarben abstufen.

---

# Farbphilosophie

Hoher Hell-Dunkel-Kontrast sorgt auf kleinen Displays für Lesbarkeit. Tiefe entsteht
durch überlagerte Flächen, Raster und kleine versetzte Schatten – nicht durch
Farbverläufe oder realistische Beleuchtung.

---

# 7. Hintergrund

Der Hintergrund besteht aus wenigen großen, asymmetrischen Schnittformen.

## Ebene 1

Tannenschwarze und moosgrüne Blattsilhouetten

## Ebene 2

Äste

## Ebene 3

Moos

## Ebene 4

Spinnennetz

## Ebene 5

Partikel

Parallax Effekt auf allen Ebenen.

---

# 8. Atmosphäre

Frühmorgens.

Tau.

Leichter Wind.

Sonnenstrahlen.

Pollen.

Vögel im Hintergrund.

Kein Regen (später möglich).

---

# 9. Die Spinne

## Persönlichkeit

Neugierig

Fleißig

Etwas tollpatschig

Charmant

Mutig

Sie wirkt wie ein kleiner Handwerker.

---

## Körper

Großer runder Körper

Kleiner Kopf

Große Augen

Kleine Pupillen

Flauschige Oberfläche

Dünne Beine

Warme Farben

---

## Animationen

Idle

- Beine putzen
- Umsehen
- Gähnen
- Wackeln
- Kopf neigen

Emotionen

Freude

Schreck

Neugier

Müdigkeit

Stolz

---

# 10. Netz

Das Netz muss wunderschön aussehen.

Eigenschaften

Leicht transparent

Feine Lichtreflexe

Leicht elastisch

Schwingt minimal

Ankerpunkte leuchten

Umsetzung im Prototyp

- Normale Seide besteht sichtbar aus mehreren leicht unregelmäßigen Einzelfasern.
- Starke Seide wechselt auf eine dichtere, warm-golden verflochtene Textur.
- Klebrige Seide zeigt kühle Glanzfasern und kleine Tautropfen.
- Kreuzungen erhalten eigene gewickelte Seidenknoten statt einfacher Kreise.
- Sinkende Fadenhaltbarkeit reduziert die Deckkraft der Textur, ohne die Lesbarkeit zu verlieren.

Je dichter das Netz wird,

desto beeindruckender wirkt es.

---

# 11. Pflanzenwelt

Stilisierte Natur.

Keine realistischen Assets.

Elemente

Farne

Moos

Blätter

Pilze

Blumen

Äste

Baumrinde

Gräser

Alle bewegen sich leicht.

---

# 12. Insekten

Fliege

Mücke

Marienkäfer

Motte

Biene

Käfer

Schmetterling

Später

Hornisse

Libelle

Nachtfalter

Ameisen

Jedes Tier besitzt

eigene Flugmuster

eigene Größe

eigene Geschwindigkeit

---

# 13. Partikel

Pollen

Staub

Spinnwebenfasern

Tau

Blätter

Lichtpunkte

Kleine Samen

Immer dezent.

Nie übertrieben.

---

# 14. Licht

Warme Sonne.

God Rays.

Leichte Bloom.

Reflexe auf Fäden.

Kein Neon.

---

# 15. Kamera

Top Down

ca. 15°

Sehr ruhige Bewegungen

Leichte Zooms

Kein Wackeln

---

# 16. UI Design

Minimal, kontrastreich und sofort lesbar.

- großzügige Abstände und klare Linksausrichtung
- große flache Flächen mit leicht angeschnittenen oder kleinen Ecken
- maximal zwei Schrifttypen: Barlow Condensed für Titel und Barlow für Fließtext
- keine Verläufe, Glasflächen, Metallrahmen oder Fantasy-Ornamente
- Warnkoralle ausschließlich für Risiken und Schaden
- Flechte beziehungsweise Spinnenorange ausschließlich für Fortschritt und Aktion

---

## HUD

Das HUD verwendet eine kompakte tannenschwarze Statusfläche mit einer
spinnenorangen Unterkante. Fäden, Seide, Nahrung, XP, Netz-Integrität, Jagdziel,
Build und aktiver Vertrag bleiben ohne Symboldekoration direkt lesbar.

---

# 17. Upgrade Karten

Große Karten mit dunklem und hellem Wechselrhythmus, kleinen Ecken und versetztem
Flächenschatten. Illustrationen werden durch die Fadenschnitt-Palette reduziert.
Titel, Effektwert und ein kurzer Wirkungssatz bilden die feste Hierarchie.

Einfarbige Build-Bänder am Kartenfuß ersetzen glänzende oder mehrfarbige Ribbons.
Die drei Karten dürfen leicht versetzt sein, werden aber nicht ornamental gefächert.

---

# 18. Buttons

Groß, flach und mit kleinen Ecken.

Primäraktionen verwenden Seide als Fläche, Spinnenorange als Kontur und
Tannenschwarz als Text. Sekundäraktionen bleiben tannenschwarz mit Seidenkontur.
Beim Tippen wechselt die Fläche kurz auf Spinnenorange; ein kleiner Scale-Impuls
ersetzt Glanz, Verlauf und Android-Fokusrahmen.

---

# 19. Icons

Alle Icons

Flache Blockdruck-Silhouetten mit maximal drei Innenflächen

keine 3D-, Glanz- oder realistisch gemalten Icons

keine Emojis im Spiel

klare Symbolsprache

---

# 20. Animation Style

Alle Animationen weich.

Viele Ease In Out Kurven.

Niemals hektisch.

Micro Animations überall.

---

# 21. Audio

Leichte Naturmusik

Akustische Instrumente

Marimba

Kalimba

Holz

Leichte Streicher

Keine epische Musik.

Soundeffekte

kleines "Plopp"

leichtes Kleben

Fäden spannen

Insekten summen

Wind

---

# 22. UX Prinzipien

Alles mit einer Hand spielbar.

Große Buttons.

Maximal drei Entscheidungen gleichzeitig.

Keine langen Texte.

Keine Tutorials voller Text.

Learning by Playing.

---

# 23. Technische Art Direction

Alle Assets müssen konsistent erzeugbar sein.

Bevorzugt

SVG

Vektor

Flat Shapes

2D

Keine Pixelart.

Keine 3D Modelle notwendig.

Animation

Rive

Lottie

CSS

Godot AnimationPlayer

---

# 24. KI Workflow

KI darf Rohmaterial erzeugen, definiert aber niemals den Stil.

Jeder Prompt muss Palette, Fadenschnitt-Medium, Perspektive, Silhouette und
Ausschlussliste enthalten. Ein Asset wird danach freigestellt, auf sechs Farben
reduziert, auf mobile Lesbarkeit geprüft und erst dann animiert oder eingebaut.

Generische Fantasy-Renderings, dekorative Details, Pseudo-Gold und nicht
reproduzierbare Einzelstile werden verworfen – auch wenn das Einzelbild technisch
hochwertig ist.

---

# 25. Design Regeln

Jedes Objekt besitzt

- eine klare Silhouette
- wenige große Innenformen
- ausschließlich Farben der Sechsfarbenpalette
- leicht unperfekte Druckkanten oder Raster
- höchstens zwei flache Tiefenebenen
- eine kurze, lesbare Animation

Kein Asset darf statisch wirken.

---

# 26. Markenidentität

Das Spiel soll sich anfühlen wie

"eine kleine lebendige Welt"

nicht wie ein Level.

Die Natur lebt.

Alles bewegt sich.

Alles reagiert.

---

# 27. Emotionen

Der Spieler soll empfinden:

🌿 Ruhe

🕸 Kreativität

😊 Freude

✨ Überraschung

💡 Cleverness

🎯 Flow

---

# 28. Qualitätsanspruch

Jeder Screen muss aussehen, als könnte er direkt als Screenshot im App Store verwendet werden.

Kein Platzhalter-Look.

Keine generischen Mobile-Assets.

Keine zusammengewürfelten KI-Stile und kein erkennbarer „AI-Slop“-Look.

Jedes neue Asset muss sich nahtlos in den bestehenden Stil einfügen.

---

# 29. Definition of Done

Ein neues Asset gilt erst als fertig, wenn:

- es dem definierten Stil entspricht
- es auf mobilen Geräten klar lesbar ist
- es animierbar ist
- es farblich zur Palette passt
- es mit allen bestehenden Assets harmoniert
- es auch ohne Text verständlich ist

---

# 30. Design-Mantra

> Weniger Details.
>
> Mehr Persönlichkeit.
>
> Mehr Bewegung.
>
> Mehr Atmosphäre.
>
> Das Netz ist das Kunstwerk.
>
> Die Spinne ist sein Architekt.

---

# 31. Hauptmenü

Der Einstieg ist der deutlichste Markenanker des Spiels und verwendet dieselbe
Fadenschnitt-Waldwelt wie das Gameplay.

- Die animierbare Spinne ist der zentrale Charakteranker.
- „Web Weaver“ bleibt als klarer, international verständlicher Spieltitel bestehen.
- Der Seiden-Primärbutton mit oranger Kontur startet die Jagd beziehungsweise setzt sie fort.
- Anleitung und Einstellungen sind visuell untergeordnet, aber gut erreichbar.
- Das HUD und alle Spielobjekte werden im Hauptmenü vollständig ausgeblendet.
- Über den Menüknopf im HUD kann eine laufende Runde unterbrechungsfrei verlassen
  und anschließend mit „Weiterspielen“ fortgesetzt werden.
- Die Einstellung „Bewegungseffekte“ ermöglicht direkte Übergänge ohne Menütweens.

Die Menüstruktur ist für spätere Ergänzungen wie Spielstand, Perk-Sammlung,
tägliche Aufgaben oder Shop vorbereitet, ohne diese Funktionen vorzutäuschen.

---

# 32. Living-Web-Feedback

Aktive Netzfunktionen bleiben Teil der Waldwelt und werden nicht als große
Interface-Flächen über die Karte gelegt.

- Fangtaschen erhalten nur eine transparente kühlblaue Fläche, eine feine Kontur
  und ein kleines Glyphenzeichen im Schwerpunkt.
- Seidenherzen pulsieren warmgolden direkt auf dem jeweiligen Knoten.
- Flugkorridore sind dünne, gestrichelte Linien mit einem Richtungspfeil am Rand;
  ihre Farbe folgt der Wertigkeit der Beute.
- Die Vibrationsanzeige verwendet eine kurze Zustandsbezeichnung: ruhig, aktiv
  oder gefährlich. Orange bleibt der Warnstufe vorbehalten.
- Der Knopf „Netz zupfen“ sitzt griffnah am unteren rechten Rand und erscheint
  erst, sobald ein funktionierendes Netz mit mindestens drei Fäden existiert.

Alle Effekte pulsieren langsam und mit niedriger Deckkraft. Das Netz bleibt das
Kunstwerk; die Systeminformation erklärt es, ohne die Illustration zu verdecken.

---

# 33. Jagdverträge und Spezialbeute

Die Vertragsauswahl verwendet drei untereinander vernähte, horizontale
Beute-Dossiers. Jede Zeile lässt sich mit dem Daumen vollständig antippen und
trennt Titel, Risiko, Belohnung und Spezialtier ohne Erklärungstext. Warnkoralle
kennzeichnet immer das Risiko, Flechte immer die Belohnung. Textglyphen und
geometrische Siegel werden nicht als Ersatz für Tiergrafiken verwendet.

Spezialtiere bleiben auch bei hoher Bewegung unterscheidbar:

- Panzerkäfer: dunkle breite Schalenform, helle Geweihe und große Flechtenmuster.
- Libelle: langes Segmentprofil und vier orangefarbene Blockdruckflügel.
- Glühwürmchen: kompakte Flügelform und großer seidenheller Hinterleib.

Name und Effektfarbe erscheinen nur dezent am Tier. Flugkorridor, Silhouette und
Bewegungsmuster sollen die Identifikation im späteren Spiel weitgehend ohne Text ermöglichen.

---

# 34. Fadenschnitt-System und globale Anwendung

Die Stilregeln gelten ohne Ausnahme für Hauptmenü, HUD, Vertragswahl,
Upgrade-Auswahl, Anleitung, Einstellungen, Levelabschluss, Spielwelt, normale
Beute, Spezialtiere und Bosse.

## Wiederkehrende Signaturen

- eine durchgehende helle Seidenlinie verbindet Flächen oder führt zum Fokus
- orangefarbene Akzente gehören zur Spinne und zur aktiven Handlung
- Karten wechseln zwischen Moos und Seide, statt drei beliebige Farben zu nutzen
- asymmetrische Versätze erzeugen Rhythmus; Ornamente sind nicht nötig
- Rasterpunkte liegen in der Illustration, nicht als Filter über lesbare Schrift

## Produktionsprüfung

Ein neuer Screen oder ein neues Asset wird abgelehnt, wenn er auch in einem
beliebigen Fantasy-Mobilegame vorkommen könnte. Er muss ohne Logo an Palette,
Schnittkante, Raster und Seidenlinie als Web Weaver erkennbar sein.

Die freigegebene visuelle Referenz liegt unter
`artifacts/fadenschnitt-style-target-v1.png`. Die ausführbaren Referenzstände für
Menü, Verträge, Upgrades und Gameplay werden in `artifacts/` gepflegt.

## Native Kreaturenbibliothek

Alle im laufenden Spiel sichtbaren Kreaturen verwenden native Fadenschnitt-Assets.
Alte weich gemalte oder halb-dreidimensionale Sprites dürfen nicht mehr im Renderer
referenziert werden.

- Die Hauptspinne besitzt ein eigenes Standbild sowie getrennte 2×2-Sheets für
  Krabbeln und Springen. Körper, Markierung, Perspektive und Größe bleiben in
  jedem Frame stabil.
- Fliege, Motte und Biene sind kleine, einfache Silhouetten mit höchstens drei
  Papierlagen. Ihre Wertigkeit wird zuerst durch Form und Tempo, nicht durch Farbe erklärt.
- Panzerkäfer, Libelle und Glühwürmchen verwenden dieselben Illustrationen in
  Vertrag und Gameplay, damit Auswahl und spätere Begegnung eindeutig zusammengehören.
- Elitewespe, Wespenkönigin, Titan-Käfer und Klingenhornisse besitzen jeweils eine
  eigenständige Boss-Silhouette. Eine eingefärbte Wiederverwendung ist nicht zulässig.
- Helferspinnen verwenden verkleinerte Krabbelframes der Hauptspinne; der Build
  bleibt dadurch als zusammengehörige Brut lesbar.
- Auch das Android-Appsymbol verwendet die native Fadenschnitt-Spinne.

Perk-Illustrationen bleiben individuell. Solange ein Motiv noch aus der ersten
Assetgeneration stammt, wird es im Upgrade-Screen vollständig auf die sechs
Fadenschnittfarben quantisiert. Dadurch dürfen weder Fremdfarben noch Glanz- oder
3D-Licht im sichtbaren Spiel verbleiben.

---

# 35. Nutzerführung und Run-Dramaturgie

Das Interface zeigt Systeme nicht mehr alle gleichzeitig, sondern nach Relevanz.

- Im ersten Jagdlevel führt ein kompakter Vier-Schritt-Banner durch Sprung,
  Fangtasche, aktiven Fang und Netz-Zupfen.
- Vibration erscheint erst, wenn das Netz gezupft werden kann oder tatsächlich
  unruhig ist. Netzglyphen erscheinen erst, wenn mindestens eine Form aktiv ist.
- Vertrag und vollständige Build-Zusammenfassung bleiben in Auswahl- und
  Ergebniszuständen sichtbar, statt dauerhaft die Spielfläche zu belegen.
- Der erste Boss wartet auf zwei Upgrade-Entscheidungen. XP-Aufstieg und
  Jagdabschluss dürfen nicht mehr denselben Moment beanspruchen.
- Jede Upgrade-Auswahl besitzt ein kostenloses Neumischen pro Jagdlevel. Eine
  sanfte Pfadgewichtung macht bewusste Builds möglich, ohne Zufall auszuschalten.
- Der Levelabschluss ist eine eigene Fadenschnitt-Karte mit Netzrang,
  Vertragsresultat, Build und eindeutigem Weiter-Button.
- Ein vollständiger Run umfasst fünf Jagdgebiete und endet mit einer sichtbaren
  Auswertung. Kollaps und erfolgreicher Abschluss verwenden dieselbe klare
  Ergebnisstruktur.

## Ruhe vor Dichte

Die mobile Spielfläche darf nie mehr als drei gleichzeitig reaktionspflichtige
Ziele zeigen. Kleine automatische Beute zählt nicht dazu. Neue Anflüge werden
zurückgehalten, solange bereits mehrere Fangringe Aufmerksamkeit verlangen.

Flughinweise bestehen aus einer kurzen gestrichelten Einflugspur, einem Pfeil,
einem Countdown und dem Wort „Anflug“. Sie reichen nicht mehr über die gesamte
Karte. Seidenherzen bleiben mechanisch vollständig aktiv, aber höchstens drei
ihrer Pulskreise werden gleichzeitig dargestellt.

Das Spiel unterscheidet dadurch klar:

- Blau gestrichelt von der Spinne: nächster Sprung und neuer Faden.
- Farbige Randspur mit Pfeil: bevorstehende Flugrichtung der Beute.
- Ring direkt am Tier: verbleibende Zeit zum Antippen.
