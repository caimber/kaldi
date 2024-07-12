#!/usr/bin/env bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <string_to_remove> <file>"
    exit 1
fi

# Assign input arguments to variables
string_to_remove=$1
file=$2

# Check if the given file exists
if [ ! -f "$file" ]; then
    echo "Error: File $file does not exist."
    exit 1
fi

# Escape forward slashes in the string to be removed
escaped_string=$(sed 's/[\/&]/\\&/g' <<< "$string_to_remove")


# Create a temporary file
temp_file=$(mktemp)

# Remove all instances of the specified string from the file
sed "s/$escaped_string//g" "$file" > "$temp_file"

# Replace the original file with the modified file
mv "$temp_file" "$file"

echo "All instances of '$string_to_remove' have been removed from $file."
