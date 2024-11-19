# Deleting The Volumes which are less than 5GB

#!/bin/bash
delete_vols() {
  vols=$(aws ec2 describe-volumes | jq ".Volumes[].VolumeId" -r)
  for vol in $vols; do
    size=$(aws ec2 describe-volumes --volume-ids $vol | jq ".Volumes[].Size")
    if [ $size -gt 5 ]; then
      echo "$vol is a prod Volume. Don't Delete"
    else
      echo "Deleting Volume $vol"
      aws ec2 delete-volume --volume-id $vol
    fi
  done
}

#call the function
delete_vols