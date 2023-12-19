#!/bin/bash

#### Fixed variables ####

# variables
CoursePrefix="test1"

# disk
Disk="100G"

# distribution
Dist="jammy"


#### Dynamic variables ####

# number CPUs (75% used)
# bash does floor rounding by default
CPUs=$(($(sysctl -n hw.physicalcpu) * 75 / 100))

# total memory (50% used)
RAM=$(($(sysctl -n hw.memsize) / 1024 / 1024 / 1024 * 50 / 100))

# user's Documents
MyDocuments="$HOME/Documents"

# directories that will be used to mount local dir on the VM
LocalShare="$MyDocuments/bioinfo-training/$CoursePrefix-multipass-share"
MultipassShare="/home/ubuntu/bioinfo-training/$CoursePrefix"


#### Create instance ####

# create and start the instance
multipass launch --name "$CoursePrefix" --cpus "$CPUs" --disk "$Disk" --memory "${RAM}G" "$Dist"

# create share on the windows side
mkdir -p "$LocalShare"


# allow local user to mount local filesystem on the VM
multipass set local.privileged-mounts=true

# mount local filesystem to the image
multipass exec "$CoursePrefix" -- mkdir -p "$MultipassShare"
multipass mount "$LocalShare" "${CoursePrefix}:${MultipassShare}"
