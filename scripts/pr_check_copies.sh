#!/bin/bash

# Script to check if the changed files to promote are a direct copy of earlier environment

devEnv="dev"
stagingEnv="staging"

compare_files() {
    file1=$1
    file2=$2
    file3=$3

    echo "$#"
    if [ "$#" -eq 2 ]; then
        echo "Comparing $file1 and $file2"
        if cmp -s "$file1" "$file2" ; then
            echo "Files match returning 0"
            exit 0
        else
            echo "Files do not match, returning 1"
            exit 1
        fi
    else
        if cmp -s "$file1" "$file2" && cmp -s "$file1" "$file3"; then
            echo "All files match, returning 0"
            exit 0
        else
            echo "Files do not match, returning 1"
            exit 1
        fi
    fi
}

# If the file is related to dev env then we are not interested.
# Will look to filter these out in the yaml file of the GitHub action.
echo "Running comparison"
path=$1
echo "$path"
if [[ $1 == *"staging"* ]] ; then
    compare_files "$1" "${path/staging/"$devEnv"}"
else
    compare_files "$1" "${path/prod/"$stagingEnv"}" "${path/prod/"$devEnv"}"
fi
    
