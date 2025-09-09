FROM library/alpine:3.19
#FROM library/alpine:3.12
#MAINTAINER craigtracey@gmail.com

RUN apk update
RUN apk add --no-cache bash
RUN apk add ucarp
RUN mkdir -p /etc/ucarp/
COPY vip-*.sh /etc/ucarp/
COPY run-ucarp.sh /bin/

ENTRYPOINT ["/bin/bash", "/bin/run-ucarp.sh"]
