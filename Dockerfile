FROM ubuntu

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends streamripper && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get -y install python python-pip \
    && pip install awscli

RUN useradd -m -d /home/streamripper streamripper
USER streamripper
WORKDIR /home/streamripper

# expose relay port
EXPOSE 8000

ADD run_with_poll.sh /run_with_poll.sh
ENTRYPOINT ["/run_with_poll.sh"]
VOLUME /home/streamripper