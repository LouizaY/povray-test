#!/bin/bash

DOCKER_IMAGE="bradleybossard/docker-povray"
CONTAINER_NAME="povray"
OUTPUT_FILE_NAME="output-$(date +%j-%H-%M-%S).csv"
NBR_LOOPS=$1

# test if the number of loops to execute is less than 1
if [[ "$NBR_LOOPS" -lt "1" || "$NBR_LOOPS" == "" ]] ; then
  echo "==> error: the number of loops should be bigger that 1"
  exit 1
fi

# create new output file
touch $OUTPUT_FILE_NAME

# start the test
echo "==> do $NBR_LOOPS loops"

START_TIME_TOTAL=$SECONDS

for i in $(seq $NBR_LOOPS) ; do
  # start counter
  START_TIME_TEST=$SECONDS

  # install wget and get datasets from curate
  apt-get install wget -y > /dev/null

  # test if datasets exist
  if [[ ! -f WRC_RubiksCube.inc ]]; then
    wget https://curate.nd.edu/downloads/7h149p3117b -O WRC_RubiksCube.inc > /dev/null
  fi
  if [[ ! -f 4_cubes.pov ]]; then
    wget https://curate.nd.edu/downloads/7d278s47r65 -O 4_cubes.pov > /dev/null
  fi

  # pull a latest PovRAY docker image
  docker pull $DOCKER_IMAGE > /dev/null

  # run the test
  docker run -d --name $CONTAINER_NAME -v $PWD:/src $DOCKER_IMAGE /bin/bash -c "cd /src; ls -l; povray +I4_cubes.pov +Oframe000.png +K.0  -H7500 -W7500" > /dev/null

  # remove docker container and image
  docker rm -f $CONTAINER_NAME > /dev/null
  # comment this line to use local cache
  docker rmi $DOCKER_IMAGE > /dev/null

  # stop counter
  ELAPSED_TIME=$(($SECONDS - $START_TIME_TEST))

  # display time
  echo "==> loop $i | elapsed time (s): $ELAPSED_TIME"
  
  # write time in output file
  echo "$i $ELAPSED_TIME" >> $OUTPUT_FILE_NAME
done

# display final message
echo "==> number of loops: $NBR_LOOPS"
echo "==> total time: $(($SECONDS - $START_TIME_TOTAL))"
