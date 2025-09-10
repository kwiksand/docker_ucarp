FROM library/alpine:3.22
LABEL maintainer="shannon.carver@gmail.com"

RUN apk add --no-cache bash ucarp

WORKDIR /app/

COPY run-ucarp.sh vip-*.sh  /app/
RUN chmod +x /app/vip-*.sh /app/run-ucarp.sh

#ENTRYPOINT ["/bin/bash", "/bin/run-ucarp.sh"]
CMD ["./run-ucarp.sh"]
