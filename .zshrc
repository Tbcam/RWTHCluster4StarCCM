# ------------------------------------------------------
# Uncomment the following line if you want to switch
# to another login shell, e.g. bash.
# ------------------------------------------------------

#source /usr/local_host/etc/switch_login_shell bash

alias sl="squeue -t all -u ab123 -o \"%9i %.40j %.9T %.20S %.20e %.6M %.9l %.16p %.4C %.4D %30Y %a %.R\""
alias w1sl='watch -n1 "squeue -t all -u pa110240 -o \"%9i %.40j %.9T %.20S %.20e %.6M %.9l %.16p %.4C %.4D %30Y %a %.R\""'
alias go2dir="cd /rwthfs/rz/cluster/hpcwork/ab123"
alias create1dir="java -jar createSimDir.jar"
alias runsim="sh -e SLURMshell_Jobchain.txt"
alias run1sim="sbatch SLURMbatchSim.txt"
alias usage="r_wlm_usage -p p0020102"
alias billing="sacct -o JobName%15,Elapsed,JobID,AllocTres%70 --allocations -S $(date -d "-360 days" +%Y-%m-%d)"
alias billingextra="sacct -o JobName%15,Elapsed,JobID,AllocTres%70 -S $(date -d "-360 days" +%Y-%m-%d)"
alias followup='file="$(ls -t *.txt | head -n 1)" && cat "$file" && tail -f "$file"'
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


