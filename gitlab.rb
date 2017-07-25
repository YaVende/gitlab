# Entire settings list
# https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template

external_url ENV.fetch('EXTERNAL_URL') if ENV['EXTERNAL_URL']
registry_external_url ENV.fetch('REGISTRY_EXTERNAL_URL') if ENV['REGISTRY_EXTERNAL_URL']

# Expose the registry, default is localhost:5000
registry['registry_http_addr'] = "0.0.0.0:5000"

if ENV['ENABLE_NGINX'] =~ /true|1|yes/
  nginx['enable'] = true

  nginx['custom_gitlab_server_config'] ||= ''
  registry_nginx['custom_gitlab_server_config'] ||= ''

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

  if ENV['SSL_CERTIFICATE'] && ENV['SSL_CERTIFICATE_KEY']
    nginx['ssl_certificate']              = ENV['SSL_CERTIFICATE']
    nginx['ssl_certificate_key']          = ENV['SSL_CERTIFICATE_KEY']
    registry_nginx['ssl_certificate']     = ENV['SSL_CERTIFICATE']
    registry_nginx['ssl_certificate_key'] = ENV['SSL_CERTIFICATE_KEY']
  end
else
  # Disable all internal components
  nginx['enable']      = false
  prometheus['enable'] = false
end

if ENV['WEB_SERVER_CONFIG']
  require 'json'
  config = JSON.parse(ENV.fetch('WEB_SERVER_CONFIG'))
  config.each { |k,v| web_server[k] = v }
end

# For migration purposes, integrate GitHub OAuth
if ENV["GITHUB_ID"] && ENV["GITHUB_SECRET"]
  gitlab_rails['omniauth_providers'] = [
    {
      name:       "github",
      app_id:     ENV.fetch("GITHUB_ID"),
      app_secret: ENV.fetch("GITHUB_SECRET"),
      url:        "https://github.com/",
      args:       { scope: "user:email" }
    }
  ]
end
