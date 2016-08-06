#!/usr/bin/env bash

#Copyright 2016 Kumar Jadav
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License


# Color scheme
red=`tput setaf 1`
reset=`tput sgr0`

# Specify the AWS Username and password
AWS_USERNAME="AWS_USERNAME"
AWS_PASSWORD="AWS_PASSWORD"
REGION=ap-southeast-2

# Specify the AWS Bucket Username and password. 
BUCKET_USERNAME="AWS_USERNAME"
BUCKET_PASSWORD="AWS_PASSWORD"

# ec2-import-tools options
FORMAT=RAW
ARCH=x86_64
PLATFORM=Linux

usage(){
cat << EOF
Usage: $0 -b AWS-Bucket-Name -f filename.raw -t instance-type

OPTIONS:
  -b  AWS Bucket Name
  -f  File name that you wish to upload. Must be in ${red}raw${reset} format
  -t  AWS Instance type, eg t2.medium

EOF
}

check_filename(){
  if [[ ! -f ${FILENAME} ]]; then
	echo "${red}Error${reset}: The file does not exist!"
	exit 1
  fi 
}

check_ec2_import_instance(){
  type -p ec2-import-instance > /dev/null
}


## Main
# Check if the ec2-import-instance exists. 
check_ec2_import_instance
if [[ $? != 0 ]]; then
  echo "${red}Error${reset}: ec2-import-instance not found!"
  echo "${red}Error${reset}: Check if the ec2 tools are installed."
  exit 1
fi

while getopts "f:,b:,t:,:h" opts; do
  case $opts in
	h)
	  usage
	  exit 1
	  ;;
	f)
	  FILENAME=${OPTARG}
	  ;;
	b)
	  BUCKET=${OPTARG}
	  ;;
	t)
	  INSTANCE_TYPE=${OPTARG}
	  ;;
	\?)
	  echo "${red}Error${reset}: Invalid option -${OPTARG}!" >&2
	  exit 1
	  ;;
	:)
	  echo "${red}Error${reset}: Option -${OPTARG} requires an argument!" >&2
	  exit 1
	  ;;
	*)
	  ;;
  esac
done

if [[ -z ${FILENAME} ]] || [[ -z ${BUCKET} ]] || [[ -z ${INSTANCE_TYPE} ]]; then
  usage
  exit 1
fi

# Check if the file exists!
check_filename

echo -e "File name is         : " ${FILENAME}
echo -e "AWS bucket is        : " ${BUCKET}
echo -e "AWS instance type is : " ${INSTANCE_TYPE}

read -r -p "Do you want to continue? (y/n) " response
response=${response,}

if [[ $response =~ ^(yes|y) ]]; then
  echo "Uploading to the AWS Bucket. This may take some time..."
  ec2-import-instance -O ${AWS_USERNAME} -W ${AWS_PASSWORD} --region ${REGION} \
  --instance-type ${INSTANCE_TYPE} --format ${FORMAT} --architecture ${ARCH} \
  --platform ${PLATFORM} --bucket ${BUCKET} \
  -o ${BUCKET_USERNAME} -w ${BUCKET_PASSWORD} ${FILENAME}
else
  echo "You have decided not to continue!"
  echo "Exiting"
  exit 1
fi
