# C-b is not acceptable -- Vim uses it
set-option -g prefix C-a
bind-key C-a last-window

# Start numbering at 1
set -g base-index 1
set-window-option -g pane-base-index 1
# Allows for faster key repetition
set -s escape-time 0

# Set status bar
set -g status-bg black
set -g status-fg white
set -g status-left ""
set -g status-right "#[fg=green]#H"

# Rather than constraining window size to the maximum size of any client 
# connected to the *session*, constrain window size to the maximum size of any 
# client connected to *that window*. Much more reasonable.
setw -g aggressive-resize on

# Allows us to use C-a a <command> to send commands to a TMUX session inside 
# another TMUX session
bind-key a send-prefix

# Activity monitoring
#setw -g monitor-activity on
#set -g visual-activity on

# Example of using a shell command in the status line
#set -g status-right "#[fg=yellow]#(uptime | cut -d ',' -f 2-)"

# Highlight active window
set-window-option -g window-status-current-bg red
# use vim keys
setw -g mode-keys vi
set-window-option -g utf8 on

# Set the default terminal mode to 256color mode
set -g default-terminal "screen-256color"
