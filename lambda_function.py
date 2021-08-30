import boto3

# Creating Session With Boto3.
session = boto3.Session(
    aws_access_key_id='',
    aws_secret_access_key=''
)

# Creating S3 Resource From the Session.
def lambda_handler(event, context):
    s3 = session.resource('s3')
    mainbucket= s3.Object('my-terraform-eghan-bucket', 'Nefos-test.txt')
    txt_data = b'This is Task One from Peter - Nefos'
    result = mainbucket.put(Body=txt_data)
    res = result.get('ResponseMetadata')
    if res.get('HTTPStatusCode') == 200:
        print('File Uploaded Successfully')
    else:
        print('File Not Uploaded')
