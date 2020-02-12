Since you have mentioned that you value solutions that will work on your workstations without modifications and that you already use terraform.
I have used only terraform (version **0.12.20** , version 0.11 or prior than that will not work).

Go inside terraform directory

```
$ cd terraform
```

Download any providers and plugins used in this assignment with 

```
$ terraform init
```

Change variables on terraform.tfvars file to your own credentials

```
aws_access_key = "AWSACCESSKEY"
aws_secret_key = "AWSSECRETKEY"
public_key_path = "~/.ssh/id_rsa.pub"
key_name = "keyname"
```

where keyname is the key name of the Key Pair to use for the instance which I presume you already have one in order to access your ec2 instances

You may also like to change file install_awsredrive.sh in order to have the desired config.json application file lines 31-40

```
[
  {
    "Alias": "#1",
    "QueueUrl": "https://sqs.eu-west-1.amazonaws.com/accountid/inputqueue1",
    "RedriveUrl": "http://nohost.com/",
    "Region": "eu-west-1",
    "Active": true,
    "Timeout": 10000
  }
]
```

Validate the code on configuration files with executing

```
$ terraform validate
```

Execute the following to see what terraform is going to build on AWS
```
$ terraform plan
```

Finally execute 
```
$ terraform apply
```

This will build 

- a vpc called xeasgnmnt-vpc with cidr 10.10.0.0/16
- an internet gateway
- a vpc subnet called xeasgnmnt-subnet-v1a with cidr 10.10.1.0/24 in us-east-1a availability zone
- a security group called xeasgnmnt-SG which allows incoming connections from everywhere only to port 22 and allows outgoing connections to everywhere
- an ec2 instance called awsredrive01 , type t2.micro, ebs volume of 15 GB for OS, Debian 9 (Stretch)


When the ec2 instance is ready then terraform will copy install_awsredrive.sh shell script to the instance using file provisioner and then execute it with remote-exec provisioner.

This script will update apt's cache and then install the following tools 

- curl needed to download the application
- unzip needed to unzip the zip bundle to a specific directory
- supervisor needed to daemonize the application

Then the script will download the zip bundle from github, unzip it under /opt/awsredrive/non-ansible-releases directory and make AWSRedrive.console file executable
It will then create a configuration file for this application on supervisor.
It will create config.json file under /opt/awsredrive/non-ansible-releases directory.
Finally a symbolic link of /opt/awsredrive/non-ansible-releases directory to /opt/awsredrive/current will be created


When terraform finishes it will print out the IP address of the ec2 instance created. You may also get that with executing

```
$ terraform output
```

You may ssh on that instance using username admin. This user has full passwordless sudo access.

You may see the status of the application executing as root
```
# supervisorctl status
```

To stop the application execute as root
```
# supervisorctl stop awsredrive:awsredrive0
```

If you make any changes on supervisor config file for awsredrive located on /etc/supervisor/conf.d/awsredrive.conf then you need to reload supervisor with
```
systemctl reload supervisor
```

Log files can be found on /var/log/supervisor/awsredrive.log and on /opt/awsredrive/current/logs/YYYY-MM-dd/awsredrive.txt


Notes
-----

I would prefer to use a configuration management as terraform provisioner like chef or ansible in order to download and configure the application for each environment (dev/staging and production). For ansible a requirement would be either to have ansible installed on your workstation or build and AWX server. For chef a chef server would be needed. Using a configuration management tool would also be more helpful to have easier deployments and intergrate that to a CI/CD tool like jenkins.

I have created 2 ansible roles that could help with the deployment which can be found under ansible directory. Since I don't know if you don't use ansible or if you have ansible installed on your workstations I won't use that as the terraform provisioner and will stick with the bash executable I have created.
The bash script created is compatible with the logic I have created on the deploy-awsredrive ansible role.

When ec2 instance is launched and you 'd like to deploy your application with ansible with ansible(version **2.9.x**) installed on your workstation just execute inside **ansible** directory. 

```
$ ansible-playbook -i '54.175.174.61,' -u admin -b app.yml
```
where 54.175.174.61 is the public IP of the ec2 instance created
