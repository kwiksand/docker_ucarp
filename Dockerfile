FROM library/alpine:3.22

LABEL maintainer="shannon.carver@gmail.com"

WORKDIR /app

RUN apk add --no-cache bash ucarp

COPY vip-*.sh run-ucarp.sh /app/
RUN chmod +x vip-*.sh run-ucarp.sh

#ENTRYPOINT ["/bin/bash", "/bin/run-ucarp.sh"]
CMD ["./run-ucarp.sh"]
