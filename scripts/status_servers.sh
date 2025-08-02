#!/bin/bash

# Colors for better UX
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}========== Server Status Check ==========${NC}"
echo

# Function to check if screen is installed
check_screen_installed() {
    if ! command -v screen &> /dev/null; then
        return 1
    else
        return 0
    fi
}

# Check if screen is installed
if ! check_screen_installed; then
    echo -e "${YELLOW}⚠ The 'screen' package is not installed. It is required to run servers in the background.${NC}"
    echo -e "${BLUE}Please run start_all_servers.sh first to install screen.${NC}"
    # Also check for running processes directly in case they are running without screen
    running_processes=$(ps aux | grep -v grep | grep "StarDeception.dedicated_server")
    running_count=$(echo "$running_processes" | grep -c "StarDeception.dedicated_server" 2>/dev/null || echo "0")
    
    if [ $running_count -gt 0 ]; then
        echo
        echo -e "${YELLOW}Warning: Found $running_count server process(es) running without screen:${NC}"
        echo "$running_processes" | while IFS= read -r line; do
            if [[ -n "$line" ]]; then
                pid=$(echo "$line" | awk '{print $2}')
                echo -e "${YELLOW}  PID: $pid${NC} - $line"
            fi
        done
    fi
else
    # Check for running StarDeception servers in screen sessions
    screen_sessions=$(screen -ls | grep "_session" 2>/dev/null || echo "")
    running_count=$(echo "$screen_sessions" | grep -c "_session" 2>/dev/null || echo "0")

    if [ $running_count -eq 0 ]; then
        echo -e "${YELLOW}No StarDeception servers are currently running in screen sessions.${NC}"
        
        # Also check for processes directly in case they are running without screen
        running_processes=$(ps aux | grep -v grep | grep "StarDeception.dedicated_server")
        direct_count=$(echo "$running_processes" | grep -c "StarDeception.dedicated_server" 2>/dev/null || echo "0")
        
        if [ $direct_count -gt 0 ]; then
            echo
            echo -e "${YELLOW}Warning: Found $direct_count server process(es) running without screen:${NC}"
            echo "$running_processes" | while IFS= read -r line; do
                if [[ -n "$line" ]]; then
                    pid=$(echo "$line" | awk '{print $2}')
                    echo -e "${YELLOW}  PID: $pid${NC} - $line"
                fi
            done
        fi
    else
        echo -e "${GREEN}Found $running_count running StarDeception server(s) in screen sessions:${NC}"
        echo
        echo -e "${BLUE}Running screen sessions:${NC}"
        echo "$screen_sessions" | while IFS= read -r line; do
            if [[ -n "$line" ]]; then
                echo -e "${GREEN}  $line${NC}"
            fi
        done
    fi
fi

echo

# Check server directories and their log files
server_dirs=($(find . -maxdepth 1 -type d -name "server*" | sort))

if [ ${#server_dirs[@]} -eq 0 ]; then
    echo -e "${YELLOW}No server directories found.${NC}"
else
    echo -e "${BLUE}Server directories status:${NC}"
    for dir in "${server_dirs[@]}"; do
        echo -e "${CYAN}$dir:${NC}"
        
        # Check if log file exists and show last few lines
        if [[ -f "$dir/server.log" ]]; then
            log_size=$(wc -l < "$dir/server.log" 2>/dev/null || echo "0")
            echo -e "${GREEN}  ✓ Log file exists ($log_size lines)${NC}"
            
            # Show last 3 lines of log
            echo -e "${BLUE}  Last log entries:${NC}"
            tail -n 3 "$dir/server.log" 2>/dev/null | while IFS= read -r line; do
                echo "    $line"
            done
        else
            echo -e "${RED}  ✗ No log file found${NC}"
        fi
        
        # Check if server files exist
        if [[ -f "$dir/StarDeception.dedicated_server.sh" ]]; then
            echo -e "${GREEN}  ✓ Server script present${NC}"
        else
            echo -e "${RED}  ✗ Server script missing${NC}"
        fi
        
        if [[ -f "$dir/StarDeception.dedicated_server.x86_64" ]]; then
            echo -e "${GREEN}  ✓ Server binary present${NC}"
        else
            echo -e "${RED}  ✗ Server binary missing${NC}"
        fi
        
        echo
    done
fi

echo -e "${BLUE}💡 Tips:${NC}"
echo "  • To stop all servers: ./stop_all_servers.sh"
echo "  • To view full logs: tail -f server*/server.log"
echo "  • To attach to a running server: screen -r <session_id>"
echo "  • To detach from a server session: Press Ctrl+A, then D"
echo "  • To restart servers: Stop them first, then run ./start_all_servers.sh"
