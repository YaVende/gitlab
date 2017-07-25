FROM gitlab/gitlab-ce:9.3.2-ce.0
RUN apt-get update -qq

COPY entrypoint.sh /entrypoint.sh
COPY gitlab.rb /tmp/gitlab.rb
COPY certs/selfsigned.crt /var/certs/
COPY certs/selfsigned.key /var/certs/

ENTRYPOINT ["/bin/bash"]
CMD ["entrypoint.sh"]
