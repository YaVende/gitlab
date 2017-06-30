# Entire settings list
# https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template
external_url ENV.fetch('VIRTUAL_HOST') if ENV['VIRTUAL_HOST']
registry_external_url ENV.fetch('REGISTRY_VIRTUAL_HOST') if ENV['REGISTRY_VIRTUAL_HOST']

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

# Add config for proxied domains using
# VIRTUAL_HOSTS_CONFIG="domain:internal_address"
if ENV['VIRTUAL_HOSTS_CONFIG']
  ENV.fetch("PROXY_CONFIG").split(/\s*,\s*/).each do |domain_and_port|
    domain, uri = domain_and_port.split(':', 2)

    acme_challenge_config =
      ENV['ACME_CHALLENGE_PATH'] && <<-CONF
        location ^~ /.well-known {
          root #{ENV.fetch('ACME_CHALLENGE_PATH')};
        }
      CONF

    nginx['custom_gitlab_server_config'] += <<-CONF
      server {
        server_name #{domain};

        #{acme_challenge_config}

        location / {
          proxy_redirect off;
          proxy_set_header Host $http_host;
          proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_pass #{uri};
        }
      }
    CONF
  end
end

if ENV['SSL_CERTIFICATE'] && ENV['SSL_CERTIFICATE_KEY']
  nginx['ssl_certificate']              = ENV['SSL_CERTIFICATE']
  nginx['ssl_certificate_key']          = ENV['SSL_CERTIFICATE_KEY']
  registry_nginx['ssl_certificate']     = ENV['SSL_CERTIFICATE']
  registry_nginx['ssl_certificate_key'] = ENV['SSL_CERTIFICATE_KEY']
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
