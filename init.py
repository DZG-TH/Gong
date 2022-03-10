import os
from onboot import install_linux, InstallerConfiguration

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

def add_one_gong():
     f = open("./current_config/1/1.day","w")
     f.write("0.00")
     print("added Gong on KW 1 day 1 at 0.00")
     f.close()

def autostart():
    cwd = os.getcwd()
    sucessfull, _ = install_linux(InstallerConfiguration(cwd, "gong.py"))
    
    if not sucessfull:
        print("gong could not be autostarted")
    
    # make more robust / volatile
    sucessfull, _ = install_linux(InstallerConfiguration(cwd, "godot_wiht_args.sh"))

    if not sucessfull:
        print("godot could not be autostarted")

def install_godot():
    # -L for following redirects https://stackoverflow.com/questions/46060010/download-github-release-with-curl
    # should be made more robust (newest releases up to 3.x.x)
    os.system("curl -L https://github.com/hiulit/Unofficial-Godot-Engine-Raspberry-Pi/releases/download/v1.9.0/godot_3.4.2-stable_rpi4.zip --output godot.zip")
    os.system("unzip godot.zip")

init_current_config() 
add_one_gong()
install_godot()
autostart()
print("rebooting is recommended to check wether the installation worked")