# upload2-aws-bucket

This is just a `bash` wrapper script around the `ec2-import-instance`. I just found it too tedious to remember all the options! 


## Installation

Clone the Git repo to your favourite location on your favourite server

### Options in the script

When you have cloned the Git repo, you will need to set the following variables

* The AWS username and password
* AWS Region 

	AWS_USERNAME="AWS_USERNAME"
	AWS_PASSWORD="AWS_PASSWORD"
	REGION=ap-southeast-2

* You might have different AWS IAM Policies so the AWS Bucket username and password will/might be different. Change accordingly.

	# Specify the AWS Bucket Username and password. 
	BUCKET_USERNAME="AWS_USERNAME"
	BUCKET_PASSWORD="AWS_PASSWORD"

* Platform options - By default, the script assumes that its a Linux RAW image. If you want to change this to Windows, then change the `PLATFORM` variable to `Windows`

	PLATFORM=Linux


### Running the script

	$ ./upload2-aws-bucket.sh 
	Usage: ./upload2-aws-bucket.sh -b AWS-Bucket-Name -f filename.raw -t instance-type

	OPTIONS:
	  -b  AWS Bucket Name
	  -f  File name that you wish to upload. Must be in raw format
	  -t  AWS Instance type, eg t2.medium




### Tips 

* You need the Linux images in the RAW format.
* I find it much easier to `rsync` the RAW images to the `AWS Linux instance` and then running this script, or you are going to have time outs and other sorts of griefs.


### Trouble shooting

This page is pretty decent, should you get stuck http://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-troubleshooting.html

### Improvements?

* Send me a suggestion or a Pull Request.


