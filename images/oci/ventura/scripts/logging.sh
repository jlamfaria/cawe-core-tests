LOG_FILE="/Users/admin/Library/Logs/CAWE/cawe.log"

# Function to redirect the output to the log file with timestamps
log() {
  exec > >(while read line; do echo "[$(date +'%Y-%m-%d %H:%M:%S')] $line" | tee -a "$LOG_FILE"; done)
  exec 2>&1
}
