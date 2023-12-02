FROM alpine:3.8

ENV GMVAULT_DIR /data
ENV GMVAULT_EMAIL_ADDR test@example.com
 
RUN apk add --update \
	bash \
        ca-certificates \
        tzdata \
        python \
        py-pip \
        shadow \
    && pip install --upgrade pip \
    && rm -rf /var/cache/apk/* \
    && addgroup abc \
    && adduser -s /bin/bash -G abc -H -D abc

COPY gmvault-source /gmvault-source
WORKDIR /gmvault-source
RUN python setup.py install
    
VOLUME /data
RUN mkdir /app
COPY gmvault.sh /app/gmvault.sh
COPY daily-backup /etc/periodic/daily/
COPY weekly-backup /etc/periodic/weekly/
COPY heartbeat /etc/periodic/hourly/

WORKDIR /app

CMD ["/app/gmvault.sh"]
