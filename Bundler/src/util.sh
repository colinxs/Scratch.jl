# The check for terminal output and color support is heavily inspired
# by https://unix.stackexchange.com/a/10065.
#
# Allow opt out by respecting the `NO_COLOR` environment variable.

function setupColors() {
    normalColor=""
    errorColor=""
    warnColor=""
    noteColor=""

    # Enable colors for terminals, and allow opting out.
    if [[ ! -v NO_COLOR && -t 1 ]]; then
        # See if it supports colors.
        local ncolors
        ncolors=$(tput colors)

        if [[ -n "$ncolors" && "$ncolors" -ge 8 ]]; then
            normalColor="$(tput sgr0)"
            errorColor="$(tput bold)$(tput setaf 1)"
            warnColor="$(tput setaf 3)"
            noteColor="$(tput bold)$(tput setaf 6)"
        fi
    fi
}

setupColors

function errorEcho() {
    echo "${errorColor}$*${normalColor}" >&2
}

function warnEcho() {
    echo "${warnColor}$*${normalColor}" >&2
}

function noteEcho() {
    echo "${noteColor}$*${normalColor}" >&2
}

MS_dd()
{
    blocks=`expr $3 / 1024`
    bytes=`expr $3 % 1024`
    dd if="$1" ibs=$2 skip=1 obs=1024 conv=sync 2> /dev/null | \
    { test $blocks -gt 0 && dd ibs=1024 obs=1024 count=$blocks ; \
      test $bytes  -gt 0 && dd ibs=1 obs=1024 count=$bytes ; } 2> /dev/null
}
