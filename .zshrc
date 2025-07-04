# ------------------------------------------------------
# Uncomment the following line if you want to switch
# to another login shell, e.g. bash.
# ------------------------------------------------------

#source /usr/local_host/etc/switch_login_shell bash
alias helpalias="echo"
fireandforget: Runs all the *.sim files inside your hpcwork/<yourTIMcode> folder. Especially useful to do multiple simulations at once.
go2dir: Goes to your working directory
simdir <Simulation name>: Creates simulation directory
simdirgo <Simulation name>: Creates simulation directory then goes inside that folder.(so you can directly use "runsim")
runsim: Starts the full simulation jobchain
sl: Shows pending and running simulations
followup: Shows live update of the last created report file. So you can check you sim process from terminal
w1sl: Shows pending and running simulations live
run1sim: Starts just the simulation batch (you can change `SLURMbatchSim.txt` file to something else)
usage: Shows CPUh usage for all of the project
billing: Shows CPUh usage(billing) for each job you have done last 30 days (you can change this number)
updatealias: Runs update for aliases. Usefull for getting any new aliases or fixes.
helpalias: Basicly shows what is written in here.

further info:
   ecurieaix.qwikinow.de/content/3dbc5542-f955-4cda-a9ff-ec3618338842?title=qol-improvements-for-rwth-cluster-users
Current contact:TABO (last updated 04/07/2025)""
alias updatealias="bash <(curl -s https://raw.githubusercontent.com/Tbcam/RWTHCluster4StarCCM/main/install-zshrc.sh)"
alias sl="squeue -t all -u ab123 -o \"%9i %.40j %.9T %.20S %.20e %.6M %.9l %.16p %.4C %.4D %30Y %a %.R\""
alias sacct="sacct  --format=JobID%-12,JobName%30,State,Start,End,Elapsed,priority,NCPUS,NODELIST%32,AveCPUFreq"
alias w1sl='watch -n1 "squeue -t all -u ab123 -o \"%9i %.40j %.9T %.20S %.20e %.6M %.9l %.16p %.4C %.4D %30Y %a %.R\""'
alias go2dir="cd /rwthfs/rz/cluster/hpcwork/ab123"
alias go2cpu="cd /rwthfs/rz/cluster/hpcwork/ab123/CPUST"
alias go2gpu="cd /rwthfs/rz/cluster/hpcwork/ab123/GPUST"
alias create1dir="java -jar createSimDir.jar"
alias runsim="sh -e SLURMshell_Jobchain.txt"
alias run1sim="sbatch SLURMbatchSim.txt"
alias run1eval="sbatch SLURMbatchEval.txt"
alias usage="r_wlm_usage -p p0020102"
alias billing="sacct -o JobName%15,Elapsed,JobID,AllocTres%70 --allocations -S $(date -d "-360 days" +%Y-%m-%d)"
alias billingextra="sacct -o JobName%15,Elapsed,JobID,AllocTres%70 -S $(date -d "-360 days" +%Y-%m-%d)"
alias followup='file="$(ls -t *.txt | head -n 1)" && cat "$file" && tail -f "$file"'

fireandforget() {
    cd /rwthfs/rz/cluster/hpcwork/ab123/"${1:-}" || { echo "Failed to enter GPUST"; return 1; }
    SECONDS=0
    sim_files=($(find . -maxdepth 1 -type f -name "*.sim"))

    if [ ${#sim_files[@]} -eq 0 ]; then
        echo "No .sim files found."
        return 1
    fi

    for sim_file in "${sim_files[@]}"; do
        sim_name=$(basename "$sim_file")  # Ensure only filename is used
        echo "Creating simulation directory for: $sim_name"
        
        java -jar createSimDir.jar "$sim_name"

        folder_name="${sim_name%.sim}"  # Expected directory name

        echo "Waiting for directory '$folder_name' to appear..."
        for i in {1..20}; do
            if [ -d "$folder_name" ]; then
                duration=$SECONDS
                echo "Directory created: $folder_name"
                echo "It took ${duration} seconds to create the directory."
                cd "$folder_name"
                sh -e SLURMshell_Jobchain.txt
                cd ..
                break
            fi
            echo "Waiting..."
            sleep 0.5
        done

        if [ ! -d "$folder_name" ]; then
            echo "Directory '$folder_name' not found after waiting."
        fi
    done

    echo "All simulation directories processed."
}


simdir() {
  if [ -z "$1" ]; then
    echo "Error>> Usage: simdir <folder_name>."
  else
    java -jar createSimDir.jar "$1"
  fi
}
simdirgo() {
  if [ -z "$1" ]; then
    echo "Error>> Usage: simdirgo <folder_name>."
    return 1
  fi
  echo "Creating simulation directory: $1"
  SECONDS=0
  java -jar createSimDir.jar "$1"

  echo "Waiting for directory '$1' to appear..."
  for i in {1..20}; do
    if [ -d "$1" ]; then
      duration=$SECONDS
      echo "Directory created: $1"
      echo "It took ${duration} seconds to create the directory."
      cd "$1"
      return 0
    fi
    echo "Waiting..."
    sleep 0.5
  done

  echo "Directory '$1' not found after waiting."
  return 1
}




