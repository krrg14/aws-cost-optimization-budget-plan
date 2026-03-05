import boto3

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    response = ec2.describe_volumes()
    Filters = [
                {
                'Name': 'status', 
                'Values': ['available']
                }   
            ]
    
    unused_volumes = []

    for volume in response['Volumes']:
        unused_volumes.append({
            "VolumeId": volume['VolumeId'],
            "Size": volume['Size'],
            "VolumeType": volume['VolumeType'],
            "AvailabilityZone": volume['AvailabilityZone'],
            "CreateTime": volume['CreateTime'].isoformat(),
            "Tags": volume.get('Tags', [])
        })

    return {
        "statusCode": 200,
        "unused_volume_count": len(unused_volumes),
        "unused_volumes": unused_volumes
    }

