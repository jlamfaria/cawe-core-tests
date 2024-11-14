# Lambdas

The code present in this folder is shared across 3 diferent Lambda functions.

- **Webooks lambda**: Processes webhooks from Github and forwards the request to the correct SQS queue depending on the
  OS type
- **Runners lambda (linux)**: Consumes the requests from SQS queue to assign a new linux runner to a specific Github
  organisation. It checks if there is any available runner from the hot pool or as fallback instruments AWS to spawn a
  new runner on-demand
- **macOS lambda**: Consumes the requests from SQS queue to assign a new macOS runner to a specific Github organisation.

## Source

- **handler.ts**: This is the file that processes the entrypoints for each one of the lambda flows
- **lib**: The lib folder contains all the utility modules
- **webhook**: The webhook folder contains the logic of the first lambda
  - It processes the webhook requests from Github through the API gateway
  - If the Github event type is unknown, it logs a warning message
  - Throws an error if the incoming Github event does not have a body
  - Validates if the authenticity of the request against the Github app secrets stored in AWS SSM
  - Parses the headers of the incoming webhook to extract necessary information
    such as the Github host, event type, signature, and whether it's from Github Enterprise
  - Depending on the type of Github event (workflow_run or workflow_job), it processes the event accordingly
  - For workflow_job events, if the region is 'eu-central-1' (emea) and the job label ends with '-cn', it redirects the payload to the API Gateway of the China region. 
  - Forwards it to the correct SQS queue depending if it's a linux or macOS requqest
- **runners**: The runners folder contains the logic of both runners lambdas (linux and macOS)
  - Consumes linux runners requests from correspondent SQS queue
  - **linux**: The linux folder has the logic to process linux runners requests
    - Processes the logic to retrieve one runner from the pool and assign it to the target org
    - If it fails to fetch an instance from the pool, it rocesses the logic to create a new EC2 instance on-demand and
      assign it to the target org
    - Re-queue the request to SQS pool if adhoc creation fails
  - **macos**: Processes macOS runners requests
    - Consumes macOS runners requests from correspondent SQS queue
    - Queries the list of Apple Hosts from AWS
    - Selects a random host from the available ones
    - Sends a HTTP request to the local API running on the host to reserve one of the avaiable VM slots
    - Sends back the request to SQS queue if no VM slots were available (reducing the remaining hop number)
