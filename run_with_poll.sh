#!/usr/bin/env bash

AWS_REGION="ap-southeast-2"
QUEUE_URL="https://sqs.ap-southeast-2.amazonaws.com/447119549480/StreamripperQueue"
RUN_CMD="streamripper $URL -l $DURATION -a $output_filename -o always"
VERBOSE="0"
TIMEOUT="10"
COUNT=""
LOOP=""

output_dir="/home/streamripper/"
bucket="tommcm-streamripper"

function log () {
    [[ $VERBOSE == 1 ]] && logerr $@
    return 0
}
function logerr () {
    (>&2 echo $@)
    return 0
}

log "Queue: $QUEUE_URL"
log "Timeout = $TIMEOUT"
while (true); do
    logerr -n .
    MESSAGES=$(aws --region "$AWS_REGION" sqs receive-message --queue-url "$QUEUE_URL" --wait-time-seconds "$TIMEOUT" --max-number-of-messages 1)
    if [[ "$MESSAGES" != "" ]]; then
        MESSAGE=$(echo $MESSAGES | jq '.Messages[]' -r)
        RECEIPT=$(echo $MESSAGE | jq '.ReceiptHandle' -r)
        BODY=$(echo $MESSAGE | jq '.Body' -r)
        URL=$(echo "$BODY" | jq -r '.url') 
        SHOWNAME=$(echo "$BODY" | jq -r '.showname')
        RADIOSTATION=$(echo "$BODY" | jq -r '.radiostation')
        DURATION=$(echo "$BODY" | jq -r '.duration')        
        
        date=`date +"%Y-%m-%d_%a_%H%M%P"`
        output_filename=$SHOWNAME.${date}
        
        log
        echo "Receipt: $RECEIPT"
        echo "Got Message:"
        echo "$BODY"

        #Streamripper
        streamripper $URL -d $output_dir -l $DURATION -a $output_filename -o always
        #Copy Episode to S3
        # aws s3 cp $output_dir$output_filename.aac s3://$bucket/$RADIOSTATION/$output_filename.aac
        #Delete message
        aws --region "$AWS_REGION" sqs delete-message --queue-url "$QUEUE_URL" --receipt-handle "$RECEIPT"

    fi
    if [[ $LOOP != "" ]]; then
        let LOOP--
        log "Loop: $LOOP"
        [[ $LOOP < 1 ]] && exit
    fi
done
