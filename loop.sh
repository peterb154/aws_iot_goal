#!/usr/bin/env bash

#export AWS_PROFILE=css-lab2
export AWS_DEFAULT_REGION=us-east-1

set -e
LOOPS=71

# Install the python requirements
if [ ! -d venv ]; then
    virtualenv venv
    . ./venv/bin/activate
    pip install -r requirements.txt
fi

# Create a place to do the work (~/tmp/greengo)
mkdir -p ~/tmp
cd ~/tmp
if [ ! -d greengo ]; then
    git clone https://github.com/dzimine/greengo.git
fi
cd greengo

# Get the counter if it exists
if [ -f ~/tmp/count.txt ]; then
    count=`cat ~/tmp/count.txt`
else
    count=1
fi

# Main loop
while [ $count -lt $LOOPS ]; do
    echo "----------------COUNT $count"
    # Put a unique group and core name in the config file
    sed -i -e s/"^  name:.*"/"  name: GreengoGroup_${count}"/ greengo.yaml
    sed -i -e s/"^  - name: Greengo.*"/"  - name: GreengoGroup_${count}_core_${count}"/ greengo.yaml
    # Create a greengrass group & core in AWS
    greengo create
    # Bring up the local VM core emulator
    vagrant up
    # Deploy the lamda to the core
    greengo deploy
    # Remove the greengrass group & core from AWS
    greengo remove
    # Kill the local core emulator
    vagrant destroy -f
    # Increment the counter
    count=$(($count+1));
    # Update the counter file (in case the process dies)
    echo $count > ~/tmp/count.txt
done
