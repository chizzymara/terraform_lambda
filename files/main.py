import os

def lambda_handler(event, context):
   
   # print("Hello! this lambda function was created by chizzy on terraform")

  return {
    'body': 'Hello! this lambda function was created by {0} on terraform'.format( os.environ['my_name']),
    'headers': {
      'Content-Type': 'text/plain'
    },
    'statusCode': 200
  }
    
