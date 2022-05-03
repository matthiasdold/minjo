#!/usr/bin/env bash


OUTFILE="0_combined_journal.md"

# Clear the file
echo "" > "$OUTFILE"

# get individual content
files=(20*.md)
for ((i=${#files[@]}-1; i>=0; i--)); do
    echo "# ${files[$i]}" | sed -e "s/.md//g" >> "$OUTFILE"

    # increase heading by one #
    cat "${files[$i]}" | sed -e "s/^#/##/g" >> "$OUTFILE"
    echo -e "\n" >> "$OUTFILE"

done;
