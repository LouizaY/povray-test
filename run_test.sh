#!/bin/bash

# start counter
START_TIME=$SECONDS

# install wget and get datasets from curate
apt-get install wget -y

# test if datasets exist
if [ ! -f WRC_RubiksCube.inc ]; then
  wget https://curate.nd.edu/downloads/7h149p3117b -O WRC_RubiksCube.inc
fi
if [ ! -f 4_cubes.pov ]; then
  wget https://curate.nd.edu/downloads/7d278s47r65 -O 4_cubes.pov
fi

# pull a latest PovRAY docker image
docker pull bradleybossard/docker-povray

# run the test
docker run -it --rm -v $PWD:/src bradleybossard/docker-povray /bin/bash -c "cd /src; ls -l; povray +I4_cubes.pov +Oframe000.png +K.0  -H7500 -W7500"

# stop counter
ELAPSED_TIME=$(($SECONDS - $START_TIME))

# display time
echo "Elapsed time: $ELAPSED_TIME seconds"

