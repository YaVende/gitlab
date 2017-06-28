FROM gitlab/gitlab-ce:9.3.2-ce.0
COPY gitlab.rb /etc/gitlab/gitlab.rb
COPY certs/selfsigned.crt /var/certs/
COPY certs/selfsigned.key /var/certs/
