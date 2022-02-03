import os
import pickle
import time
import datetime
import socket
import shutil
import filecmp
import threading
import multiprocessing


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
            if not filecmp.cmp("./presets/week/"+template+"/"+ day, "./current_config/"+kw+"/"+day, shallow=False):
                all_identical = False
        if all_identical:
            return template
    return "Custom" # this should not happen
        

def get_template_week_day(kw, day):
    for template in get_templates_day_arr():
        if filecmp.cmp("./presets/day/"+template+".day", "./current_config/"+kw+"/"+day+".day", shallow=False):
            return template
    return "Custom"

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

def set_change_template_week(name, day_templates):
    if not os.path.exists("./presets/week/"+ name):
        os.mkdir("./presets/week/"+name)
    day = 1
    for template in day_templates:
        shutil.copy("./presets/day/"+template+".day", "./presets/week/"+name+"/"+str(day)+".day")
        day += 1
    open("./presets/week/"+name+"/6.day","a").close()
    open("./presets/week/"+name+"/7.day","a").close()
    return str(True)

def set_change_template_day(name, times):
    if not os.path.exists("./presets/day/"+name+".day"):
        open("./presets/day/"+name+".day","a").close()
    for time in times:
        save_day("./presets/day/"+name+".day", times)
    return str(True)

def get_info_template_week(name):
    week_templates = get_templates_week_arr()
    if name in week_templates:
        templates = []
        for path in range(0,7):
            matches_one_template = False
            for template in get_templates_day_arr():
                if filecmp.cmp("./presets/day/"+template+".day", "./presets/week/"+name+"/"+str(path+1)+".day", shallow=False):
                    templates.append(template)
                    matches_one_template = True
            if not matches_one_template:
                templates.append("CUSTOM")
        as_string = ""
        for i in templates:
            as_string += i+ ","
        return as_string.rstrip(",")

    return "FAILED"

def get_info_template_day(name):
    day = load_day_unsafe("./presets/day/"+name+".day")
    as_string = ""
    for i in day:
        as_string += i + ","
    return as_string.rstrip(",")

def process_request(data, pipe):
    print("processing",end="")
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
        pipe.send_bytes(b"")
        return set_template_day(kw, day, template)
    elif "SET TEMPLATE WEEK" in data:
        kw, template = data.split("SET TEMPLATE WEEK ")[1].split(",")
        pipe.send_bytes(b"")
        return set_template_week(kw, template)
    elif "SET CHANGE TEMPLATE WEEK" in data:
        data = data.split("SET CHANGE TEMPLATE WEEK ")[1]
        day_templates = data.split(",")[1].split("\n")
        day_templates.pop(0)
        pipe.send_bytes(b"")
        return set_change_template_week(data.split(",")[0],day_templates)
    elif "SET CHANGE TEMPLATE DAY" in data:
        data = data.split("SET CHANGE TEMPLATE DAY ")[1]
        times = data.split(",")[1].split("\n")
        times.pop(0)
        pipe.send_bytes(b"")
        return set_change_template_day(data.split(",")[0], times)
    elif "GET INFO TEMPLATE DAY " in data:
        data = data.split("GET INFO TEMPLATE DAY ")[1]
        return get_info_template_day(data)
    elif "GET INFO TEMPLATE WEEK " in data:
        data = data.split("GET INFO TEMPLATE WEEK ")[1].strip()
        return get_info_template_week(data)
    elif data == "PLAY GONG":
        play_gong()
        return str(True)

def start_server(pipe):
    UDP_IP_ADRESS = "127.0.0.1"
    UDP_PORT_NO = 4242

    serverSock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    serverSock.bind((UDP_IP_ADRESS, UDP_PORT_NO))
    while True:
        data, addr = serverSock.recvfrom(1024)
        data = data.decode()
        print("Message: ", data,"From:", addr, end="")
        data_to_send = process_request(data, pipe)
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
        string += i + "\n"
    f.write(string)
    f.close()

def string_to_time(date, string):
    hour, min = string.split(".")
    return datetime.datetime(date.year, date.month, date.day, int(hour), int(min))

def get_next_gong():
    day = load_day_unsafe("./current_config/"+get_week_current()+"/"+get_day_of_week_current()+".day")
    print("loaded ./current_config/"+get_week_current()+"/"+get_day_of_week_current()+".day")
    next = datetime.date.today()
    while True:
        while True:
            gong_left_today = False
            for line in day:
                if string_to_time(next, line) > datetime.datetime.now():
                    return string_to_time(next, line)
                    gong_left_today = True
            if day == [] or not gong_left_today:
                next += datetime.timedelta(days=1)
                day = load_day_unsafe("./current_config/"+str(next.isocalendar()[1])+"/"+str(next.isoweekday())+".day")
                print("loaded ./current_config/"+str(next.isocalendar()[1])+"/"+str(next.isoweekday())+".day")
                continue
    print("ERROR")

def play_gong():
    os.system("mpg321 Gong_klavier.mp3")

def main(): #entry
    print("started")
    while True:
        print("waiting until", str(get_next_gong()))
        delay = get_next_gong()-datetime.datetime.now()
        print("that is", delay," or ",delay.total_seconds(), "as seconds")
        time.sleep(delay.total_seconds())
        play_gong()

main_thread = multiprocessing.Process(target=main, name="main_thread")
main_thread.start()
(recieve, transmit) = multiprocessing.Pipe()
server_thread = multiprocessing.Process(target=start_server, name="server_thread", args=[transmit])
server_thread.start()
while True:
    recieve.recv_bytes()
    print("")
    print("something was updated, restarting timer")
    main_thread.terminate()
    main_thread = multiprocessing.Process(target=main, name="main_thread")
    main_thread.start()

