import sys, os, subprocess, time

def main(data: list):
    # when data[] is used then do it like this: 
    # put "#"" on all funtions thats in the while true loop
    # then start the program there will be a file named "info2"
    # go into it then use this format to find what you need: data[1] == line1
    subprocess.run(["python", "pissman_25_GUI.py", "R"], shell=True)
    
    main_output = []
    
    while True:
        while not os.path.exists("output.txt"):
            time.sleep(3)
        
        with open("output.txt", "r") as f:
            out = f.read()
        
        os.remove("output.txt")
            
        if out == "WLN":
            user = data[1]
            windows_ver = data[3]
            downloadsF = data[12]
            password = None
            pin = None
            EMAIL = None
        elif out == "EXIT":
            sys.exit(0)
            
        main_output.append(user)
        main_output.append(downloadsF)
        main_output.append(windows_ver)
        main_output.append(password)
        main_output.append(pin)
        main_output.append(EMAIL)
        
        if os.path.exists("outmain.txt"):
            os.remove("outmain.txt")
        
        for line in main_output:
            with open("outmain.txt", "A") as f:
                f.write(line)
            
            main_output.remove(line)
        

data = []

if sys.argv[1] == "start":
    if os.path.exists("pissman_25.bat") and os.path.exists("pissman.ps1"):
        subprocess.run(["powershell", "-ExecutionPolicy", "Bypass", "-File", "pissman.ps1"])
        time.sleep(3)
        if os.path.exists("done.txt"):
            os.startfile("pissman_25.bat")
            while not os.path.exists("info2.txt"):
                time.sleep(1.5)
                
            with open("info2.txt", "r") as f:
                bonk = f.read()
                data.append(bonk)
            
            main(data)
        else:
            with open("restart_please.txt", "w") as f:
                f.write("a")
            sys.exit(1)
elif sys.argv[1] == "restart":
    if not os.path.exists("done.txt"):
        if os.path.exists("pissman_25.bat") and os.path.exists("pissman.ps1") and os.path.exists("restart_please.txt"):
            os.remove("restart_please.txt")
            try:
                os.startfile("pissman_25.bat")
                while not os.path.exists("info2.txt"):
                    time.sleep(1.5)
                
                with open("info2.txt", "r") as f:
                    bonk = f.read()
                    data.append(bonk)
            except OSError as r:
                print(f"OSError! {r}")
                raise OSError
            except FileNotFoundError as r:
                print(f"try agen without restarting... {r}")
                raise FileNotFoundError
            
            main(data)