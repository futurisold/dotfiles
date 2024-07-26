#!/bin/bash

# Function to print usage
usage() {
    echo "Usage: $0 [-r REMOTE] [-s SOURCE_DIR] [-d DESTINATION] [-t TO_SERVER] FILES..."
    echo "  -r REMOTE       Remote server (default: research-ec2-2)"
    echo "  -s SOURCE_DIR   Source directory on remote (default: devspace/SyntheticDataGenerationPipeline)"
    echo "  -d DESTINATION  Destination directory (default: /tmp)"
    echo "  -t              Transfer to server (default is from server to local)"
    echo "  FILES           Space-separated list of files/directories to transfer"
    exit 1
}

# Parse command line options
while getopts "r:s:d:th" opt; do
    case $opt in
        r) remote="$OPTARG" ;;
        s) source_dir="$OPTARG" ;;
        d) dest="$OPTARG" ;;
        t) direction="to_server" ;;
        h) usage ;;
        \?) echo "Invalid option -$OPTARG" >&2; usage ;;
    esac
done

# Shift to the file arguments
shift $((OPTIND-1))

# Check if any files were specified
if [ $# -eq 0 ]; then
    echo "Error: No files specified"
    usage
fi

# Perform the file transfer
for item in "$@"; do
    if [ "$direction" = "to_local" ]; then
        scp -r "$remote:$source_dir/$item" "$dest"
    else
        scp -r "$item" "$remote:$source_dir/"
    fi
done
