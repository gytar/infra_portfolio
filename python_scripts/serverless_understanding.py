# Example function to understand how serverless services works (also called FaaS, for Function as a Service), to be used in Cloud9 to understand how aws lambda works.
import json
import wikipedia

print("Loading function")

def lambda_handler(event, context):
    """
    The first argument, event, is from whatever has triggered it. The Lambda could
    be anything from an Amazon Cloud Watch event timer to running it with a
    payload crafted from the AWS Lambda Console. The second argument,
    context, has methods and properties that provide information about the
    invocation, function, and execution environment.
    -- python for devops
    Wikipedia Summarizer"""

    entity = event["entity"]
    res = wikipedia.summary(entity, sentences=1)
    print(f"Response from Wikipedia API: {res}")
    response = {
        "statusCode": "200",
        "headers": {"Content-type": "application/json"},
        "body": json.dumps({"message": res})
    }
    return response


