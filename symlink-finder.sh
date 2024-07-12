#!/usr/bin/env bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory> <output_file>"
    exit 1
fi

# Assign input arguments to variables
search_dir=$1
output_file=$2

# Check if the given directory exists
if [ ! -d "$search_dir" ]; then
    echo "Error: Directory $search_dir does not exist."
    exit 1
fi

# Create a temporary file to store symlinks
temp_file=$(mktemp)

# Function to get relative path using python
get_relative_path() {
    python3 -c "import os.path; print(os.path.relpath('$1', '$2'))"
}

# Find all symbolic links in the directory recursively and output to the temporary file
find "$search_dir" -type l | while read -r symlink; do
    target=$(readlink "$symlink")
    echo "$target $symlink" >> "$temp_file"
done

# Sort the temporary file and write to the output file
sort "$temp_file" > "$output_file"

# Remove the temporary file
rm "$temp_file"

echo "Symlinks and their targets have been written to $output_file in alphabetical order."
