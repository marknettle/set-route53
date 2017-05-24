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
* appropriate credentials to update Route 53. Either
  * in `~/.aws/credentials`, which you can do with `aws configure`
  * or use an IAM instance role which has the policy elements from [`set-route53-policy.json`](set-route53-policy.json)

## usage
`set-route53.sh`

It is left as an exercise for the reader to configure this to run when your instance boots. This will depend on whether your distribution uses systemd, init.d, upstart, or you could  use crontab @reboot.

Note that if you are using an IAM instance role, it takes some time for the credentials to get to the machine after bootup. My crontab file contains
```
@reboot	( sleep 15; /usr/local/bin/set-route53.sh ) &
```
