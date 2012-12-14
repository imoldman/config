# alias
alias l='ls -al --color=auto'
alias ll='ls -al'
alias ..='cd ..'
alias 1..='cd ..'
alias 2..='cd ../..'
alias 3..='cd ../../..'
alias 4..='cd ../../../..'
alias 5..='cd ../../../../..'
alias 6..='cd ../../../../../..'
alias 7..='cd ../../../../../../..'
alias 8..='cd ../../../../../../../..'
alias 9..='cd ../../../../../../../../..'
cpy () {
  python -c "print ($*)"
}

cmake_test() {
  vim ~/.cmake_tmp.cmake
  cmake $* -P ~/.cmake_tmp.cmake
}
