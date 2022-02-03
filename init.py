import os

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

init_current_config() 
add_one_gong()