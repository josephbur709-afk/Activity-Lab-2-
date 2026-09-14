#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Error: Please provide exactly one argument. Usage: $0 <filename.c>" >&2
    exit 1
fi

target_file="$1"

if [[ "$target_file" != *.c ]]; then
    echo "Error: '$target_file' is not a C source file (.c extension required)." >&2
    exit 1
fi

if [ ! -f "$target_file" ]; then
    echo "Error: File '$target_file' not found." >&2
    exit 1
fi

file_owner=$(ls -l "$target_file" | awk '{print $3}')
file_month=$(ls -l "$target_file" | awk '{print $7}')
file_day=$(ls -l "$target_file" | awk '{print $8}')
file_time=$(ls -l "$target_file" | awk '{print $9}')

temp_file=$(mktemp)

cat << EOF > "$temp_file"
/**
 * File Name: $target_file
 * Owner: $file_owner
 * Last Modified On: $file_month $file_day $file_time
 */
EOF

cat "$target_file" >> "$temp_file"

if mv "$temp_file" "$target_file"; then
    echo "Successfully added header to $target_file"
else
    echo "Error: Failed to overwrite $target_file" >&2
    rm -f "$temp_file"
    exit 1
fi
