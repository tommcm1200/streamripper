docker run streamripper -u http://eno.emit.com:8000/pbsfm_live_64.aacp -d /home/streamripper/ -s pbs -l 5 

https://github.com/clue/docker-streamripper
https://www.lifewire.com/pass-arguments-to-bash-script-2200571

docker build . --tag streamripper

docker run streamripper \
-e AWS_REGION="ap-southeast-2" \
-e QUEUE_URL="https://sqs.ap-southeast-2.amazonaws.com/447119549480/StreamripperQueue" \
-e RUN_CMD="streamripper $URL -l $DURATION -a $output_filename -o always" \
-e VERBOSE="0" \
-e TIMEOUT="10" \
-e COUNT="" \
-e LOOP="" 

docker run --env-file ./env.list streamripper 