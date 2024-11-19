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

# Deleting The Volumes which are less than 5GB and not in use only
#!/bin/bash
delete_vols() {
    # Fetch all volumes
    vols=$(aws ec2 describe-volumes | jq ".Volumes[].VolumeId" -r)
    for vol in $vols; do
        # Fetch volume details
        volume_info=$(aws ec2 describe-volumes --volume-ids $vol)
        size=$(echo "$volume_info" | jq ".Volumes[].Size")
        state=$(echo "$volume_info" | jq ".Volumes[].State" -r)
        # Check volume size and state
        if [ "$state" == "in-use" ]; then
            echo "$vol is attached to an instance. Skipping deletion."
        elif [ "$size" -gt 5 ]; then
            echo "$vol is larger than 5GB. Skipping deletion."
        else
            echo "Deleting Volume $vol"
            aws ec2 delete-volume --volume-id $vol
        fi
    done
}
# Call the function
delete_vols