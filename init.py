import os

def init_current_config():
    for week in range(53):
        if not os.path.isdir("./current_config/"+str(week+1)):
            print("./current_config/"+str(week+1))
            os.mkdir("./current_config/"+str(week+1))
        for day in range(7):
            print("./current_config/" + str(week+1)+ "/"+ str(day+1)+".day")
            open("./current_config/" + str(week+1)+ "/"+ str(day+1)+".day","a").close()

init_current_config() 