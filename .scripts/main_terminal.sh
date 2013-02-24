#!/bin/bash
#
# Stars termial session, with two windows:
#   1) for root, selected by default
#   2) for user, split in two equal parts vertically
#

SESSION_NAME="sys"

create_tmux_session()
{
  tmux new-session -d -s ${SESSION_NAME} -n "root" "sudo su -"
  tmux new-window -t ${SESSION_NAME} -n "user"
  tmux split-window -h
  tmux select-window -t "root"
}

create_tmux_session
urxvt -name "main_terminal" -e bash -c "tmux attach -t ${SESSION_NAME}"
