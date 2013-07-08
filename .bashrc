git_ps1() {
    __git_ps1 "%s"
}

hg_ps1() {
    hg prompt "{branch}{ at {bookmark}}{ (status: {status})} " 2> /dev/null
}

export PS1='\n\[\033[33m\]\w\[\033[0m\] \[\033[32m\]$(git_ps1)$(hg_ps1)\[\033[0m\]\n$ '
