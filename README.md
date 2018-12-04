## This tool is designed to spin up about $10 of AWS IOT greegrass usage

Each Greangrass core costs $0.16/mo. Once a greengrass core device connects to a core  = one month of usage

$10 / $0.16 = 62.5 active cores in a month, the first 3 land in free tier. To be safe we'll create 70 cores and connections

This script will loop 60 times, each time it will:
	1. use greengo to create a new greengrass group, core, policy, lambda etc. 
	2. use vagrant to spin up an ubuntu VM that emulates a greengrass device
	3. use greengo to deploy the lambda to the virtual greengrass device
	4. use greengo to delete the group/core/lambda etc
	5. destroy the vagrant vm

# Requirements

* Python2.7, virtualenv and pip
* virtualbox and vagrant
* git
* greengo and boto3 python modules

# Setup

	# Install OS requirements
	sudo apt-get install -y python2.7 python-pip git virtualbox

	# Install vagrant
	wget https://releases.hashicorp.com/vagrant/2.2.2/vagrant_2.2.2_linux_amd64.zip
	unzip vagrant_*_linux_amd64.zip
	sudo mv vagrant /usr/local/bin
	rm vagrant_*_linux_amd64.zip

	# clone this project
	git clone git@github.com:peterb154/aws_iot_goal.git
	cd aws_iot_goal

	# Make sure that we have an IAM role for greengrass to use
	export AWS_PROFILE=xxx
	export AWS_DEFAULT_REGION=us-east-1
	./create_role.sh

	# Install python modules	
	virtualenv venv
	. venv/bin/activate
	pip install -r requirements.txt

# Run the loop

	export AWS_PROFILE=xxx
	#if not resuming previous loop:
	rm ~/tmp/count.txt
	./loop.sh
	deactivate

# Check the cost (may take 24 hours to accumulate)

	# Install cost tool
	cd ~/
	git clone git@github.com:cloudshiftstrategies/aws_cost.git
	cd aws_cost

	# Install requirments
	python3 -m venv venv
	. venv/bin/activate
	pip install -r requirements.txt

	# Check the usage of greenreass and iot
	export AWS_PROFILE=xxx
	aws_cost -s "AWS Greengrass,AWS IoT"
