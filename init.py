import os
import shutil

def init_current_config():
    if not os.path.exists("./current_config"):
        os.mkdir("./current_config")
    for week in range(53):
        if not os.path.isdir("./current_config/"+str(week+1)):
            print("./current_config/"+str(week+1))
            os.mkdir("./current_config/"+str(week+1))
        for day in range(7):
            print("./current_config/" + str(week+1)+ "/"+ str(day+1)+".day")
            open("./current_config/" + str(week+1)+ "/"+ str(day+1)+".day","a").close()

def is_raspberrypi():
    return bool(input("Running on a raspberry Pi (ENTER for no | anything for yes)"))

def add_one_gong():
     f = open("./current_config/1/1.day","w")
     f.write("0.00")
     print("added Gong on KW 1 day 1 at 0.00")
     f.close()

def autostart():
    cwd = os.getcwd()
    f = open("./launch.sh","r")
    template = f.read()
    f.close()
    f = open("./launch.sh","w")
    template = template.replace("{dir}", cwd)
    f.write(template)

    f = open("./Gong.desktop","r")
    template = f.read()
    f.close()
    f = open("./Gong.desktop","w")
    template = template.replace("{dir}", cwd)
    f.write(template)
    path = os.path.expanduser("~/.config/autostart/Gong.desktop")
    shutil.copy("./Gong.desktop", path)

def install_godot():
    # -L for following redirects https://stackoverflow.com/questions/46060010/download-github-release-with-curl
    # should be made more robust (newest releases up to 3.x.x)
    os.system("curl -L https://github.com/hiulit/Unofficial-Godot-Engine-Raspberry-Pi/releases/download/v1.9.0/godot_3.4.2-stable_rpi4.zip --output godot.zip")
    os.system("unzip godot.zip")
    shutil.move("./godot_3.4.2-stable_rpi4_editor_lto.bin", "./gui/godot.bin")

init_current_config()
add_one_gong()
if is_raspberrypi():
    install_godot()
else:
    print("please install godot manually")
    print("install it in " + os.getcwd() + "/gui/godot.bin")
    print("and mark it as executable")
autostart()
print("rebooting is recommended to check wether the installation worked")
