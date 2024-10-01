
import logging, json, os
import boto3

logger: logging.Logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Init clients
codebuild = boto3.client('codebuild')

# Checks if an image tag exists in the repo
def check_tag_exists(tag:str, repo:str):
    ecr_client = boto3.client('ecr')
    response = ecr_client.describe_images(repositoryName=repo, filter={'tagStatus': 'TAGGED'})
    for i in response['imageDetails']:
        if tag in i['imageTags']:
            return True
    return False

def lambda_handler(event, context):   

    logger.info(f"Image pushed <{event['detail']['repository-name']}> \
         tag <{event['detail']['image-tag']}>")

    result_status: int = None
    result_msg: str = None

    op_result: str = None
    tag: str = None
    repository_name: str = None
    trigger_anyway: bool = True

    if event["detail"] is not None:
        if event["detail"]["image-tag"] is not None:
            tag = str(event["detail"]["image-tag"]).lower()
        
        if event["detail"]["repository-name"] is not None:
            repository_name = str(event["detail"]["repository-name"])

        if event["detail"]["result"] is not None:
            op_result = str(event["detail"]["result"]).upper()
    else: 
        result_status = 400
        result_msg = "Malformed event received, 'detail' key object is null"
        trigger_anyway = False

    if trigger_anyway is not False and (tag is None or tag == "latest" or repository_name is None):
        logger.info(f"Not triggering on repository <{repository_name}> tag <{tag}>")
        result_status = 200
        result_msg = f"Not triggering on repository <{repository_name}> tag <{tag}>"
        trigger_anyway = False

    
    if trigger_anyway is not False and  op_result == "FAILURE":
        logger.info(f"Check if repository <{repository_name}> tag <{tag}> already exists")
        trigger_anyway = check_tag_exists(tag, repository_name)

        if not trigger_anyway:
            result_status = 500
            result_msg = "There was an error during the image push which was not expected"
    
    if trigger_anyway:
            
        # Triggering codebuild project build    
        codebuild_project_name: str = os.environ["CODEBUILD_PROJECT_NAME"]
        logger.info(f"Using CODEBUILD project name <{codebuild_project_name}>")

        codebuild_res = codebuild.start_build(
            projectName=codebuild_project_name,
            environmentVariablesOverride=[
                {
                    'name': 'REPOSITORY_NAME',
                    'value': repository_name
                },
                {
                    'name': 'IMAGE_TAG',
                    'value': tag
                }
            ]
        )

        # str_codebuild_res = json.dumps(codebuild_res, indent=4, sort_keys=True, default=str)
        # logger.info(f"Triggered CODEBUILD build, response <{str_codebuild_res}>")

        result_status = 200
        result_msg = f"Triggering Codebuild on repository <{repository_name}> tag <{tag}>"

    return {
        'statusCode': result_status,
        'body': json.dumps(result_msg)
    }