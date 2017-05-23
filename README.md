# set-route53
Create a CNAME entry in Route 53 for an EC2 host, based on the "Name" EC2 tag of the instance

## software requirements
* wget
* awscli

## environment requirements
* a "Name" tag on the EC2 instance
* a zone hosted in Route 53 to which you will add the domain
* the zone should be specified to the script either through
  * a "Zone" tag on the EC2 instance
  * or the ZONE variable set in the script
  
  this zone should include a trailing dot (.)
* appropriate credentials to update Route 53
  * this can be provided by running `aws configure`, which populates `~/.aws/credentials`
  * or you can provide the instance with an IAM role which is assigned an appropriate policy, such as that in `set-route53-role.json`

## usage
`set-route53.sh`

It is left as an exercise for the reader to configure this to run when your instance boots. This will depend on whether your distribution uses systemd, init.d, upstart, or you could  use crontab @reboot.
