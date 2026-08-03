# gameplay.md
# Project: Web Weaver
Version: 1.1
Status: Core Gameplay Specification

---

# 1. Gameplay Vision

Web Weaver ist ein Roguelite, bei dem der Spieler kein Schwert schwingt und keine Gegner direkt angreift.

Die eigentliche Waffe ist das selbst gebaute Spinnennetz.

Jede Runde beginnt klein und chaotisch.

Mit jedem Sprung wächst das Netz, wird stabiler und entwickelt sich zu einer tödlichen Falle für Insekten.

Der Spieler erschafft seine eigene Jagdmaschine.

---

# 2. Core Gameplay Loop

Der gesamte Spielfluss besteht aus wenigen Schritten:

1. Spinne bewegt sich automatisch.
2. Spieler tippt.
3. Spinne springt zum nächsten Ankerpunkt.
4. Ein neuer Faden wird gespannt.
5. Insekten fliegen ins Netz.
6. Beute wird eingesammelt.
7. Erfahrung wird verdient.
8. Level-Up.
9. Upgrade wählen.
10. Netz wird immer stärker.
11. Schwierigkeit steigt.
12. Boss.
13. Runde endet.
14. Permanente Upgrades freischalten.
15. Neue Runde.

Die Runde soll sich niemals unterbrechen oder zäh anfühlen.

---

# 3. Steuerung

## Nur eine Eingabe

Der Spieler besitzt genau **eine Aktion**:

**Tap**

Ein Tap bedeutet:

> "Springe jetzt."

Alles andere geschieht automatisch.

Keine Joysticks.

Keine Wischgesten.

Keine Buttons für Fähigkeiten.

---

# 4. Bewegung

Die Spinne läuft automatisch entlang vorhandener Fäden.

Erreicht sie einen Knotenpunkt, sucht sie sich den nächsten verfügbaren Weg.

Der Spieler entscheidet nur, wann sie abspringt.

Beim Sprung entsteht automatisch ein neuer Faden zwischen Start- und Zielpunkt.

Dadurch verändert sich das Netz permanent.

---

# 5. Das Netz

Das Netz ist die wichtigste Spielmechanik.

Jeder Faden hat Eigenschaften:

- Länge
- Stabilität
- Klebrigkeit
- Spannung

Aus diesen Werten ergibt sich die Qualität des Netzes.

Ein dichtes Netz fängt mehr Beute.

Ein instabiles Netz kann reißen.

---

# 6. Knotenpunkte

Jeder neue Sprung erzeugt einen neuen Verbindungspunkt.

Mehr Knoten bedeuten:

- mehr Wege
- größere Netze
- bessere Fallen
- mehr Möglichkeiten

---

# 7. Insekten

Insekten erscheinen kontinuierlich.

Jede Art besitzt:

- Fluggeschwindigkeit
- Gewicht
- Intelligenz
- Seltenheit
- Wert

---

## Kleine Fliege

Sehr häufig

Langsam

Leicht

1 Nahrung

---

## Mücke

Schnell

Schwer zu fangen

2 Nahrung

---

## Biene

Mittel

Kann sich befreien

5 Nahrung

---

## Motte

Langsam

Groß

Bleibt lange hängen

8 Nahrung

---

## Libelle

Sehr schnell

Schwieriges Ziel

10 Nahrung

---

## Hornisse

Aggressiv

Kann Fäden beschädigen

---

# 8. Nahrung

Alle gefangenen Insekten liefern Nahrung.

Nahrung dient als Hauptressource.

Verwendung:

- Upgrades
- Heilung
- Spezialfähigkeiten
- Permanente Verbesserungen

---

# 9. Erfahrung

Gefangene Insekten geben zusätzlich XP.

Bei jedem Level-Up stoppt das Spiel kurz.

Der Spieler wählt eines von drei zufälligen Upgrades.

Danach geht die Runde sofort weiter.

---

# 10. Upgrade-System

Jede Runde entsteht ein völlig neuer Build.

Beispiele:

### Fadenstärke

+20 % Stabilität

Im aktuellen Prototyp erhöht **Starke Seide** die maximale Fadenstärke um 25
Punkte und repariert beim Auswählen sofort alle bestehenden Fäden vollständig.

---

### Klebrigkeit

+15 %

Im aktuellen Prototyp vergrößert **Klebriges Netz** die Fangzone um 35 % und
reduziert zusätzlich die Fluggeschwindigkeit der Beute um 18 %.

---

### Sprungweite

+1 Knoten

---

### Netzgröße

+10 %

---

### Schnellere Bewegung

+15 %

Im aktuellen Prototyp erhöht **Flinke Beine** das Lauftempo um 20 % und verkürzt
die Sprungdauer um weitere 20 %.

---

### Mehr Nahrung

+20 %

---

### Kritischer Fang

Chance auf doppelte Beute

---

### Doppelter Faden

Jeder zweite Sprung erzeugt zwei Verbindungen.

---

### Elastisches Netz

Fäden reißen langsamer.

---

### Jagdinstinkt

Insekten fliegen häufiger ins Zentrum.

---

# 11. Seltene Upgrades

Goldene Karten

Sehr selten

Beispiele

---

Spinnenkönigin

Alle Netze werden doppelt so groß.

---

Architekt

Neue Knoten erzeugen automatisch Nebenfäden.

---

Seidenmeister

Alle Fäden erhalten dauerhaft Bonuswerte.

## Datengetriebene Upgrade-Datenbank (Prototype v3)

Der Prototyp zieht nicht mehr dieselben drei Karten. Eine separate Datenbank
enthält 16 Upgrades mit Seltenheit, Gewichtung, Maximalstufe, Build-Zuordnung
und Voraussetzungen. Bereits maximierte Karten werden nicht mehr angeboten.

Die vier ersten spielbaren Build-Richtungen sind:

- **Festung:** Fadenstärke, langsamere Alterung, weniger Wind- und Kampfschaden.
- **Falle:** größere Fangzone, längere Fluchtfenster und mehr seltene Beute.
- **Jägerin:** Bewegung, komfortableres Anwählen, kritische Fänge und Giftbiss.
- **Ökonomie:** größere Seidenreserve, billigere Fäden, Recycling und Stützfäden.

Seltene Synergiekarten benötigen passende Vorstufen. Der Festungskern erscheint
zum Beispiel erst nach zwei Stufen Starke Seide und einer Stufe Elastische
Fäden. Architektin benötigt Feinspinnen und zusätzliche Seidendrüsen.

---

# 12. Netzbewertung

Das Spiel bewertet kontinuierlich das Netz.

Kriterien:

- Dichte
- Symmetrie
- Stabilität
- Verbindungen
- Fangquote

Am Ende erhält das Netz einen Rang:

D

C

B

A

S

SS

SSS

Diese Bewertung bringt Bonusbelohnungen.

---

# 13. Biom-System

Jede Runde spielt in einem anderen Lebensraum.

## Wald

Standard

---

## Blumenwiese

Mehr Schmetterlinge

---

## Höhle

Wenig Licht

Seltene Käfer

---

## Dachboden

Staub

Motten

Spinnenkonkurrenz

---

## Sumpf

Viele Mücken

Hohe Luftfeuchtigkeit

---

# 14. Ereignisse

Während der Runde können zufällige Ereignisse auftreten.

Beispiele:

Windstoß

→ Netz bewegt sich.

---

Regen

→ Klebrigkeit sinkt.

---

Sonne

→ Insekten werden aktiver.

---

Blüte

→ Lockt Schmetterlinge an.

---

# 15. Bosskämpfe

Alle paar Wellen erscheint ein Boss.

Nicht klassisch.

Der Boss verändert die Umwelt.

## Levelabschluss im aktuellen Prototyp

Jedes Level ist ein Jagdauftrag ohne harte Zeitbegrenzung. Zuerst muss eine
sichtbare Nahrungsvorgabe erfüllt werden. Danach pausiert das normale Spawning
und einer von drei rotierenden Minibossen erscheint.

- Jeder Boss benötigt mehrere aktive Fänge und erfolgreiche Bisse.
- Nach dem Anspringen läuft ein kurzer Timingzeiger über einen Ring.
- Ein Treffer im goldenen Fenster verursacht zusätzlichen Schaden und gibt XP sowie Seide.
- Ein verpasster Biss beschädigt den Fangfaden; zwischen den Fängen greift der Boss weitere Fäden an.
- Jeder Befreiungsversuch belastet das Netz stark.
- Verpasst der Spieler sie, fliegt sie erneut an und verhindert keinen Fortschritt.
- Der seltene Giftbiss reduziert die benötigten Angriffe.
- **Wespenkönigin:** ausgewogener Auftaktboss mit vier Bisspunkten.
- **Titan-Käfer:** besonders schwer; benötigt eine Fangtasche oder starke Seide
  und trifft bei einem Durchbruch zwei Fäden.
- **Klingenhornisse:** schneller Mehrfachangreifer mit kurzer Fangzeit und
  besonders starkem Schaden bei verpassten Flugbahnen.
- Nach dem Fang erscheint der Levelabschluss; der bestehende Build und das Netz
  werden in das nächste, schwierigere Jagdlevel übernommen.

Beispiele:

Große Wespe

Beschädigt Fäden.

---

Vogel

Reißt Teile des Netzes weg.

---

Eidechse

Frisst gefangene Insekten.

---

Spinnenjäger

Zerstört einzelne Knoten.

---

# 16. Tod

Die Runde endet, wenn:

- die Spinne gefressen wird
- das Netz vollständig zerstört wird
- die Lebenspunkte auf 0 fallen

---

# 17. Meta-Progression

Nach jeder Runde bleiben dauerhafte Fortschritte erhalten.

Freischaltbar:

Neue Biome

Neue Insekten

Neue Spinnen

Neue Farben

Neue Animationen

Neue Startboni

Neue Musik

Neue kosmetische Fäden

---

# 18. Herausforderungen

Tägliche Challenges:

- Nur lange Fäden
- Starker Wind
- Riesige Insekten
- Doppelte Bossgegner
- Endlosmodus

---

# 19. Schwierigkeit

Das Spiel soll nie unfair wirken.

Die Schwierigkeit steigt durch:

- mehr Insekten
- schnellere Insekten
- Wetter
- stärkere Bosse
- größere Gebiete

Nicht durch künstlich erhöhte Lebenspunkte.

---

# 20. Langfristige Motivation

Der Spieler möchte:

- schönere Netze bauen
- neue Builds ausprobieren
- SSS-Ränge erreichen
- seltene Upgrades sammeln
- neue Biome freischalten
- kosmetische Inhalte sammeln
- Rekorde aufstellen

---

# 21. USP (Unique Selling Proposition)

Web Weaver kombiniert:

- Roguelite-Builds
- automatisches Gameplay
- One-Tap-Steuerung
- kreativen Netzbau
- physikbasierte Fallen
- entspannte Atmosphäre

Es geht nicht darum, Gegner zu besiegen.

Es geht darum, **das perfekte Netz zu erschaffen**.

Das Netz ist gleichzeitig Werkzeug, Kunstwerk und Spielfortschritt.

---

# 22. Design-Grundsätze

Jede neue Spielmechanik muss mindestens eine dieser Eigenschaften verbessern:

- Das Netz interessanter machen.
- Mehr sinnvolle Entscheidungen erzeugen.
- Neue Build-Kombinationen ermöglichen.
- Die Kreativität des Spielers fördern.
- Den Flow der Runde erhalten.

Wenn eine Mechanik diese Ziele nicht erfüllt, wird sie verworfen.

---

# 23. Prototype Balancing Decisions

## Seidenreserve

Neue Fäden sind nicht unbegrenzt verfügbar.

Die Spinne besitzt eine sichtbare Seidenreserve.

- Jeder neue Faden verbraucht Seide.
- Lange Fäden kosten mehr als kurze Fäden.
- Bewegung auf bereits vorhandenen Fäden kostet keine Seide.
- Gefangene Insekten füllen einen Teil der Seidenreserve wieder auf.
- Ohne ausreichende Seide kann kein neuer Faden gebaut werden.

Das verhindert gedankenloses Spammen und erzeugt die Kernentscheidung:

> "Baue ich jetzt weit oder spare ich Seide für eine wichtigere Verbindung?"

## XP-Pacing

XP und Nahrung bleiben getrennte Werte.

- Gewöhnliche Fliegen geben wenig XP.
- Motten geben mittlere XP.
- Seltene Bienen geben deutlich mehr XP.
- Das erste Level benötigt 24 XP.
- Der XP-Bedarf steigt pro Level ungefähr um den Faktor 1,35.
- Der Fortschritt wird über einen permanent sichtbaren XP-Balken kommuniziert.

Frühe Level-Ups sollen nicht nach wenigen Sekunden erscheinen. Zielwert für die
ersten Spieltests ist ungefähr ein Upgrade alle 45–75 Sekunden.

## Aktueller Ressourcen-Loop

1. Gezielt Seide in neue Verbindungen investieren.
2. Mit dem Netz Insekten fangen.
3. Nahrung und XP erhalten.
4. Einen Teil der Seide regenerieren.
5. Das Netz erweitern, verstärken oder reparieren.
6. Durch XP neue Build-Entscheidungen freischalten.

## Aktiver Fang-Loop (Prototype v2)

Ein Netzkontakt ist kein automatischer Fang mehr. Er startet nur ein kurzes
Zeitfenster, in dem der Spieler reagieren muss.

- Winzige Mücken bilden die Ausnahme: Sie erscheinen häufig, werden automatisch
  eingesammelt und liefern kontinuierlich kleine XP- und Seidenbelohnungen.
- Gefangene Beute wird mit einem ablaufenden Ring markiert.
- Der Spieler muss das Tier antippen, damit die Spinne hinspringt und es einwickelt.
- Läuft der Ring ab, entkommt das Tier und beschädigt den haltenden Faden.
- Fliegen bleiben lange hängen, Motten deutlich kürzer und Bienen nur sehr kurz.
- Schwache oder bereits verschlissene Fäden werden von kräftiger Beute durchbrochen.
- Bienen benötigen im Grundzustand verstärkte oder klebrige Seide.

## Netzverschleiß (Prototype v2)

- Neue Fäden bleiben zunächst in voller Stärke.
- Nach 14 Sekunden verlieren sie langsam Haltbarkeit.
- Kämpfende Beute und Wind beschleunigen den Verfall.
- Gerissene Verbindungen können erneut gespannt werden, kosten aber wieder Seide.
- Der Startvorrat beträgt 80 Seide und lange Fäden sind teurer.

Dadurch besteht der Loop jetzt aus Beobachten, Bauen, Reagieren, Einwickeln und
Reparieren. Ein großes passives Netz ist keine dauerhafte Gewinnstrategie mehr.

---

# 24. Upgrade-Datenbank und Build-Pfade

Der Prototyp besitzt aktuell 29 Upgrades in fünf Build-Pfaden. Höhere Perks
werden erst sichtbar, wenn ihre Voraussetzungen erfüllt sind. Jede Auswahl zieht
drei unterschiedliche Karten aus dem gerade freigeschalteten Pool.

## Neue freischaltbare Perks

- **Panzerknoten (Festung):** Neue Fäden starten mit zusätzlicher Haltbarkeit.
- **Notfallflicken (Festung):** Ein gerissener Faden repariert sich nach einer Abklingzeit selbst.
- **Taufalle (Falle):** Kleine Mücken liefern zusätzliche Nahrung und Seide.
- **Kettenfang (Falle + Jägerin):** Ein aktiver Fang kann eine zweite gefangene Beute automatisch einwickeln.
- **Jägerblick (Jägerin):** Aktiv angesprungene Beute liefert mehr Nahrung und XP.
- **Seidensprint (Jägerin):** Schnellere Beutesprünge reparieren den Landefaden.
- **Notreserve (Ökonomie):** Bei fast leerer Seide öffnet sich einmal pro Jagdlevel eine Reserve.
- **Prachtkokon (Ökonomie + Falle):** Abschlussbeute liefert mehr Nahrung, XP und Seide.
- **Brutnest (Brut):** Pro Stufe schlüpft eine sichtbare Jungspinne, die das aktive Netz patrouilliert.
- **Flickenläufer (Brut):** Die Helfer reparieren regelmäßig den schwächsten Faden.
- **Jungjäger (Brut):** Eine Helferspinne wickelt in festen Abständen gefangene normale Beute ein.
- **Schwarmtrieb (Brut + Jägerin):** Erhöht das Tempo der Hauptspinne und lässt weitere Brut schlüpfen.
- **Spinnenkönigin (Brut-Kernperk):** Zwei zusätzliche Helfer; die Brut kann nun auch Abschlussbeute beißen.

Die Mischvoraussetzungen von Kettenfang und Prachtkokon sind bewusst gesetzte
Synergien. Schwarmtrieb verbindet Brut und Bewegung. Die Spinnenkönigin verlangt
hingegen eine bewusste Investition in Brutnest, Flickenläufer und Jungjäger. So
entsteht ein eigener, sichtbarer Schwarm-Build statt eines rein numerischen Bonus.

---

# 25. Nächster Spannungsbaustein: aktive Jagdmomente

Das Grundspiel soll nicht durch zufällige Strafen hektischer werden, sondern durch
kurze, klar angekündigte Situationen, in denen Beobachtung, Timing und eine
bewusste Entscheidung zählen. Die empfohlene Reihenfolge für den Ausbau ist:

## 1. Bissfenster und Wespen-Miniboss (umgesetzt)

- Eine gefangene Wespe ist nicht sofort besiegt, sondern besitzt mehrere Bisspunkte.
- Beim Anspringen wandert ein kurzer Timing-Ring auf ein goldenes Fenster zu.
- Ein perfekter Biss betäubt die Wespe und gibt einen kleinen Seiden- oder XP-Bonus.
- Ein zu früher oder später Biss lässt sie zappeln und beschädigt umliegende Fäden.
- Dadurch bleibt Netzbau wichtig, aber der Fang verlangt zusätzlich Geschick.

## 2. Angekündigte Jagdimpulse

Alle 35 bis 55 Sekunden kann ein acht bis zwölf Sekunden langes Ereignis auftreten.
Ein Richtungspfeil und eine kurze Vorwarnung geben dem Spieler Zeit zu reagieren.

- **Windstoß:** belastet nur Fäden in einer angekündigten Schneise; gute Knoten und Reparaturen zahlen sich aus.
- **Tautropfen:** macht einzelne Knoten kurz schwerer, erhöht dort aber Fangwert und seltene Beute.
- **Vogelschatten:** zwingt die Spinne, sich rechtzeitig auf einen verstärkten oder bedeckten Netzbereich zu bewegen.

Diese Ereignisse verändern Entscheidungen und sind keine bloßen Sichtfilter. Es
gibt vorerst keinen Winter- oder Frostablauf.

## 3. Jagdverträge als kontrollierter Randomizer

Vor einem Level werden zwei zufällige Verträge angeboten; der Spieler wählt einen
oder lehnt beide für eine normale Jagd ab. Beispiele:

- Mehr Wespen, dafür 30 Prozent mehr seltene Perks.
- Zerbrechlichere Seide, dafür doppelte Combo-XP.
- Weniger Ankerpunkte, dafür startet die Jagd mit einer zusätzlichen Upgrade-Wahl.

Der Zufall erzeugt Abwechslung, die Wahl erhält die Kontrolle. Später können Käfer
(schwere Beute für verstärkte Kreuzungen) und Libellen (mehrere schnelle Anflüge)
als weitere Minibosse folgen.

---

# 26. Living Web – Netzgeometrie als Build (umgesetzt)

Das Netz ist nicht mehr nur eine Sammlung einzelner Fanglinien. Seine Geometrie
erzeugt eigene, sofort sichtbare Werkzeuge:

- **Fangtasche:** Drei aktive Fäden bilden ein Dreieck. Beute innerhalb der
  geschlossenen Fläche benötigt 22 Prozent weniger Haltekraft und bleibt 45 Prozent
  länger gefangen. Mehrere schnelle Fänge in Fangtaschen erhöhen Nahrung und XP
  als zeitlich begrenzte Kombo.
- **Seidenherz:** Ein Knoten mit mindestens vier aktiven Verbindungen repariert
  regelmäßig alle angrenzenden Fäden. Dafür erzeugt er dauerhaft eine kleine Menge
  Vibration und ist damit ein starker, aber nicht kostenloser Netzkern.
- Reißt ein benötigter Faden, verschwindet die Glyphe. Wird die Form repariert,
  erwacht sie erneut. Der Spieler baut und verteidigt dadurch funktionale Formen.

## Flugkorridore und Vibration

Beute erscheint nicht mehr ohne Vorwarnung. Eine kurze gestrichelte Flugbahn mit
Richtungspfeil zeigt Höhe, Richtung und ungefähre Ankunftszeit. Seltene Beute wird
länger und farblich deutlicher angekündigt, sodass gezieltes Reagieren möglich ist.

Ab drei aktiven Fäden kann der Spieler das Netz mit **Netz zupfen** bewusst reizen:

- Drei wertvollere Tiere werden in angekündigten, leicht versetzten Korridoren angelockt.
- Vibration steigert Spawnrate und Chance auf wertvolle Beute.
- Gleichzeitig verursachen kämpfende Tiere und Wind mehr Fadenschaden.
- Vibration klingt wieder ab; die Aktion besitzt acht Sekunden Abklingzeit.

Der neue Kernrhythmus lautet damit: Form planen, Anflug lesen, Risiko auslösen,
Fangtaschen ausnutzen, Kombo sichern und belastete Knoten reparieren.

---

# 27. Jagdverträge und Spezialtiere (umgesetzt)

Vor jedem Jagdlevel werden drei unterschiedliche Verträge aus einem Pool von sechs
angeboten. Ein Vertrag bleibt bis zum besiegten Wespen-Miniboss aktiv und verändert
nicht nur Zahlen, sondern auch Tempo, bevorzugte Beute und die passende Netzstrategie.

- **Gläserne Jagd:** mehr Fadenschaden, dafür deutlich mehr Nahrung und Panzerkäfer.
- **Sturmkorridor:** schnellere und häufigere Anflüge, mehr XP und viele Libellen.
- **Nachtleuchten:** kürzere Fangzeit, mehr Seide und häufige Glühwürmchen.
- **Seidenhunger:** teurere Fäden, sehr hohe Nahrungsbelohnung und Panzerkäfer.
- **Echo-Netz:** eine dauerhafte Mindestvibration für mehr XP und riskante Anflüge.
- **Goldene Ruhe:** höheres Jagdziel, dafür weniger Netzschaden und seltenere Beute.

## Spezialtiere

- **Panzerkäfer:** langsam, schwer und zerstörerisch. Ohne starke Seide benötigt er
  eine Fangtasche; ein Durchbruch beschädigt den Faden besonders stark. Sein Fang
  verstärkt den schwächsten aktiven Faden.
- **Libelle:** extrem schnell und wendet nach einem verpassten Anflug zweimal. Das
  angekündigte Flugband muss gelesen und rechtzeitig mit einem Faden gekreuzt werden.
  Ein Fang gibt zusätzliches Reaktions-XP.
- **Glühwürmchen:** leichter zu halten, aber strategisch wertvoll. Sein Fang senkt
  die Vibration deutlich und liefert zusätzliche Seide, wodurch aggressive
  Netz-zupfen-Phasen kontrolliert beendet werden können.

Verträge, Netzgeometrie und Perks bilden zusammen die drei Ebenen eines Runs:
Levelregel wählen, Netz passend bauen und den Build auf die entstehenden Chancen ausrichten.
