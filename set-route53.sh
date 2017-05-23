ZONE="<YOUR_DOMAIN_NAME>"

INSTANCE_ID=$(wget -qO- http://instance-data/latest/meta-data/instance-id)
REGION=$(wget -qO- http://instance-data/latest/meta-data/placement/availability-zone | sed -e 's \([0-9][0-9]*\)[a-z]*$ \1 ')
AWS_HOSTNAME=$(wget -qO- http://instance-data/latest/meta-data/public-hostname)
TAG_NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=${INSTANCE_ID}" "Name=key,Values=Name" --region ${REGION} --output=text | cut -f5)
TAG_ZONE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=${INSTANCE_ID}" "Name=key,Values=Zone" --region ${REGION} --output=text | cut -f5)
ZONE=${TAG_ZONE:-${ZONE}}
ZONE_ID=$(aws route53 list-hosted-zones --output=text --query 'HostedZones[?Name==`'${ZONE}'`].Id' | cut -f3 -d\/)
TEMPFILE=$(mktemp)
cat > ${TEMPFILE} <<-!
{
  "Comment": "Route53 entry from set-route53.sh",
  "Changes": [ {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${TAG_NAME}.${ZONE}",
        "Type": "CNAME",
        "TTL": 60,
        "ResourceRecords": [ { "Value": "${AWS_HOSTNAME}" } ]
      }
    } ]
}
!
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file://${TEMPFILE}
hostname "${TAG_NAME}.${ZONE%.}"
rm ${TEMPFILE}
