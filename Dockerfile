FROM gitlab/gitlab-ce
COPY gitlab.rb /etc/gitlab/gitlab.rb
COPY certs/selfsigned.crt /var/certs/
COPY certs/selfsigned.key /var/certs/
