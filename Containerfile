FROM sameersbn/squid

COPY squid.conf /etc/squid/
COPY passwords /etc/squid/

EXPOSE 3128
