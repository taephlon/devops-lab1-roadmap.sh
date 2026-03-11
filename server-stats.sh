#!/bin/bash

# --- Server Performance Stats ---

echo "------------------------------------------"
echo " Server Stats - $(date)"
echo "------------------------------------------"

# 1. Total CPU Usage
# Calculates usage by subtracting 'idle' percentage from 100
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
echo "Total CPU Usage: ${cpu_usage}%"

# 2. Total Memory Usage (Used vs Free with %)
echo -e "\n--- Memory Usage ---"
free -m | awk 'NR==2{printf "Used: %sMB | Free: %sMB | Usage: %.2f%%\n", $3, $4, $3*100/$2}'

# 3. Total Disk Usage (Used vs Free with %)
echo -e "\n--- Disk Usage ---"
df -h --total | grep 'total' | awk '{printf "Used: %s | Free: %s | Usage: %s\n", $3, $4, $5}'

# 4. Top 5 Processes by CPU Usage
echo -e "\n--- Top 5 Processes by CPU Usage ---"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6

# 5. Top 5 Processes by Memory Usage
echo -e "\n--- Top 5 Processes by Memory Usage ---"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6

echo "------------------------------------------"
