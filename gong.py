import os
import pickle
import time
import datetime

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

def main(): #entry
    day = datetime.datetime.now().date()
    t1 = datetime.datetime.now().time()
    next_gong = null
    t2 = datetime.datetime(day.year,day.month,day.day,next_gong.hour, next_gong.minute)
    print(test)



main()
#print(load_day_unsafe("presets/day/normal.day"))

