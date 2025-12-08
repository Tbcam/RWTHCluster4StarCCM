# ------------------------------------------------------
# Uncomment the following line if you want to switch
# to another login shell, e.g. bash.
# ------------------------------------------------------

#source /usr/local_host/etc/switch_login_shell bash
alias helpalias='echo -e "
current version: 251208
#fireandforget: Runs all the *.sim files inside your hpcwork/<yourTIMcode> folder. Especially useful to do multiple simulations at once.
#go2dir: Goes to your working directory
#simdir <Simulation name>: Creates simulation directory
#simdirgo <Simulation name>: Creates simulation directory then goes inside that folder.(so you can directly use \"runsim\")
#runsim: Starts the full simulation jobchain
#sl: Shows pending and running simulations
#followup: Shows live update of the last created report file. So you can check you sim process from terminal
#w1sl: Shows pending and running simulations live
#run1sim: Starts just the simulation batch (you can change SLURMbatchSim.txt file to something else)
#run1eval: Starts just the evaluation/pospro
#usage: Shows CPUh usage for all of the project for more results use with numbers. Example: usage 12 shows last 12 months. 
#billing: Shows CPUh usage(billing) for each job you have done last 30 days (you can change this number)
#updatealias: Runs update for aliases. Usefull for getting any new aliases or fixes.
#helpalias: Basicly shows what is written in here.
#starccmdownloader:Adds a module load line for existing template so selected version of starccm+ can be used. Current version Simcenter STAR-CCM+ 2406.0001 Build 19.04.009 (linux-x86_64-2.28/gnu11.4)
#clusterinfo:Shows how much of the cluster in in use

further info:
   ecurieaix.qwikinow.de/content/3dbc5542-f955-4cda-a9ff-ec3618338842?title=qol-improvements-for-rwth-cluster-users
Current contact:TABO (last updated 11/11/2025)"'
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
alias clusterinfo=“sinfo -O Partition,NodeAIOT,CPUsState:30”
usage() {
  local months="$1"
  local cmd=(r_wlm_usage -p p0020102)

  if [[ -n "$months" ]]; then
    cmd+=(-m "$months")
  fi

  "${cmd[@]}"
}
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
      cd "${1%%.*}"
      return 0
    fi
    echo "Waiting..."
    sleep 0.5
  done

  echo "Directory '$1' not found after waiting."
  return 1
}

# starccmdownloader: scan *.txt in current dir, and:
# - if file contains 'starccm+' AND the exact line '### load modules'
#     -> insert (if missing after the marker):
#        1) "### to get selected version..." (only if missing)
#        2) "module load STAR-CCM+/19.04.009" (unless already present)
# - if '### load modules' is missing -> log and skip (do not touch file)
# - if module line already exists -> log and skip (do not touch file)
# - write a short report to RepTABOsAwsomeLoader.txt (ASCII only)
starccmdownloader() {
  local report="RepTABOsAwsomeLoader.txt"
  local version_line="### to get selected version of starccm current is Simcenter STAR-CCM+ 2406.0001 Build 19.04.009 (linux-x86_64-2.28/gnu11.4)"
  local module_line="module load STAR-CCM+/19.04.009"
  local marker_re='^### load modules$'
  local now; now="$(date '+%Y-%m-%d %H:%M:%S')"

  : > "$report"
  {
    echo "RepTABOsAwsomeLoader - run @ $now"
    echo "Folder: $(pwd)"
    echo "Rule: touch only files that contain 'starccm+' AND the marker '### load modules'."
    echo "If marker missing: log and skip (as requested: \"if ### load modules doesnt not exist log\")."
    echo "Add directly under the first marker:"
    echo "  - $version_line (only if missing)"
    echo "  - $module_line (unless it already exists)"
    echo "-----"
  } >> "$report"

  local anytxt=0 edited=0 skipped_nomarker=0 skipped_nomatch=0 skipped_has_module=0

  setopt LOCAL_OPTIONS NULL_GLOB
  for f in *.txt; do
    anytxt=1

    # Must contain 'starccm+'
    if ! grep -qi 'starccm\+' "$f"; then
      echo "[SKIP] $f - no 'starccm+' found." >> "$report"
      ((skipped_nomatch++))
      continue
    fi

    # Must contain the exact marker line
    if ! grep -qE "$marker_re" "$f"; then
      echo "[SKIP] $f - '### load modules' not found; logged per spec; file untouched." >> "$report"
      ((skipped_nomarker++))
      continue
    fi

    # If module line already present, do not touch
    if grep -Fq "$module_line" "$f"; then
      echo "[OK]   $f - module line already present; file untouched." >> "$report"
      ((skipped_has_module++))
      continue
    fi

    # Decide whether version line is needed
    local need_version=1
    grep -Fq "$version_line" "$f" && need_version=0

    # Insert immediately AFTER the first '### load modules' line
    local tmp; tmp="$(mktemp)"
    awk -v marker_re="$marker_re" \
        -v need_version="$need_version" \
        -v version_line="$version_line" \
        -v module_line="$module_line" '
      BEGIN{added=0}
      {
        print
        if (!added && $0 ~ marker_re) {
          if (need_version == 1) print version_line
          print module_line
          added=1
        }
      }' "$f" > "$tmp" && mv "$tmp" "$f"

    echo "[SUCCESS] $f - inserted:" >> "$report"
    if (( need_version == 1 )); then
      echo "          - $version_line" >> "$report"
    fi
    echo "          - $module_line" >> "$report"
    ((edited++))
  done

  {
    echo "-----"
    if (( anytxt == 0 )); then
      echo "[INFO] No .txt files in this folder."
    else
      echo "[SUMMARY] edited=$edited, skipped_no_marker=$skipped_nomarker, skipped_no_starccm=$skipped_nomatch, skipped_has_module=$skipped_has_module"
    fi
    echo "Done."
  } >> "$report"

  echo "Report written to $report"
}
