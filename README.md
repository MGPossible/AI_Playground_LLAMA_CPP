# Einrichtung einer lokalen KI-Spielwiese (WIP24.03.2026)
### Übersicht
- [Einleitung](#ziel)
- [Benötigte Hardware](#benötigte-hardware)
- [Benötigte Software](#benötigte-software)
- [Kleine Modellkunde](#kleine-modellkunde)
- [Modellempfehlung für den Einstieg](#modellempehlung-für-den-einstieg)
- [Starten der ersten Inferenz](#starten-der-ersten-inferenz)
- [Beenden der Inferenz](#beenden-der-inferenz)

### Einleitung
Diese Anleitung richtet sich an alle, welche die Chancen und Möglichkeiten lokaler KI-Modelle kennenlernen und praxisnah ausprobieren möchten.

Das spielerische Erkunden unterschiedlicher Modelle kann dabei weit mehr sein als nur Experimentieren: Oft ist der Schritt von den ersten Versuchen hin zu einer konkreten Problemlösung überraschend klein.

Gleichzeitig soll die Annahme, dass nur große Cloud-Modelle zu brauchbaren Ergebnissen führen, teilweise entkräftet werden. Zwar trifft das bei sehr komplexen Softwareprojekten häufig zu – doch für viele kleine bis mittelgroße Anwendungsfälle bieten lokale Open-Source-KI-Lösungen bereits heute überzeugende und praktikable Alternativen.

Mit entsprechender Hardware lässt sich dieser Ansatz sogar weiter ausbauen: Mithilfe eines lokalen Coding-Agenten können erste eigene Projekte – von einfachen Tools bis hin zu anspruchsvolleren Anwendungen – eigenständig umgesetzt werden.

[Zurück nach oben](#übersicht)

### Benötigte Hardware
Diese Anleitung beschreibt die Nutzung der Tools unter ``Windows 10/11``. Die beschriebenen Tools lassen sich jedoch ebenso unter ``Linux``, über ``WSL2`` oder auf Apple-Systemen mithilfe des ``Metal-Frameworks`` verwenden.

Der entscheidende Faktor für lokale KI-Anwendungen ist die eigene Hardware – insbesondere die Grafikkarte. KI-Modelle profitieren stark von großem Grafikspeicher ``(VRAM)`` sowie von spezialisierten Recheneinheiten wie Tensor- bzw. Matrix-Tensor-Cores. NVIDIA hat sich hier mit CUDA und seinen Tensor-Cores als De-facto-Standard etabliert. AMD bietet technisch vergleichbare Lösungen, jedoch ist das Ökosystem aus Tools, Community und Dokumentation derzeit noch weniger ausgeprägt.

Die CPU spielt eine eher untergeordnete Rolle, sollte jedoch nicht älter als Baujahr 2016 sein, da ab diesem Zeitpunkt wichtige Hardware-Erweiterungen eingeführt wurden. Beim Arbeitsspeicher ``(RAM)`` gilt: 16 GB RAM sind das sinnvolle Minimum, wenn über reine Experimente hinaus gearbeitet werden soll.

``Einstiegsklasse``
Die unterste Grenze für einen brauchbaren Einstieg bildet ein Laptop ab etwa 2016 mit 16 GB RAM – auch ohne dedizierte Grafikkarte. Damit lassen sich einfache Modelle ausführen und kleinere Aufgaben umsetzen, etwa:
- einfache Chatbots (z. B. für Nachhilfe, Vokabeltraining oder Textverständnis)
- grundlegende Textgenerierung
- einfache Bild- oder Videoauswertungen (z. B. Personenerkennung bei niedriger FPS)
- kleinere Recherche-Tools mit Internetanbindung

``Mittelklasse``
Ein System mit 16 GB RAM und etwa 12 GB VRAM (idealerweise mit einer NVIDIA-GPU, z.B. RTX5070 > RTX4070 > RTX 4060TI > RTX 3080 TI) bietet bereits deutlich mehr Möglichkeiten. Dazu gehören:
- die Verarbeitung mehrerer Modelle in Folge
- Bildanalyse mit höherer Komplexität
- Audioverarbeitung und -generierung
- Unterstützung beim Schreiben längerer Programme

``Oberklasse / High-End``
Für anspruchsvollere Anwendungen empfiehlt sich ein System mit mindestens 32 GB RAM und 16 GB VRAM (z.B. RTX5090 (32GB) > RTX4090 (24GB) > RTX3090 (24GB) > RTX5080 (16GB) > RTX5070TI (16GB) > RTX4080 (16GB)). Solche Systeme ermöglichen:
- parallele Nutzung mehrerer Modelle
- umfangreiche Bild- und Datenanalysen
- schnelle Audio- und Textgenerierung
- Unterstützung bei komplexeren Softwareprojekten

Diese Leistungsklasse richtet sich vor allem an fortgeschrittene Nutzer, die das Potenzial ihrer Hardware auch über KI-Anwendungen hinaus ausschöpfen möchten.

[Zurück nach oben](#übersicht)

### Benötigte Software
- [Microsoft Visual C++ Redistributable Version 14](https://aka.ms/vc14/vc_redist.x64.exe)
- [Aktuellstes LLama C++ - Release](https://github.com/ggml-org/llama.cpp/releases)
- [Gewünschtes Open-Source-KI-Modell im GGUF-Format](https://huggingface.co/models?search=gguf)
- [ggf. Software zum Auslesen der Grafikkarte](https://www.techpowerup.com/gpuz/)
- [ggf. LLM-Fit zum Abschätzen der Modell-Performance](https://github.com/AlexsJones/llmfit/releases)

1. Zu Beginn muss die ``C++-Laufzeitbibliothek`` von Microsoft [Microsoft Visual C++ Redistributable Version 14](https://aka.ms/vc14/vc_redist.x64.exe) herunterladen und installieren. Sie ist in der Regel bereits auf dem PC installiert. In diesem Fall spielt man dann nur ein Update mit dieser ``exe.``-Datei auf.

2. Wenn die Spezifikationen des eigenen PCs unbekannt sind, kann mit dem portablen und kostenfreien Tool [GPU-Z](https://www.techpowerup.com/gpuz/) das System ausgelesen werden:
  - Unten findet man unter ``Computing`` die Checkbox für ``CUDA``.
  - Unter ``Memory Size`` findet man den ``VRAM`` in MB (Wert / 1000 = Wert in GB)
  - Unter Windows 10/11 -> Einstellungen -> System -> Info kann der ``Installierte RAM`` ausgelesen werden.
   
   ![Beispielhafte Darstellung](/docs/rtx4090.png)

3. Danach muss das passende [Llama C++ - Release](https://github.com/ggml-org/llama.cpp/releases/) heruntergeladen werden. Die Software sollte passenden zum PC gewählt werden:
  - ``Windows x64 (CPU)``, wenn der PC über **KEINE** eigene Grafikkarte verfügt (GPU-Z zeigt dann Intel als Grafikkarte an)
  - ``Windows x64 (CUDA 12) - CUDA 12.4 DLLs``, wenn der PC über eine **NVIDIA** Grafikkarte verfügt (GPU-Z zeigt dann bei CUDA einen Haken)
  - ``Achtung``: Beide Pakete müssen heruntergeladen werden und dann im gleichen Ordner entpackt werden 
  - (Optional kann auch CUDA 13.1 bei den neusten Grafikkarten verwendet werden)
  - ``Windows x64 (HIP)`` oder ``Windows x64 (Vulkan)``, wenn der PC über eine **AMD** Grafikkarte verfügt (GPU-Z zeigt dann das AMD-LOGO oben rechts) 
  - ``Achtung``: Hier muss je nach Bauart und vorhandenem Treiber gestetet werden, besser wäre die ``HIP``-Variante.

[Zurück nach oben](#übersicht)

### Kleine Modellkunde
Nun muss ein passendes Modell im ``.GGUF-FORMAT`` ausgewählt und heruntergeladen werden. Dies sollte nur über die beiden vertrauenswürdigen Quellen [Hugging Face](https://huggingface.co/) oder [ModelScope](https://www.modelscope.ai) erfolgen.
Die Auswahl des Modells ist gerade am Anfang nicht immer einfach. Hier gibt es folgende Aspekte zu beachten:
**Trainingsparameter**:
Die Anzahl der Trainings-Parameter werden in der Regel in Milliarden (engl. Billion) angegeben.
- ``0.5B-6B-Modelle`` sind für spezialisierte Einsatzwecke trainiert. Auch wenn sie in anderen Bereichen nutzlos erscheinen, liegt hier die Zukunft bei der Pruduktentwicklung!
- ``7B-10B-Modelle`` decken bereits breitere Einsatzbereiche ab und liefern sehr gute Ausgaben. Teilweise sind diese bei komplexen Problemen eher überfordert.
- ``14B-20B-Modelle`` sind im Jahr 2026 fast echte All-Rounder für lokale Anwendungen geworden. Sie benötigen allerdings einen PC der ``gehobenen Mittelklasse`` bzw. ``Oberklasse``.
- ``> 120B-Modelle`` sind derzeit in vielen Einsatzbereichen **State-Of-The-Art**. Diese können nur mit angepasster Hardware lokal betrieben werden.

- Wichtig: Je nach Architektur sind verschiedene Modellgruppen in Einzelbereichen unterschiedlich stark, daher lässt sich ein ``8B-LAMA-Modell`` von Meta nicht direkt mit einem ``8B-Qwen-Modell`` von Alibaba Cloud vergleichen. **Rule-Of-Thumb**: Liegt zwischen den Modellen eine Zeitspanne von 3-4 Monaten, dann ist das ältere Modell meist schlechter.
- Seit Q3 2025 werden auch ``MoE-Modelle`` (Mixture of Experts) trainiert. Diese haben z.B. 80B Traningsparameter, nutzen aber nur aktiv 3B Parameter bei der Anfrage (z.B: Qwen3-Next-80B-A3B).
- Die Bewertung dieser Modelle ist nicht immer ganz einfach. **sehr grobe Rule-Of-Thumb**: Trainingsparameter/10 * aktive Parameter = "effektive" Parameter (z.B. 80/10 * 3 = 24B)
        
**Quantifizierung**
Modelle müssen insbesondere für den lokalen Einsatz "komprimiert" werden. Normalerweise laufen Modelle mit 32-Bit-Gleitkomma - diese Präzision kostet viel Speicher und Strom.
Durch geschicktes "quantifizieren" verlieren einige Modelle nur wenig Präzision (1%-3%), wenn sie auf 8-Bit-Ganzzahl heruntergerechnet werden.
Bei einer 4-Bit-Quantisierung verlieren einige Modelle mehr Präzision (5%-8%). Dies ist aber bei größeren Modellen durchaus noch akzeptabel.
**Rule-Of-Thumb**: ``8Q_0`` > ``Q4_K_M`` bei gleicher Parametergröße (Andere Quantifizierungen sollten als Anfänger eher gemieden werden, [Benchmark des Präzisionsverlusts](https://gist.github.com/Artefact2/b5f810600771265fc1e39442288e8ec9)
        
**Modelltyp**
Nicht jedes Modell eignet sich für alle Aufgabenbereiche. Es haben sich ein paar grobe Aufgabenbereiche mit folgenden Beschreibungen durchgesetzt:
- ``BASE``-Modelle: Diese Modelle sind zum finetunen und für Anfänger unbrauchbar.
- ``INSTRUCT`` oder ``CHAT``-Modelle: Klassisches Chat-Modell, welches trainiert wurde Dialoge mit den Nutzer zu führen.
- ``CODER`` oder ``CODER-INSTRUCT``-Modelle: Diese sind trainiert um längere Codes zu erstellen, ggf. mit Dialog-Option.
- ``THINKING``-Modelle: Das Modell durchläuft einen bestimmten Ablauf, um die Ausgabe zu verbessern: ``Prompt des Nutzers``  -> ``Aufteilung in Teilprobleme`` -> ``Hierachisierung der Teilprobleme`` -> ``Bearbeitung der Teilprobleme`` -> ``Abgleich mit ursprünglichen Befehl`` -> ``Bewertung der eigenen Ausführung`` -> ``Ausgabe``.
- ``ASR``-Modelle: Wandeln Spracheingaben zu Text um. Nicht alle ASR-Modelle sind mit ``LLAMA C++`` lauffähig.
- ``TTS``-Modelle: Wandeln Text zu Sprache um. Nicht alle TTS-Modelle sind mit ``LLAMA C++`` lauffähig.
- ``OCR``-Modelle: Wandeln Bilder zu Text um (verarbeiten den Inhalt jedoch nicht). Nicht alle OCR-Modelle sind mit ``LLAMA C++`` lauffähig.
- ``VL``-Modelle: Wandeln Bilder zu Text um und können diese in der Regel auch verarbeiten. Nicht alle VL-Modelle sind mit ``LLAMA C++`` lauffähig.
- ``DIFFUSION``-Modelle: Wandeln Texte oder Bilder in Bilder oder Videos um. Diese können nicht mit ``LLAMA C++`` angewandt werden. Dafür sollte [Comfy UI](https://github.com/Comfy-Org/ComfyUI) genutzt werden.
  Das Modell ``Qwen3-VL-235B-A22B-Chat-Thinking`` ist also ein Modell, welches Informationen aus Bildern verarbeiten kann und dabei noch über die verschiedenen Teilprobleme der Anfrage "nachdenkt" bevor es antwortet.

**Kontextgröße**
Die Kontextgröße bestimmt, wie viele Informationen (Tokens) ein Modell gleichzeitig in einer Konversation im Gedächtnis halten kann. Wie Modell mit der Fülle an Eingabe-Informationen umgehen, hängt in hohem Maße von der Einbettung des Modells abhängig - hier beginnt dann in der Regel die Produktentwicklung. Das Problem ist tatsächlich auf der Modellebene diametral und geradezu "menschlich":
- Je mehr Kontext mit dem Prompt geliefert werden kann, desto präzieser kann der Befehl verstanden und ausgeführt werden.
- Je größer der Kontext wird, desto eher werden Informationen übersehen oder ignoriert. Das Modell wird also "kognitiv" überfordert.
- Daher ist das Prompting und auch die Implementation des Modells in einem System so wichtig (MCP, LCP, ...). 
- Sehr gute Modelle haben mit 256k - 1M Tokens eine ausreichende Kontextgröße. Zum Vergleich: Die komplette Harry Potter Serie umfasst 1.5 M Tokens - jedoch wird die Hälfte (42%) des Inhalts bei der Verarbeitung "vergessen", wenn man dies nicht durch ergänzende Tools kompensiert.
- In der Praxis können aber auch Modelle mit 32k Tokens einen vernünftigen Output liefern.
- Achtung: ``LLAMA C++`` reduziert automatisch die Kontextgröße, wenn ein zu großes Modell ausgewählt wird. In diesem Falle können beschnittene Kontextgrößen von 4000 Tokens entstehen - das Modell wirkt dann dümmer als es tatsächlich ist. Wie man diesem Problem manuell entgegensteuern kann wird in der optionalen ``config.ini`` erläutert.
        
**Modellgröße in GIGABYTE**
- Die Größe des Modells wird durch alle vorgenannten Parameter bestimmt. **Rule-Of-Thumb**: ``bigger`` = ``better``
- Die **maximale** Größe und die Geschwindigkeit wird durch das vorhandene System limitiert.
- Generell gilt vereinfacht folgende Rechnung: ``Größe des Grafikkartenspeichers (VRAM)`` + ``Größe des Systemspeichers (RAM)`` - ``5 GB`` = ``Maximale Größe des Modells in GB``
- Beispielrechnung: ``16 GB VRAM`` + ``32 GB RAM`` - ``5 GB`` = ``43 GB Modell`` 
- Diese maximale Größe bringt in der Regel keine schnelle Verarbeitung mit sich (5 Tokens/s) und macht nur bei sehr komplexen Aufgaben und etwas Erfahrung Sinn.**Rule-Of-Thumb**: ``5 Tokens/s`` = ``Kaffetrinken zwischen den Eingaben`` (was nicht unbedingt schlecht ist)
- Dies ist auf das *Offloading* des Modells in den langsamern ``RAM`` zurückzuführen.
- *(Das OFFLOADING auf eine NVME-Festplatte ist zwar machbar, aber die Inferenz ist so langsam, dass die Stromkosten höher sind, als die Kosten für einen Cloud-Betreiber)*
    
- Besser wäre folgende Berechnung: ``Modellgröße in GB`` = ``VRAM GB`` + ``1-2 GB``
- Maximale Geschwindigkeit: ``Modellgröße in GB`` = `` VRAM GB`` **-** ``3 GB``
- Generell gilt: Es sollten keine weiteren Programme im Hintergrund laufen.
- Soll das Modell testweise nur in der ``CPU`` also ohne eine Grafikkarte genutzt werden gilt: ``Modellgröße in GB`` = `` vorhandener RAM in GB`` **-** ``6 GB``

[Zurück nach oben](#übersicht)
        
### Modellempfehlung für den Einstieg
Gute Modelle mit zunehmender Größe und Qualität sind (Stand März 2026) ``AUF GENAUE BEZEICHNUNG ACHTEN!``:
Diese Modelle sind natürlich nicht direkt mit den State-Of-The-Art-Modellen vergleichbar (https://arena.ai/de/leaderboard/)
Im Folgendem werde ich zuerst auf die offiziellen Modellseiten der Ersteller verlinken. Darunter befinden sich die passenden Links zu den quantifizierten Modellen im ``.GGUF``-Format. Erfahrene Anbieter von quantifizierten Modellen sind [Bartowski (Arcee AI)](https://huggingface.co/bartowski), [Unsloth AI](https://huggingface.co/unsloth) und [Team MRadermacher](https://huggingface.co/mradermacher).
Aktuelle Allrounder mit einer sehr guten Effizienz sind die Qwen3.5-Modelle - richtig eingebettet, schlagen diese Modelle deutlich größere Modelle!
- [Modellseite - Qwen3.5 **0.8B**](https://huggingface.co/Qwen/Qwen3.5-0.8B)
  - [Qwen3.5-0.8B-Q8_0.gguf](https://huggingface.co/bartowski/Qwen_Qwen3.5-0.8B-GGUF/resolve/main/Qwen_Qwen3.5-0.8B-Q8_0.gguf) - ``0.8 GB`` mind. 4GB RAM (Für Uralt-PCs, definitiv nur Proof-Of-Concept)  
- [Modellseite - Qwen3.5 **2B**](https://huggingface.co/Qwen/Qwen3.5-2B)
  - [Qwen3.5-2B-Q8_0.gguf](https://huggingface.co/bartowski/Qwen_Qwen3.5-2B-GGUF/resolve/main/Qwen_Qwen3.5-2B-Q8_0.gguf) - ``2 GB`` mind. 6GB RAM (für sehr einfache Aufgaben, eher Proof-Of-Concept)
- [Modellseite - Qwen3.5 **4B**](https://huggingface.co/Qwen/Qwen3.5-4B) - unglaublich starkes 4B-Modell für spezielle Aufgaben - schlägt in vielen Bereichen 20B-Modelle!
  - [Qwen3.5-4B-Q4_K_M.gguf](https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF/resolve/main/Qwen_Qwen3.5-4B-Q4_K_M.gguf) - ``2.9 GB`` mind. 8GB RAM (für komplexe Aufgaben einsetzbar) **Vorschlag für System mit nur 8GB RAM**
  - [Qwen3.5-4B-Q8_0.gguf](https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF/resolve/main/Qwen_Qwen3.5-4B-Q8_0.gguf) - ``4.5 GB`` mind. 8GB RAM und 2GB VRAM (für komplexe Aufgaben einsetzbar, bei 8GB steht ggf. nur ein reduzierter Kontext zur Verfügung, ggf. etwas langsam mit 8GB RAM)
- [Modellseite - Qwen3.5 **9B**](https://huggingface.co/Qwen/Qwen3.5-9B) - unglaublich starkes 9B-Modell für spezielle und allgemeine Aufgaben - schlägt in manchen Bereichen 120B-Modelle!
  - [Qwen3.5-9B-Q4_K_M.gguf](https://huggingface.co/bartowski/Qwen_Qwen3.5-9B-GGUF/resolve/main/Qwen_Qwen3.5-9B-Q4_K_M.gguf) - ``5.9 GB`` mind. 16GB RAM (überraschend guter Output, langsam) **Vorschlag für System mit 16GB RAM**
  - [Qwen3.5-9B-Q8_0.gguf](https://huggingface.co/bartowski/Qwen_Qwen3.5-9B-GGUF/resolve/main/Qwen_Qwen3.5-9B-Q8_0.gguf) - ``9.5 GB`` mind. 16GB RAM und 8 GB VRAM (schneller und besserer Output, als 9B mit Q4)
- [Modellseite - Qwen3.5 **27B**](https://huggingface.co/Qwen/Qwen3.5-27B) - schlägt Cloud-Modelle die 1-2 Quartale älter sind, leider nur auf High-End-PCs lauffähig
  - [Qwen3.5-27B-Q3_K_M.gguf](https://huggingface.co/bartowski/Qwen_Qwen3.5-27B-GGUF/resolve/main/Qwen_Qwen3.5-27B-Q3_K_M.gguf) - ``13.8 GB`` mind 32GB RAM und 16 GB VRAM (langsam, eher Proof-Of-Concept, sehr gute Ausgaben)
  - [Qwen3.5-27B-Q4_K_M.gguf](https://huggingface.co/bartowski/Qwen_Qwen3.5-27B-GGUF/resolve/main/Qwen_Qwen3.5-27B-Q4_K_M.gguf) - ``17 GB`` mind. 32GB RAM und 24 GB VRAM (langsam, eher Proof-Of-Concept, sehr gute Ausgaben)
         
- [Modellseite - GPT-OSS **20B**](https://huggingface.co/openai/gpt-oss-20b) - interessantes OpenSource-Modell von Open AI, bei Verwendung von MCP-Servern sehr mächtig 
  - [GPT-OSS-20b.gguf](https://huggingface.co/ggml-org/gpt-oss-20b-GGUF) - ``12.1 GB`` mind. 16GB RAM und 12 GB VRAM (**Vorschlag bei Verwendung von MCP-Servern**. Beachte die Start-Parameter in dieser [Anleitung](https://github.com/ggml-org/llama.cpp/discussions/15396)
          
- [Modellseite - Mistral AI - Devstral 2 Small **24B**](https://huggingface.co/mistralai/Devstral-Small-2-24B-Instruct-2512) - europäische KI-Meisterleistung für Terminal-Coding-Tools wie [Crush CLI](https://github.com/charmbracelet/crush)
  - [Devstral-Small-2-24B-Instruct-2512-Q4_K_M.gguf](https://huggingface.co/bartowski/mistralai_Devstral-Small-2-24B-Instruct-2512-GGUF/resolve/main/mistralai_Devstral-Small-2-24B-Instruct-2512-Q4_K_M.gguf) - ``14.3 GB`` mind. 32 GB RAM und 16 GB VRAM (lange Ladezeit, aber super effizienter Code)
  - [Devstral-Small-2-24B-Instruct-2512-Q8_0.gguf](https://huggingface.co/bartowski/mistralai_Devstral-Small-2-24B-Instruct-2512-GGUF/resolve/main/mistralai_Devstral-Small-2-24B-Instruct-2512-Q8_0.gguf) - ``25 GB`` mind 32 GB RAM und 24 GB VRAM (lange Ladezeit, aber super effizienter Code)

[Zurück nach oben](#übersicht)

### Starten der ersten Inferenz
1. Zu Testzwecken sollte zunächst nur das kleine Modell [Qwen3.5-4B-Q4_K_M.gguf](https://huggingface.co/bartowski/Qwen_Qwen3.5-4B-GGUF/resolve/main/Qwen_Qwen3.5-4B-Q4_K_M.gguf) geladen werden.
2. In einem beliebigen Stammverzeichnis (z.B.KI-Spielwiese) muss nun folgende Ordnerstruktur angelegt werden:
    ```
    - ROOT (KI-Spielwiese)
        # Start.bat                     <- siehe 4. Punkt
        - models                        <- In dem Ordner werden alle Modelle im .GGUF-Format hinterlegt
            # Qwen3.5-4B-Q4_K_M.gguf
        - llamacpp                      <- In dem Ordner wird der gesamte Inhalt aus dem LLama C++ Release hinterlegt (ohne Unterordner!)
            # llama-server.exe             (Bei Verwendung von CUDA müssen auch die drei.DLL-Dateien in dem Ordner hinterlegt werden) 
            # llama-cli.exe
            # ggml.dll
            # u.v.m.
    ```

3. Zumdem wird nun eine ``.BAT``-Datei zum Starten benötigt. Diese muss nur in das Stammverzeichnis abgelegt werden.
4. Der Inhalt der Dateien sieht so aus und kann [HIER](/Start.bat) heruntergeladen werden:
    ```
    @echo off
    
    .\llamacpp\llama-server.exe --models-dir ./models --host 127.0.0.1 --port 8033 -ngl 99

    pause
    ```

5.  Mit einem Doppelklick öffnet sich das ``Windows-Terminal`` und stellt unmittelbar den ``KI-Server`` bereit.
6. Dieser ist von jedem Browser über diese Adresse erreichbar: ``http://127.0.0.1:8033`` (Auf Wunsch kann der Port in der ``Start.bat`` verändert werden).
    Alternativ kann man im ``Terminal`` mit ``SHIFT + LINKSKLICK`` direkt den Browser starten und der Adresse folgen.
7. Es öffnet sich eine Benutzeroberfläche, welche von fast allen Anbietern genutzt wird. Doch zuerst muss das Modell geladen werden.Dies geschieht mit einem Klick auf ``Select model`` können alle Modelle die sich im Ordner ``models`` befinden ausgewählt werden. Das Modell ist fertig geladen, wenn hinter dem Modellnamen ein grüner Punkt erscheint. Bei größeren Modellen kann dies teilweise bis zu 3 Minuten dauern.``LLAMA C++`` kann, in Abhängigkeit vom verfügbaren Speicher, auch bis zu vier Modelle parallel laden.

![Beispielhafte Darstellung](/docs/llamacpp1.png)

8. Eine Erfolgsmeldung unten rechts im Browser zeigt an, wenn das Modell vollständig geladen wurde. Dann kann die erste Eingabe durch den Nutzer starten.

![Beispielhafte Darstellung](/docs/llamacpp2.png)

Auf der linken Seite tauchen alle geführten Unterhaltungen auf. Diese werden im Cache des jeweiligen Browser gespeichert und verlassen nicht den lokalen Computer.
``THINKING``-Modelle starten ihre Eingabe mit dem ``Reasoning``. Dies kann oben rechts auf den Doppel-Pfeil ausgeklappt werden.
Unter der Ausgabe findet man die verwendeten Tokens aus Ein- und Ausgabe, die benötigte Zeit und die Tokens pro Sekunde.

[Zurück nach oben](#übersicht)

### Beenden der Inferenz
- Der Browser kann normal geschlossen werden. 
- Das ``Windows-Terminal`` sollte mit dem Befehl ``STRG + C`` sauber beendet werden. 
- Andernfalls sitzt das Modell noch solange im ``RAM`` oder ``VRAM``, bis der Speicher von anderen Programmen oder dem Neustart freigeräumt wird.

[Zurück nach oben](#übersicht)   

WIP
