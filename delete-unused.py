import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):

    response = ec2.describe_volumes(
        Filters=[
            {
                'Name': 'status',
                'Values': ['available'] 
            }
        ]
    )

    unused_volumes = [vol['VolumeId'] for vol in response['Volumes']]

    deleted_volumes = []

    for volume_id in unused_volumes:
        try:
            ec2.delete_volume(VolumeId=volume_id)
            deleted_volumes.append(volume_id)
        except Exception as e:
            print(f"Failed to delete {volume_id}: {e}")

    return {
        "statusCode": 200,
        "unused_volume_count": len(unused_volumes),
        "deleted_volumes_count": len(deleted_volumes),
        "deleted_volumes": deleted_volumes
    }
