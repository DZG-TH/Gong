import os
import pickle
import time
import datetime
import socket
import shutil
import filecmp
from threading import Thread



def get_templates_week_arr():
    return [f.name for f in os.scandir("./presets/week") if f.is_dir()]

def get_templates_week():
    # returns the list of subfolders from ./presets/week
    folders = get_templates_week_arr()
    text = ""
    for i in folders:
        text += i + ","
    return text.strip(",")

def get_templates_day_arr():
    return [f.name.strip(".day") for f in os.scandir("./presets/day") if f.is_file()]

def get_templates_day():
    files = get_templates_day_arr()
    text = ""
    for i in files:
        text += i + ","
    return text.strip(",")


def get_week_current():
    return str(datetime.date.today().isocalendar()[1])

def get_day_of_week_current():
    return str(datetime.date.today().isoweekday())

def get_template_week(kw):
    for template in get_templates_week_arr():
        all_identical = True
        for day in os.listdir("./current_config/" + kw+"/"):
            if not filecmp.cmp("./presets/week/"+template+"/"+ day, "./current_config/"+kw+"/"+day):
                all_identical = False
        if all_identical:
            return template
    return "CUSTOM" # this should not happen
        

def get_template_week_day(kw, day):
    for template in get_templates_day_arr():
        if filecmp.cmp("./presets/day/"+template+".day", "./current_config/"+kw+"/"+day+".day", shallow=False):
            return str(True)
    return str(False)

def set_template_day(kw, day, template):
    if template in get_templates_day_arr():
        shutil.copy("./presets/day/"+ template + ".day", "./current_config/"+kw+"/"+day+".day")
        return str(True)
    return str(False)

def set_template_week(kw, template):
    if template in get_templates_week_arr():
        shutil.copytree("./presets/week/"+ template, "./current_config/"+kw, dirs_exist_ok=True)
        return str(True)
    return str(False)

def process_request(data):
    print("processing", data, end="")
    if data == "GET TEMPLATES WEEK":
        return get_templates_week()
    elif data == "GET TEMPLATES DAY":
        return get_templates_day()
    elif data == "GET WEEK CURRENT":
        return get_week_current()
    elif data == "GET DAY_OF_WEEK CURRENT":
        return get_day_of_week_current()
    elif "GET TEMPLATE WEEK DAY " in data:
        kw, day = data.split("GET TEMPLATE WEEK DAY ")[1].split(",")
        return get_template_week_day(kw, day)
    elif "GET TEMPLATE WEEK " in data:
        return get_template_week(data.split("GET TEMPLATE WEEK ")[1])
    elif "SET TEMPLATE DAY" in data:
        data = data.split("SET TEMPLATE DAY ")[1]
        kw, day, template = data.split(",")
        return set_template_day(kw, day, template)
    elif "SET TEMPLATE WEEK" in data:
        kw, template = data.split("SET TEMPLATE WEEK ")[1].split(",")
        return set_template_week(kw, template)

def start_server():
    UDP_IP_ADRESS = "127.0.0.1"
    UDP_PORT_NO = 4242

    serverSock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    serverSock.bind((UDP_IP_ADRESS, UDP_PORT_NO))
    while True:
        data, addr = serverSock.recvfrom(1024)
        data = data.decode()
        print("Message: ", data,"From:", addr, end="")
        data_to_send = process_request(data)
        serverSock.sendto(str.encode(data+"|"+data_to_send),("127.0.0.1", 4241))
        print("sent:", str.encode(data_to_send))



def load_day_unsafe(path):
    f = open(path, "r")
    day = f.read()
    f.close()
    return day.splitlines()

def save_day(path, day):
    f = open(path, "w")
    string = ""
    for i in day:
        string += i + "/n"
    f.write(string)
    f.close()

def string_to_time(date, string):
    print(string)
    hour, min = string.split(".")
    return datetime.datetime(date.year, date.month, date.day, int(hour), int(min))

def get_next_gong():
    day = load_day_unsafe("./current_config/"+get_week_current()+"/"+get_day_of_week_current()+".day")
    print("loaded ./current_config/"+get_week_current()+"/"+get_day_of_week_current()+".day")
    days_from_today = 0
    next = datetime.date.today()
    while True:
        while True:
            for line in day:
                if not string_to_time(next, line) < datetime.datetime.now():
                    return string_to_time(next, line)
            if day == []:
                next += datetime.timedelta(days=1)
                day = load_day_unsafe("./current_config/"+str(next.isocalendar()[1])+"/"+str(next.isoweekday())+".day")
                print("continuing", next)
                days_from_today += 1
                continue
    print("ERROR")

        

def main(): #entry
    print("started")
    while True:
        print("waiting until", str(get_next_gong()))
        delay = get_next_gong()-datetime.datetime.now()
        print("that is", delay," or ",delay.total_seconds(), "as seconds")
        time.sleep(delay.total_seconds())

class ServerThread(Thread):
    def run(self):
        start_server()

class MainThread(Thread):
    def run(self):
        main()

main_thread = MainThread()
main_thread.start()
server_thread = ServerThread()
server_thread.start()

main_thread.join()

