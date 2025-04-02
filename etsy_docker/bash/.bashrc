PS1='\u@\h:\W \$ '
alias ll='ls -alF'

# start syslog in the background so we avoid those nasty errors from the Vitess binaries
/usr/local/bin/syslog &

cd "${HOME}"
