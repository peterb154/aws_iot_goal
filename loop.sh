#!/usr/bin/env bash

#export AWS_PROFILE=css-lab2
export AWS_DEFAULT_REGION=us-east-1

set -e

if [ ! -d venv ]; then
    virtualenv venv
    . ./venv/bin/activate
    pip install -r requirements.txt
fi

mkdir -p ~/tmp
cd ~/tmp
if [ ! -d greengo ]; then
    git clone https://github.com/dzimine/greengo.git
fi
cd greengo

if [ -f ~/tmp/count.txt ]; then
    count=`cat ~/tmp/count.txt`
else
    count=1
fi
while [ $count -lt 60 ]; do
    echo "----------------COUNT $count"
    sed -i -e s/"^  name:.*"/"  name: GreengoGroup_${count}"/ greengo.yaml
    sed -i -e s/"^  - name: Greengo.*"/"  - name: GreengoGroup_${count}_core_${count}"/ greengo.yaml
    count=$(($count+1));
    greengo create
    vagrant up
    greengo deploy
    greengo remove
    vagrant destroy -f
    echo $count > ~/tmp/count.txt
done
