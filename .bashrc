# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias rm='rm -I'
alias cp='cp -i'
alias mv='mv -i'
alias dd='dd status=progress'
alias ll='ls -alF --time-style="+%F %T"'
alias la='ls -A'
alias l='ls -CF'
#alias octave='octave-cli'
alias vim='vimx'
alias dot2eps='dot -Teps -O'
alias mpv-stream-record='mpv --stream-record="output-$(date +"%Y-%m-%dT%H%M%S").ts"'
alias markdown='markdown -f +fencedcode'
# allow bash to process alias after sudo
alias sudo='sudo '
alias youtube-dlp='yt-dlp --cookies-from-browser firefox --mark-watched --live-from-start'
alias spleeter-podman='podman run -v $(pwd)/spleeter-output:/output deezer/spleeter-gpu:3.8 separate -o /output'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
#alias Discord='flatpak run com.discordapp.Discord'

HISTSIZE=10000
