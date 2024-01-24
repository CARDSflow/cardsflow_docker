#!/bin/bash

session="ros1"

tmux has-session -t $session 2>/dev/null

if [ $? == 0 ]; then
  tmux kill-session -t $session
fi

tmux new-session -s $session -d \; \
	send-keys 'cd ~/workspace/cardsflow_docker/ && docker compose up -d && docker exec -d joyfull_laplace /bin/bash -c "source /roboy.rc && roscore"' C-m\; \
	send-keys 'docker exec -ti joyfull_laplace /bin/bash -c "source /roboy.rc &&  run_kindyn"' C-m \; \
	split-window -h \; \
	send-keys "sleep 30; ssh root@192.168.1.196 -t \"bash -lic 'plexus' \"" C-m\; \
	split-window -v \; \
	send-keys 'sleep 30; ssh -t roboy@192.168.1.104 ./autostart.sh; docker exec -ti joyfull_laplace /bin/bash -c "source /roboy.rc &&  run_ik"' C-m\; \
	split-window -v \; \
	send-keys 'docker exec -ti joyfull_laplace /bin/bash -c "source /roboy.rc &&  run_wheels_connector"' C-m \; \
	split-window -v \; \
	send-keys 'sleep 5; docker exec -ti joyfull_laplace /bin/bash -c "source /roboy.rc &&  run_wheels_controller"' C-m \; \
	select-pane -t 0 \; \
	split-window -v  \; \
	send-keys 'docker exec -ti joyfull_laplace /bin/bash --rcfile /roboy.rc' C-m

