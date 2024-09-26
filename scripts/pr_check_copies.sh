#!/bin/bash

# Script to check if the changed files to promote are a direct copy of earlier environment

devEnv="dev"
stagingEnv="staging"

compare_files() {
    file1=$1
    file2=$2
    file3=$3

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

# If the file is related to dev env then we are not interested.
# Will look to filter these out in the yaml file of the GitHub action.

path=$1
if [[ $1 == *"staging"* ]] ; then
    compare_files "$1" "${path/staging/"$devEnv"}"
else
    compare_files "$1" "${path/prod/"$stagingEnv"}" "${path/prod/"$devEnv"}"
fi
    
