aws ecs create-service \
    --cluster Fargate-CI-Enabled \
    --service-name streamripper \
    --cli-input-json file://ecs-streamripper-service.json