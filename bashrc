HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=20000
HISTFILESIZE=20000

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

function kubedelete(){
  kubectl get pods |grep $1 | awk '{print $1}' | xargs -- kubectl delete pods &
}

function kubepod(){
  kubectl get pods | grep $1
}

function kubewpod(){
 watch "kubectl get pods | grep $1"
}

function kubelog(){
  kubectl logs $1 --follow
}

function kubedeleteall(){
  kubectl get ${1}|grep -v NAME|awk '{print $1'}|xargs -- kubectl delete --now ${1} 
}

function kubeconfig(){
  export KUBECONFIG=${1}
}

alias kb=kubectl

function knodes(){
  FILTER='.*'
  while [[ ! -z $1 ]]; do
    case ${1} in
      -l)
        LABELS="--show-labels"
        shift
      ;;
      -f)
        shift
        FILTER=${1}
        LABELS="--show-labels"
        ;;
    esac
    shift
  done
  kubectl get nodes $LABELS | egrep "${FILTER}" | awk '{print $1,$2,$3,$4,$5}'

}

function pods(){
  if [ "${1}" != "" ]; then
   kubectl get pods -n ${1}
  else
    kubectl get pods
  fi
}

alias allpods="kubectl get pods --all-namespaces"
alias wpods="watch kubectl get pods"
