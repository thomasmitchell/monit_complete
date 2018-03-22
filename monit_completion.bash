#!/bin/bash

# bash completion for monit


_monit_process_names() {
  COMPREPLY=($(compgen -W "$(monit summary | grep Process | grep -o "'.*'" | tr -d "'") all" \
      "${COMP_WORDS[$COMP_CWORD]}"))

}

_monit_commands() {
  COMPREPLY=($(compgen -W "start stop restart monitor unmonitor reload
              status summary quit validate procmatch" \
            "${COMP_WORDS[$COMP_CWORD]}"))
}

_monit() {
  _monit_current_token=1
  local cmd
  while [[ "$_monit_current_token" -lt "$COMP_CWORD" ]]; do
    local s="${COMP_WORDS[_monit_current_token]}"
    _monit_current_token="$((++_monit_current_token))"
    case "$s" in
      -*) #Ignore flags
        ;;
      *)
        cmd="$s"
        break
        ;;
    esac
  done

  if [[ -z $cmd ]]; then
    _monit_commands
    return 0
  fi

  case "$cmd" in
    start|stop|restart|monitor|unmonitor) _monit_process_names ;;
    *) ;;
  esac
}

complete -F _monit monit