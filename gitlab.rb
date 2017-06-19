# Entire settings list
# https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template
external_url ENV.fetch('VIRTUAL_HOST') if ENV['VIRTUAL_HOST']
registry_external_url ENV.fetch('REGISTRY_VIRTUAL_HOST') if ENV['REGISTRY_VIRTUAL_HOST']

# For usage with letsencrypt
if ENV['ACME_CHALLENGE_PATH']
  nginx_conf = <<-CONF
    location ^~ /.well-known {
      root #{ENV.fetch('ACME_CHALLENGE_PATH')};
    }
  CONF

  nginx['custom_gitlab_server_config'] = nginx_conf
  registry_nginx['custom_gitlab_server_config'] = nginx_conf
end

if ENV['VIRTUAL_HOST'].starts_with?('https')
  nginx['ssl_certificate']     = ENV['SSL_CERTIFICATE'] || '/var/certs/selfsigned.crt'
  nginx['ssl_certificate_key'] = ENV['SSL_CERTIFICATE_KEY'] || '/var/certs/selfsigned.key'
end
