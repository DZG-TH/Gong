# Gong

Dokumentation für den digitalen Gong

## Kapitel

1.  Features des Programms
2.  Setup - Installation
3.  Benutzung des Programms
4.  Dokumentaion für erweiterten Support

#
## 1. Feautures des Programms
- Audiodateien im .mp3 Format werden als Gong unterstützt 
		(+ andere Formate können mit geringem Aufwand auch unterstützt werden)
- Tag-Zeitraster können selbst angelegt & bearbeitet werden
              (z.B. Testtag, Kurzstundentag, letzter Schultag, usw.)
- Wochen-Zeitraster können selbst angelegt & bearbeitet werden werden 
              (bestehen aus Tag-Zeitrastern)
              (z.B. Testwoche3x, Testwoche5x, Normal, usw.)
- Jeder Kalender Woche **kann** ein Wochen-Zeitraster zugeordnet werden
- Jedem Tag **kann** ein Tag-Zeitraster zugeordnet werden
- Gong kann manuell betätigt werden

#
## 2. Setup - Installation
- Für die Installtion benötigt man: 
	- [ ]  Raspberry Pi
	- [ ]  micro sd card mit Debian-basiertem Linux (Raspbian empfohlen) (Bei PC USB-stick)
	- [ ]  micro HDMI zu HDMI Kabel (male to male)
	- [ ]  Stromversorgung für die RasberryPi / PC (USB-C Kabel, USB-Ladegerät)
	- [ ]  USB-Tastatur, USB-Maus
	- [ ]  Aux zu XLR Kabel (male to male )
	- [ ]  Monitor mit HDMI-port
	- [ ]  WLAN- oder LAN-Zugang (temporär)
1. micro sd-card in den RaspberryPi stecken
2. Monitor mit Strom verbinden
3. Monitor und RaspberryPi mit HDMI-Kabel verbinden
4. Tastatur und Maus verbinden
5. Aux zu XLR Kabel einstecken
6. RaspberryPi mit Strom verbinden
7. Setup von Raspbian durchlaufen
8. Verbindung mit WLAN / LAN
	- Bei LAN: 
		- LAN-Kabel einstecken (RaspberryPi und LAN-Port)
	- Bei WLAN:
		1. Oben rechts auf das WLAN Icon klicken
		2. WLAN-Netzwerk auswählen
		3. Passwort eingeben
		4. Verbinden drücken ??? 
9. Terminal starten (oben links auf das schwarze icon klicken)
10. eintippen (nach jeder Zeile ENTER)
	```	sudo apt update
		sudo apt upgrade
		sudo apt install git mpg321 unzip
		git clone https://github.com/DZG-TH/Gong
		cd Gong
		python3 init.py
		sudo reboot now
	``` 
#
## 3. Starten des Programms
#### Das Programm sollte sich automatisch bei Systemstart selbst starten 
#### Sollte dies nicht passieren

- init.py nochmals laufen lassen
	1. Terminal starten (oben links auf das schwarze icon klicken)
	```
		cd Gong
		python3 init.py
	```
	2. neustarten
- sollte dies nicht funktionieren
	1. Server starten
	- Terminal starten (oben links auf das schwarze icon klicken)
		```
			cd Gong
			python3 gong.py
		```
	2. Godot starten
		- Terminal starten (oben links auf das schwarze icon klicken)
		```
			cd Gong
			./godot_3.4.2-stable_rpi4_editor_lto.bin /gui/scenes/Main.tscn
		```
## 4. Benutzung des Programms
#### Hinweis: Raster = Template
#### Hinweis: {X} wird als Platzhalter genutzt
- Jeder Woche kann ein Wochen-Zeitraster zugeordnet werden
	1.  Auf die graue Box neben "Woche KW {ZAHL}" klicken
	2.  Ein Raster auswählen
- Jedem Tag kann ein Tag-Zeitraster zugeordnet werden
	1.  Auf die graue Box unter dem Tagesnamen klicken
	2.  Ein Raster auswählen
- Manuell Gong betätigen
	1.  Auf die graue Box mit der Beschriftung "Gong" klicken
- Ein Raster Erstellen
	- Hinweise:
		- Durch klicken auf "speichern" wird das Raster gespeichert
		- Um das Erstellen abzubrechen das "kleine" Fenster schließen 
	1.  Die Box mit der Beschriftung "Template erstellen" klicken
	2.  Für Tagesraster "Tag" wählen, für Wochen-Zeitraster "Woche" wählen
	3.  Oben auf die Dunkelgrau hinterlegte Zeile klicken
	4.  Namen eintippen
	- Tages-Zeitraster
		1. unten auf + klicken um eine (weitere) Zeit hinzu zu fügen
			- WICHTIG: Zeiten müssen in chronologischer Reihenfolge eingetragen werden -> sonst werden zu weit unten eingetragene Zeiten übersprungen
		2. Im Auswahlfeld Zeit eintragen
			- Im linken Feld die Stundenzeit eingeben
			- Im Rechten Feld die Minutenzeit eingeben
		- Duch klicken auf das "-" kann die nebenstehende Zeit entfernt werden
	- Wochen-Zeitraster
		- Das Tag-Zeitraster für jeden Wochentag auswählen
- Ein Raster Bearbeiten
	1. Die Box mit der Beschriftung "Template bearbeiten" klicken
	2. Für Tages-Zeitraster "Tag" wählen, für Wochen-Zeitraster "Woche" wählen
	3. Das zubearbeitende Raster auswählen
	4. Rest siehe "Ein Raster erstellen"
#
## 5. Dokumentation für erweiterten Support
- Mögliche Fehler
	- gong.py crasht mit: OSError: Port already in use: [Erklärung](https://tecadmin.net/kill-process-on-specific-port/)
	```
		sudo kill -9 $(sudo lsof -t i:4242)
	``` 

