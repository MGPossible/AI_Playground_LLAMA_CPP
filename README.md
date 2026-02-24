# Einrichtung einer lokalen KI-Spielwiese

Diese Anleitung richtet sich an Alle, die in erster Linie verschiedene lokale KI-Modelle kennenlernen und ausprobieren möchten.
Diese angeleitete Spielerei mit verschiedenen KI-Modellen kann auch einen Weg zur eigenen lokalen KI-Lösung ebenen, denn die Distanz von der Spielerei zur ersten Problemlösung ist manchmal gar nicht so weit.
Zumdem ist es ein Irrglaube, dass nur riesige Cloud-Modelle ein fertiges Produkt liefern könnten - das mag zwar auf sehr komplexe Software-Projekte zutreffen - für viele kleine bis mittel-schwere Probleme können lokale Open-Source KI-Lösungen einen validen Lösungsansatz liefern.   
Einen potenten PC vorrausgesetzt, kann später sogar mithilfe eines lokalen Coding-Agents das erste einfache bis mittel-schwere Projekt umgesetzt werden.

### Benötigte Hardware:
Der wahrscheinlich größte Knackpunkt bei der lokalen KI-Anwendung ist der eigene lokale PC. KI-Anwendung profitieren unheimlich von der Größe des Grafikkartenspeichers ``(VRAM)`` und speziell angepassten Berechnungschips den CUDA- bzw. MATRIX-TENSOR-Chips. Dabei setzt NVIDIA mit den CUDA-TENSOR-Chips faktisch den derzeitigen Standard, wobei AMD mit den MATRIX-TENSOR-Chips, technisch gesehen, bereits aufgeschlossen hat. Es fehlt jedoch das große Ökosystem aus Anwendern, Software-Frameworks und Tutorials.
Die Geschwindigkeit der CPU ist eher nebensächlich. Die CPU sollte nur nicht älter als 2015 sein, da zu diesem Zeitpunkt wichtige Hardware-Protokolle eingeführt wurden.
Der Systemspeicher ``(RAM)`` sollte mindestens 16GB betragen, wenn man mehr als nur ein ``Proof-Of-Concept`` erstellen möchte.

Die ``unterste Grenze`` für einen spassigen Einstieg liegt bei einem Laptop mit 16GB Systemspeicher ohne Grafikarte aus dem Jahr 2015.
Dieser PC kann einfache Modelle ausführen und leichte Probleme mit KI lösen: z.B. Videoüberwachung (Personenerkennung) durchführen, einfache Chat-Bots zur Verfügung stellen (für z.B. Nachhilfeaufgaben, Vokabeltrainer, Texterschließungstools), aus einfacher Sprache Texte erstellen oder ein Recherche-Tool mit Internetanbindung zum Laufen bringen.

Die ``gehobene Mittelklasse`` ist ein PC mit 16GB Systemspeicher und 12GB Grafikartenspeicher (idealerweise eine NVIDIA-Grafikkarte z.B. RTX5070 > RTX4070 > RTX 4060TI > RTX 3080 TI).
Dieser PC kann: Die Ausgaben mehrerer kleiner Modelle nacheinander verarbeiten, komplexe Informationen aus Bilder entnehmen, Audiodateien erstellen oder längere Programme schreiben.

Die ``Oberklasse bis High-End`` ist ein PC mit mind. 32GB Systemspeicher und mind. 16GB Grafikartenspeicher (RTX5090(32GB) > RTX4090 (24GB) > RTX3090 (24GB) > RTX5080 (16GB) > RTX5070TI (16GB) > RTX4080 (16GB))
Dieser PC kann: Die Ausgaben mehrerer kleiner Modelle nacheinander gleichzeitig, komplexe Informationen aus vielen Bilder entnehmen, Audiodateien in wenigen Sekunden erstellen oder Programme mit höherer Komplexität schreiben. Dabei richtet sich diese Klasse eher an erfahrenere Nutzer, die diesen potenten PC auch durch andere Anwendungen ausreizen möchten.

### Betriebsystem
Diese Anleitung richtet sich gezielt an ``Windows 10/11`` Nutzer. Alle Tools funktionieren jedoch äquivalent unter ``Linux`` bzw. ``WSL2`` oder mit Apple im ``Metal-Framework``.

### Benötigte Software / Modelle (Schnellzugriff):
- [Microsoft Visual C++ Redistributable Version 14](https://aka.ms/vc14/vc_redist.x64.exe)
- [Aktuellstes LLama C++ - Release](https://github.com/ggml-org/llama.cpp/releases)
- [Gewünschtes OpenSource KI-Modell im GGUF-Format](https://huggingface.co/models?search=gguf)
- [ggf. Software zum Auslesen der Grafikkarte](https://www.techpowerup.com/gpuz/)

1. Zuerst [Microsoft Visual C++ Redistributable Version 14](https://aka.ms/vc14/vc_redist.x64.exe) herunterladen und installieren. Diese C++-Laufzeitbibliothek von Microsoft ist in der Regel bereits auf dem PC installiert. In diesem Fall spielt man dann nur ein Update mit dieser ``exe.``-Datei auf.

2. Wenn die Spezifikationen des eignen PCs unbekannt sind, kann mit dem portablen und kostenfreiem Tool [GPU-Z](https://www.techpowerup.com/gpuz/) das System ausgelesen werden:
   - Unten findet man unter ``Computing`` die Checkbox für ``CUDA``.
   - Unter ``Memory Size`` findet man den ``VRAM`` in MB (Wert / 1000 = Wert in GB)
   - Unter Windows 10/11 -> Einstellungen -> System -> Info kann der ``Installierte RAM`` ausgelesen werden.
   
   ![Beispielhafte Darstellung](/docs/rtx4090.png)

2. Danach muss ein passendes [LLama C++ - Release]([https://github.com/ggml-org/llama.cpp/releases) heruntergeladen werden:
    - ``Windows x64 (CPU)``, wenn der PC über **KEINE** eigene Grafikkarte verfügt (GPU-Z zeigt dann Intel als Grafikkarte an)
    - ``Windows x64 (CUDA 12) - CUDA 12.4 DLLs``, wenn der PC über eine **NVIDIA** Grafikkarte verfügt (GPU-Z zeigt dann bei CUDA einen Haken)
    - ``Achtung``: Beide Pakete müssen heruntergeladen werden und dann im gleichen Ordner entpackt werden 
    - (Optional kann auch CUDA 13.1 bei den neusten Grafikkarten verwendet werden)
    - ``Windows x64 (HIP)`` oder ``Windows x64 (Vulkan)``, wenn der PC über eine **AMD** Grafikkarte verfügt (GPU-Z zeigt dann das AMD-LOGO oben rechts) 
    - ``Achtung``: Hier muss je nach Bauart und vorhandenem Treiber gestetet werden, besser wäre die ``HIP``-Variante.

3. Nun muss ein passendes Modell im ``.GUFF-FORMAT`` ausgewählt und heruntergeladen werden. Dies sollte nur über die beiden Quellen [Hugging Face](https://huggingface.co/) oder [ModelScope](https://www.modelscope.ai) erfolgen.
    - Bei der Auswahl des Modells müssen einige Dinge beachtet werden (**mittelgroße Modell-Kunde**):
    - **Trainingsparameter**:
        - Die Anzahl der Trainings-Parameter werden in der Regel in Milliarden (engl. Billion) angegeben.
        - ``0.5B-6B-Modelle`` sind für spezialisierte Einsatzwecke traniert. Auch wenn sie in anderen Bereichen nutzlos erscheinen, liegt hier die Zukunft bei der Pruduktentwicklung!
        - ``7B-8B-Modelle`` decken breitere Einsatzbereiche ab und haben eine sehr gute Performance. Sie sind bei komplexen Problemen eher überfordert.
        - ``14B-20B-Modelle`` sind im Jahr 2026 fast echte All-Rounder für lokale Anwendungen geworden. Sie benötigen allerdings einen PC der ``gehobenen Mittelklasse`` bzw. ``Oberklasse``.
        - ``120B< Modelle`` sind derzeit in vielen Einsatzbereichen **State-Of-The-Art**. Hier liegt der Bedarf an VRAM+RAM teilweise bei bis zu 240 GB.
        - Wichtig: Je nach Architektur sind verschiedene Modellgruppen in Einzelbereichen unterschiedlich stark, daher lässt sich ein ``8B-LAMA-Modell`` von Meta nicht direkt mit einem ``8B-Qwen-Modell`` von Alibaba Cloud vergleichen. **Rule-Of-Thumb**: Liegt zwischen den Modellen eine Zeitspanne von 3-4 Monaten, dann ist das ältere Modell meist schlechter.
        - Seit Q3 2025 werden auch ``MoE-Modelle`` (Mixture of Experts) trainiert. Diese haben z.B. 80B Traningsparameter, nutzen aber nur aktiv 3B Parameter bei den Anfrage (z.B: Qwen3-Next-80B-A3B).
        - Die Bewertung dieser Modelle ist nicht immer ganz einfach. **Rule-Of-Thumb**: Trainingsparameter/10 * aktive Parameter = "effektive" Parameter (z.B. 80/10 * 3 = 24B)
        
    - **Quantifizierung**
        - Modelle müssen insbesondere für den lokalen Einsatz ein wenig "verpackt" werden. Normalerweise laufen Modelle mit 32-Bit-Gleitkomma - diese Präzision kostet viel Speicher und Strom.
        - Durch geschicktes "Packen" verlieren einige Modelle nur wenig Präsision (1%-3%), wenn sie auf 8-Bit-Ganzzahl umgerechnet werden.
        - Bei einer 4-Bit-Quantisierung verlieren einige Modelle mehr Präzision (5%-8%), welche aber bei größeren Modellen durch aus noch akzeptabel ist.
        - **Rule-Of-Thumb**: ``8Q`` > ``Q4_K_M`` bei gleicher Parametergröße (Andere Quantifizierungen sollten als Anfänger eher gemieden werden, [Benchmark des Präzisionsverlusts](https://gist.github.com/Artefact2/b5f810600771265fc1e39442288e8ec9))
        
    - **Modelltyp**
        - Nicht jedes Modell eignet sich für alle "großen" Aufgabenbereiche. Es haben sich ein paar grobe Aufgabenbereiche mit folgenden Beschreibungen durchgesetzt:
        - ``BASE``-Modelle: Diese Modelle sind zum finetunen und für Anfänger unbrauchbar.
        - ``INSTRUCT`` oder ``CHAT``- Modelle: Klassisches Chat- Modell, welches trainiert wurde Dialoge mit den Nutzer zu führen.
        - ``CODER`` oder ``CODER-INSTRUCT``-Modelle: Traniert um längere Codes zu erstellen, ggf. mit Dialog-Option.
        - ``THINKING``-Modelle: Das Modell durchläuft einen bestimmten Ablauf, um die Ausgabe zu verbessern: ``Prompt des Nutzers``  -> ``Aufteilung in Teilprobleme`` -> ``Hierachisierung der Teilprobleme`` -> ``Bearbeitung der Teilprobleme`` -> ``Abgleich mit ursprünglichen Befehl`` -> ``Bewertung der eigenen Ausführung`` -> ``Ausgabe``.
        - ``ASR``-Modelle: Wandeln Spracheingaben zu Text um. Nicht alle ASR-Modelle sind mit LLAMA C++ lauffähig.
        - ``TTS``-Modelle: Wandeln Text zu Sprache um. Nicht alle TTS-Modelle sind mit LLAMA C++ lauffähig.
        - ``OCR``-Modelle: Wandeln Bilder zu Text um (verarbeiten den Inhalt jedoch nicht). Nicht alle OCR-Modelle sind mit LLAMA C++ lauffähig.
        - ``VL``-Modelle: Wandeln Bilder zu Text um und können diese in der Regel auch verarbeiten. Nicht alle VL-Modelle sind mit LLAMA C++ lauffähig.
        - ``DIFFUSION``-Modelle: Wandeln Texte oder Bilder in Bilder oder Videos um. Diese können nicht mit LLAMA C++ angewandt werden. Dafür sollte [Comfy UI](https://github.com/Comfy-Org/ComfyUI) genutzt werden. 
        Das Modell ``Qwen3-VL-235B-A22B-Chat-Thinking`` ist also ein Modell, welches Informationen aus Bildern verarbeiten kann und dabei noch über die verschiedenen Teilprobleme der Anfrage "nachdenkt" bevor es antwortet.

    - **Kontextgröße**
        - Vielleicht die wichtigste "Eigenschaft" um Halluzinationen zu begegenen. Sie ist jedoch im hohem Maße von der Einbettung des Modells abhängig - hier beginnt dann in der Regel die Produktentwicklung. Das Problem ist tatsächlich auf der Modellebene diametral und geradezu "menschlich".
        - Je mehr Kontext mit dem Prompt geliefert werden kann, desto präszieser kann der Befehl verstanden und ausgeführt werden.
        - Je größer der Kontext wird, desto eher werden Informationen übersehen oder ignoriert. Das Modell wird also "kognitiv" überfordert.
        - Daher ist das Prompting und auch die Implementation des Modells in einem System so wichtig (MCP, LCP, ...). 
        - Sehr gute Modelle haben mit 256k - 1M Tokens eine ausreichende Kontextgröße. Zum Vergleich: Die Harry Potter Serie hat 1.5 M Tokens - jedoch wird die Hälfte (42%) des Inhalts bei der Verarbeitung "vergessen".
        - In der Praxis können aber auch Modelle mit 32k Tokens einen vernüftigen Output liefern.
        
    - **Modellgröße in GIGABYTE**
        - Die Größe des Modells wird ducrh alle vorgenannten Parameter bestimmt. **Rule-Of-Thumb**: ``bigger`` = ``better``
        - Die **maximale** Größe und die Geschwindigkeit wird durch das vorhanden System limitiert.
        - Generell gilt vereinfacht folgende Rechnung: ``Größe des Grafikkartenspeichers (VRAM)`` + ``Größe des Systemspeichers (RAM)`` - ``5 GB`` = ``Maximale Größe des Modells in GB``
        - Beispielrechnung: ``16 GB VRAM`` + ``32 GB RAM`` - ``5 GB`` = ``43 GB Modell`` 
        - Diese maximale Größe bringt in der Regel keine schnelle Verarbeitung mit sich (5 Tokens/s) und macht nur bei sehr komplexen Aufgaben und etwas Erfahrung Sinn.
        - *(Das OFFLOADING auf eine NVME-Festplatte ist zwar machbar, aber die Inferenz ist so langsam, dass die Stromkosten höher sind, als die Kosten für einen Cloud-Betreiber)*
        - Besser wäre folgende Berechnung: ``Modellgröße in GB`` = ``VRAM GB`` + ``1-2 GB``
        - Generell gilt: Es sollten keine weiteren Programme im Hintergrund laufen.
        
    - **Empfehlungen für den Einstieg** 
    - Gute Modelle mit zunehmender Größe und Qualität sind (Stand Feb.2026) ``AUF GENAUE BEZEICHNUNG ACHTEN!``:
    - Diese Modelle sind natürlich nicht direkt mit den State-Of-The-Art-Modellen vergleichbar (https://arena.ai/de/leaderboard/)
      - [Qwen3-1.7B-Q8_0.gguf](https://huggingface.co/Qwen/Qwen3-1.7B-GGUF/tree/main) - ``1.83 GB`` mind. 4GB RAM (Für Uralt-PCs, definitiv nur Proof-Of-Concept)  
      - [Qwen3-4B-Q4_K_M.gguf](https://huggingface.co/Qwen/Qwen3-4B-GGUF/tree/main) - ``2.5 GB`` mind. 4GB RAM (für sehr einfache Aufgaben, eher Proof-Of-Concept)    
      - [Qwen3-4B-Q4_K_M.gguf](https://huggingface.co/Qwen/Qwen3-4B-GGUF/tree/main) - ``4.28 GB`` mind. 8GB RAM (ist langsam, aber kann schon komplexer Aufgaben)
      - [Qwen3-8B-Q4_K_M.gguf](https://huggingface.co/Qwen/Qwen3-8B-GGUF) - ``5.03 GB`` mind. 8GB RAM (etwas langsam mit 8 GB RAM aber durchaus brauchbar, **Vorschlag bei 8GB RAM**)
      - [Qwen3-8B-Q8_0.gguf](https://huggingface.co/Qwen/Qwen3-8B-GGUF) - ``8.71 GB`` mind. 16GB RAM (**Vorschlag bei 16 GB RAM**, schneller und besserer Output, als 8B mit Q4) 
      - [Qwen3-14B-Q4_K_M.gguf](https://huggingface.co/Qwen/Qwen3-14B-GGUF/tree/main) - ``9 GB`` mind. 16GB RAM und 8 GB VRAM (könnte etwas langsam sein, sehr brauchbar) 
      - [Qwen3-14B-Q8_0.gguf](https://huggingface.co/Qwen/Qwen3-14B-GGUF/tree/main) - ``15.7 GB`` mind. 16GB RAM und 16 GB VRAM (**Vorschlag bei 16GB RAM mit 16GB VRAM**)
      - [Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf](https://huggingface.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF) - ``18.6 GB`` mind. 32GB RAM und mind. 16 GB VRAM (Sehr brauchbar bei komplexeren Problemen)
      - [Qwen3-Coder-30B-A3B-Instruct-Q8_0.gguf](https://huggingface.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF) - ``32.5 GB`` mind. 32GB RAM und mind. 24 GB VRAM (Sehr brauchbar bei komplexeren Problemen (besser als Q4))
      - [GPT-OSS-20b.gguf](https://huggingface.co/ggml-org/gpt-oss-20b-GGUF) - ``12.1 GB`` mind. 16GB RAM und 12 GB VRAM (**Vorschlag bei Verwendung von MCP-Servern**, Beachte Start-Parameter in dieser Anleitung: (https://github.com/ggml-org/llama.cpp/discussions/15396))
      - Spezielle Modelle mit unglaublich guter Leistung in speziellen Gebieten werden weiter unten angegeben. 
      
4. Zu Testzwecken sollte zunächst nur das kleine Modell [Qwen3-4B-Q4_K_M.gguf](https://huggingface.co/Qwen/Qwen3-4B-GGUF/tree/main) geladen werden.
5. In einem beliebigen Stammverzeichnis (z.B.KI-Spielwiese) muss nun folgende Ordnerstruktur angelegt werden:
    ```
    - ROOT (KI-Spielwiese)
        # Start.bat                     <- siehe 6. Punkt
        - models                        <- In dem Ordner werden alle Modelle im .GGUF-Format hinterlegt
            # Qwen3-4B-Q4_K_M.gguf
        - llamacpp                      <- In dem Ordner wird der gesamte Inhalt aus dem LLama C++ Release hinterlegt (ohne Unterordner!)
            # llama-server.Experts         (Bei Verwendung von CUDA müssen auch die drei.DLL-Dateien in dem Ordner hinterlegt werden) 
            # llama-cli.exe
            # ggml.dll
            # u.v.m.
    ```

6. Zumdem wird nun eine ``.BAT``-Datei zum Starten benötigt. Diese muss nur in des Stammverzeichnis abgelegt werden.
7. Der Inhalt der Dateien sieht so aus und kann [HIER](/Start.bat) heruntergeladen werden:

    ``Start.bat`` 
    ```
    @echo off
    
    start .\llamacpp\llama-server.exe --models-dir ./models --host 127.0.0.1 --port 8033 -ngl 99

    pause
    ```

8. Mit einem Doppelklick öffnet sich das ``Windows-Terminal`` und stellt unmittelbar den ``KI-Server`` bereit.
9. Dieser ist von jedem Browser über diese Adresse erreichbar: ``http://127.0.0.1:8033`` (Auf Wunsch kann der Port in der ``Start.bat`` verändert werden).
    Alternativ kann man im ``Terminal`` mit ``SHIFT + LINKSKLICK`` direkt den Browser starten und der Adresse folgen.
10. Es öffnet sich eine Benutzeroberfläche, welche von fast allen Anbietern genutzt wird. Doch zuerst muss das Modell geladen werden.
    Dies geschieht mit einem Klick auf ``Select model`` können alle Modelle die sich im Ordner ``models`` befinden ausgewählt werden.
    Das Modell ist fertig geladen, wenn hinter dem Modellnamen ein grüner Punkt erscheint. Bei größeren 14B Modellen kann dies teilweise bis zu 3 Minuten dauern.
    LLAMA C++ kann, in Abhängigkeit vom verfügbaren Speicher, auch bis zu vier Modelle parallel laden.

![Beispielhafte Darstellung](/docs/llamacpp1.png)

11. Wenn das Modell geladen wurd, kann die erste Eingabe durch den Nutzer starten.

![Beispielhafte Darstellung](/docs/llamacpp2.png)
    Auf der linken Seite tauchen alle geführten Unterhaltungen auf. Diese werden im Cache des jeweiligen Browser gespeichert und verlassen nicht den lokalen Computer.
    ``THINKING``-Modelle starten ihre Eingabe mit dem ``Reasoning``. Dies kann oben rechts auf den Doppel-Pfeil ausgeklappt werden.
    Unter der Ausgabe findet man die verwendeten Tokens aus Ein- und Ausgabe, die benötigte Zeit und die Tokens pro Sekunde.

12. Beenden der Spielwiese: Der Browser kann geschlossen werden, das ``Windows-Terminal`` sollte mit dem Befehl ``STRG + C`` sauber beendet werden. Andernfalls sitzt das Modell noch solange im ``RAM`` oder ``VRAM``, bis der Speicher von anderen Programmen oder dem Neustart freigeräumt wird.
