## This tool is designed to spin up about $10 of AWS IOT greegrass usage

Runs in us-east-1

Each Greangrass core costs $0.16/mo. Once a greengrass core device connects to a core  = one month of usage

$10 / $0.16 = 62.5 active cores in a month, the first 3 land in free tier. To be safe we'll create 70 cores and connections

# Steps

1. Create 70 Greegrass Groups & Cores
  * Create a new Greengrass Group in the cloud
			We will create a Greengrass Group using the name you entered. Greengrass Groups represent your deployed local
			environment. They contain IoT Things that represent your Greengrass Core, IoT Devices, Lambda functions, and
			routing information. Together, this definition specifies how your devices respond to messages and communicate
			with each other and the cloud.
	* Provision a new Core in the IoT Registry and add to the Group
			We will create an IoT Thing that represents the Core. The IoT Thing contains metadata about your device,
			including its thing type, thing attributes, and a certificate used for communicating with the cloud.
	* Generate public and private key set for your Core
			Greengrass Cores authenticate with AWS IoT by using X.509 certificates and a public and private key pair.
			We will generate this key pair.
	* Generate a new security certificate for the Core using the keys
			Greengrass Cores authenticate with AWS IoT by using X.509 certificates. This uses the key pair created above to
			create an X.509 certificate. The certificate will be associated with the IoT Thing that represents your Greengrass Core.
	* Attach a default security policy to the certificate
			We will create an IoT policy with default permissions that will allow your Greengrass Core to connect to the cloud.

2. Create 10 EC2 t2.nano devices at a time, assign each one to the core and make the connection
