#!/bin/bash

# Script to check if the changed files to promote are a direct copy of earlier environment

devEnv="dev"
stagingEnv="staging"


# Function to compare the files, file1 is our original file passed to the script followed by two possible further files
compare_files() {
    file1=$1
    file2=$2
    file3=$3

    # Check the number of arguments passed to the function for comparison
    if [ "$#" -eq 2 ]; then
        if cmp -s "$file1" "$file2" ; then
            echo $((0))
        else
            echo $((1))
        fi
    else
        if cmp -s "$file1" "$file2" && cmp -s "$file1" "$file3"; then
            echo $((0))
        else
            echo $((1))
        fi
    fi
}

# Check the file path to determine if it's from staging or prod folder
# If it's staging we pass it along with a url to the file in dev folder.
# If it's from prod we pass both the staging and dev file also for comparison
#path=$1
for file in $1; do
    path=$file
    if [[ $file == *"staging"* ]] ; then
        compare_files "$file" "${path/staging/"$devEnv"}"
    else
        compare_files "$file" "${path/prod/"$stagingEnv"}" "${path/prod/"$devEnv"}"
    fi
done    
