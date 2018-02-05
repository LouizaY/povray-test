#!/bin/bash

CONTAINER_NAME="povray"
OUTPUT_FILE_NAME="output-$(date +%j-%H-%M-%S).csv"
FRAME_FILE_SUFFIX="$(date +%j-%H-%M-%S).png"
NBR_LOOPS=$1
DOCKER_IMAGE=$2
DATASET_NAME="pt1.pov"

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

# install wget
if [[ "$(which apt-get)" != "" ]] ; then
  DEBIAN_FRONTEND=noninteractive apt-get install wget -y
elif [[ "$(which apk)" != "" ]] ; then
  apk add --update --no-cache wget
elif [[ "$(which yum)" != "" ]] ; then
  yum -y install wget
fi

# create new output file
touch $OUTPUT_FILE_NAME

# start the test
echo "==> do $NBR_LOOPS loops"

START_TIME_TOTAL=$SECONDS

for i in $(seq $NBR_LOOPS) ; do
  # start counter
  START_TIME_TEST=$SECONDS

  # always download datasets
  wget http://www.f-lohmueller.de/pov_tut/x_sam/geo/Penrose_Triangle_1.pov -O $DATASET_NAME
  
  # pull a latest PovRAY docker image
  docker pull $DOCKER_IMAGE

  # run the test
  docker run -it --rm --name $CONTAINER_NAME -v $PWD:/src $DOCKER_IMAGE /bin/bash -c "cd /src; ls -l; povray +I$DATASET_NAME +Oframe-$i-$FRAME_FILE_SUFFIX +K.0  -H7500 -W7500; exit 0"

  # remove docker container and image
  #docker rm -f $CONTAINER_NAME > /dev/null
  # comment this line to use local cache
  docker rmi $DOCKER_IMAGE
  rm $DATASET_NAME

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