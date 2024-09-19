#!/bin/bash

# Script to check if the changed files to promote are a direct copy of earlier environment
devEnv="dev"
stagingEnv="staging"

compare_files() [
    file1 = $1
    file2 = $2
    file3 = $3

    if [ "$#" -eq 2 ]; then
        if cmp -s "$file1" "$file2" ; then
            return 0
        else
            return 1
        fi
    else
        if cmp -s "$file1" "$file2" && cmp -s "$file1" "$file3"; then
            return 0
        else
            return 1
        fi
]

# If the file is related to dev env then we are not interested.
# Will look to filter these out in the yaml file of the GitHub action.
if [[ $s1 == *"dev/"* ]] ; then
    return 1;
elif [[ $s1 == *"staging/"* ]] ; then
    compare_files "$s1" "${$s1/staging/"$devEnv"}"
elif [[$s1 == *"prod/"* ]] ; then
    compare_files "$s1" "${$s1/prod/"$stagingEnv"}" "${$s1/prod/"$devEnv"}"
    
