#!/usr/bin/env bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Assign input argument to variable
input_file="$1"

# Check if the given input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: File $input_file does not exist."
    exit 1
fi

# Read each line from the input file
while IFS= read -r line; do
    # Extract target and symlink path from each line
    target=$(echo "$line" | awk '{print $1}')
    symlink_path=$(echo "$line" | awk '{print $2}')

    # Check if symlink path already exists as a directory or file
    if [ -e "$symlink_path" ]; then
        echo "Symlink path $symlink_path already exists."

        # Check if it's a directory and delete it recursively
        if [ -d "$symlink_path" ]; then
            echo "Deleting directory $symlink_path"
            rm -r "$symlink_path"
        else
            # If it's a file, delete it
            echo "Deleting file $symlink_path"
            rm "$symlink_path"
        fi
    else
        continue
    fi

    # Create symlink
    ln -s "$target" "$symlink_path"
    echo "Created symlink: $symlink_path -> $target"
done < "$input_file"
