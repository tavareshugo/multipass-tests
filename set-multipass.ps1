#### Fixed variables ####

# variables
$CoursePrefix = "test1"

# disk
$Disk = "100G"

# distribution
$Dist = "jammy"


#### Dynamic variables ####

# number CPUs (75% used)
$CPUs = $env:NUMBER_OF_PROCESSORS
$CPUs = [int][Math]::Floor([float]($CPUs) * 0.75)

# total memory (50% used)
# https://stackoverflow.com/a/45996254/5023162
$RAM = (Get-CimInstance -ClassName "cim_physicalmemory" | Measure-Object -Property Capacity -Sum).Sum/1gb
$RAM = [int][Math]::Floor([float]($RAM) * 0.5)

# user's Documents
$MyDocuments = [environment]::getfolderpath("mydocuments")

# directories that will be used to mount local dir on the VM
LocalShare="$MyDocuments/bioinfo-training/$CoursePrefix-multipass-share"
MultipassShare="/home/ubuntu/bioinfo-training/$CoursePrefix"


#### Create instance ####

# create and start the instance
multipass launch --name $CoursePrefix --cpus $CPUs --disk $Disk --memory "${RAM}G" $Dist

# create share on the local side
mkdir -p $LocalShare

# allow local user to mount local filesystem on the VM
multipass set local.privileged-mounts=true

# mount local filesystem to the image
multipass exec $CoursePrefix -- mkdir -p $MultipassShare
multipass mount $LocalShare "${CoursePrefix}:${MultipassShare}"
