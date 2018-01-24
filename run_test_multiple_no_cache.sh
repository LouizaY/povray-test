#!/bin/bash

CONTAINER_NAME="povray"
OUTPUT_FILE_NAME="output-$(date +%j-%H-%M-%S).csv"
FRAME_FILE_SUFFIX="$(date +%j-%H-%M-%S).png"
NBR_LOOPS=$1
DOCKER_IMAGE=$2

# test if the number of loops to execute is less than 1
if [[ "$NBR_LOOPS" -lt "1" || "$NBR_LOOPS" == "" ]] ; then
  echo "==> error: the number of loops should be bigger that 1"
  exit 1
fi

# simple test of docker image
if [[ "$DOCKER_IMAGE" == "" ]] ; then
  echo "==> error: a docker image should be specified"
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
  apt-get install wget -y

  # always download datasets
  wget https://curate.nd.edu/downloads/7h149p3117b -O WRC_RubiksCube.inc
  wget https://curate.nd.edu/downloads/7d278s47r65 -O 4_cubes.pov
  
  # pull a latest PovRAY docker image
  docker pull $DOCKER_IMAGE

  # run the test
  docker run -it --rm --name $CONTAINER_NAME -v $PWD:/src $DOCKER_IMAGE /bin/bash -c "cd /src; ls -l; povray +I4_cubes.pov +Oframe-$i-$FRAME_FILE_SUFFIX +K.0  -H7500 -W7500; exit 0"

  # remove docker container and image
  #docker rm -f $CONTAINER_NAME > /dev/null
  # comment this line to use local cache
  docker rmi $DOCKER_IMAGE
  rm WRC_RubiksCube.inc 4_cubes.pov

  # stop counter
  ELAPSED_TIME=$(($SECONDS - $START_TIME_TEST))

  # display time
  echo "==> loop $i | elapsed time (s): $ELAPSED_TIME"
  
  # write time in output file
  echo "$i $ELAPSED_TIME" >> $OUTPUT_FILE_NAME
done

# display final message
echo "==> number of loops: $NBR_LOOPS"
echo "==> total time: $(($SECONDS - $START_TIME_TOTAL)) seconds"
