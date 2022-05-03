#!/usr/bin/env bash
#
# Script to read checked todos from the combined journal and checking in the
# individual files

CURR_DATE_FILE=""

while read -r LINE
do
    # [[ ]] for regex matching with =~
    # Non test POSIX equivalent shoud be:
    # awk 'BEGIN{exit !(ARGV[1] ~ ARGV[2])}' $LINE '^# ([0-9]{4}_[0-9]{2}_[0-9]{2})'
    date_pat='^# ([0-9]{4}_[0-9]{2}_[0-9]{2})$'
    if [[ $LINE =~ $date_pat ]]; then
        # echo "Setting CURR_DATE=${BASH_REMATCH[1]}"
        CURR_DATE_FILE="${BASH_REMATCH[1]}.md"
    fi

    if [ "$CURR_DATE_FILE" != "" ]; then
        # split in TODO box + rest of string
        # echo "-------"
        # echo "$LINE"
        # echo "-------"

        todo_pat='^[\*\-\s]?\s?\[.?\] (.+)'
        if [[ $LINE =~ $todo_pat ]]; then

            SEARCH_LINE=$(echo "${BASH_REMATCH[1]}" | sed -e 's/[]\/$*.^|[]/\\&/g')
            ESC_SEARCH_LINE="^[\*\-\s]?\s?\[.?\] $SEARCH_LINE"

            # SEARCH_LINE=$(echo "$LINE" | sed -r 's/\[.?\]/\[\.\]/g') #sed -e 's/\[.?\]/\[\.\* <><>\]/g')
            # try to replace the line

            # Escape line and search_line
            ESC_LINE=$(echo "$LINE" | sed -e 's/[]\/$*.^|[]/\\&/g')

            #echo "--------------------------------"
            # echo $CURR_DATE_FILE
            # echo $SEARCH_LINE
            #echo $ESC_SEARCH_LINE
            # echo $LINE
            #echo $ESC_LINE
            #echo "--------------------------------"

            sed -i -r "s/$ESC_SEARCH_LINE/$ESC_LINE/g" $CURR_DATE_FILE || echo $ESC_SEARCH_LINE             # Or is only executed if sed fails
        fi
    fi
done < <(cat "0_combined_journal.md")
