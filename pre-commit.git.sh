#!/bin/sh
#

# A git hook script to find and fix trailing whitespace
# in your commits. Bypass it with the --no-verify option
# to git-commit
#

# detect platform
platform="win"
uname_result=`uname`
if [[ "$uname_result" == "Linux" ]]; then
  platform="linux"
elif [[ "$uname_result" == "Darwin" ]]; then
  platform="mac"
fi

# Find files with trailing whitespace
if [[ "$platform" == "win" ]]; then
  for FILE in `git diff --check --cached | sed '/^[+-]/d' | sed -r 's/:[0-9]+: .*//' | uniq` ; do
    echo -e "auto remove trailing whitespace in \033[31m$FILE\033[0m!"
    # since $FILE in working directory isn't always equal to $FILE in index, so we backup it
    mv -f "$FILE" "${FILE}.save"
    # discard changes in working directory
    git checkout -- "$FILE"
    # remove trailing whitespace
    # in windows, `sed -i` adds ready-only attribute to $FILE(don't kown why), so we use temp file instead
    sed 's/[[:space:]]*$//' "$FILE" > "${FILE}.bak"
    mv -f "${FILE}.bak" "$FILE"
    git add "$FILE"
    # restore the $FILE
    sed 's/[[:space:]]*$//' "${FILE}.save" > "$FILE"
    rm "${FILE}.save"
  done
elif [[ "$platform" == "mac" ]]; then
  for FILE in `git diff --check --cached | sed '/^[+-]/d' | sed -E 's/:[0-9]+: .*//' | uniq` ; do
    echo "auto remove trailing whitespace in \033[31m$FILE\033[0m!"
    # since $FILE in working directory isn't always equal to $FILE in index, so we backup it
    mv -f "$FILE" "${FILE}.save"
    # discard changes in working directory
    git checkout -- "$FILE"
    # remove trailing whitespace
    sed -i "" -E 's/[[:space:]]*$//' "$FILE"
    git add $FILE
    # restore the $FILE
    sed 's/[[:space:]]*$//' "${FILE}.save" > "$FILE"
    rm "${FILE}.save"
  done
else
  # TODO(lixianliang): test for linux
  for FILE in `git diff --check --cached | sed '/^[+-]/d' | sed -r 's/:[0-9]+: .*//' | uniq` ; do
    echo "auto remove trailing whitespace in \033[31m$FILE\033[0m!"
    # since $FILE in working directory isn't always equal to $FILE in index, so we backup it
    mv -f "$FILE" "${FILE}.save"
    # discard changes in working directory
    git checkout -- "$FILE"
    # remove trailing whitespace
    sed -i 's/[[:space:]]*$//' "$FILE"
    git add $FILE
    # restore the $FILE
    sed 's/[[:space:]]*$//' "${FILE}.save" > "$FILE"
    rm "${FILE}.save"
  done
fi

if [[ "x`git status -s | grep '^M'`" == "x" ]]; then
  # empty commit
  echo
  echo "NO CHANGES ADDED, ABORT COMMIT!"
  exit 1
fi

# Now we can commit
exit


