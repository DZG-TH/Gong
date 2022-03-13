# Architektur

Gong hat ein Server - Client Prinzip. Das heißt der Server ist dafür verantwortlich die Gongs zu den richtigen Zeiten abzuspielen während der Client nur eine graphische Oberfläche bietet um diese Zeiten festzulegen
# Server
## Initialisierung / Installation
Die initialisierung bzw Installation wird durch init.py durchgeführt.
Dafür macht das Script folgendes:

1.  Der Ordner current_config und seine Unterordner und Dateien werden erstelllt
2.  Es wird ein Gong am 1. Tag der KW 1 hinzugefügt, um eine Endlosschleife beim Suchen nach dem nächsten Gong zu verhindern
3.  godot wird installiert
4.  autostart wird konfiguriert

## gong.py
Der Server nutzt um seine Aufgabe zu Erfüllen zwei Prozesse (Threads).

### MainThread
Der MainThread ist dafür zuständig die Gongs abzuspielen, bzw. auf das Abspielen zu warten
Dafür macht das Script folgendes:
1. Es entnimmt die Zeit des nächsten Gongs aus den Dateien (current_config)
2. Rechnet diese Zeit in Unix-Zeit um (datetime)
3. Ziet von der errechneten Zeit die aktuelle Zeit ab
4. Wartet die in 4. errechnete Zeit
5. spielt den Gong ab
6. beginnt von neuem
#### ServerThread
Der ServerThread ist dafür zuständig die Änderungen die am Zeitplan gemacht werden in die Dateien (current_config) einzutragen. Ebenso trägt er auch die Änderungen an templates (presets Ordner (Namensänderung zu templates wird erfolgen um konsistent zu bleiben)) ein.
Dafür macht das Script folgendes:
1. Es startet einen UDP-Server auf Port 4242
2. Es wartet auf eingehende requests des Clients
3. Diese requests werden in der Methode process_request verarbeitet
4. Ergebnis der Verarbeitung wird zurückgesendet

# Client
Der Client wurde mithilfe der [godot-gameengine](godotengine.org) entwickelt und befindet sich im Ordner gui
Er wartet auf Pakete auf Port 4241
Dafür macht er folgendes (/gui/scripts/Main.gd)
1. Wartet darauf das sich der ServerCommunicator mit dem Server verbindet
2. Richtet die Benutzeroberfläche nach den vom ServerCommunicator erhaltenen Daten ein
3. Erstellt ein "Signal" das die Benutzeroberfläche aktualisiert sobald sich der Tag bzw die Woche ändert

## ServerCommunicator
Der ServerCommunicator ist der einzige Teil des Clients der direkt mit dem Server kommuniziert.
Dafür macht er folgendes (/gui/scripts/ServerCommunicator.gd)
1. Startet den UDP-Server auf Port 4241
2. Fordert wichtige details von Server an
	- Tag
	- Woche
	- Tag-Templates
	- Wochen-Templates
3. Setzt "connected" auf True -> Verbindung aufgebaut