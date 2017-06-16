# Entire settings list
# https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template
require 'ostruct'

external_url ENV['VIRTUAL_HOST'] if ENV['VIRTUAL_HOST']
registry_external_url ENV['REGISTRY_VIRTUAL_HOST'] if ENV['REGISTRY_VIRTUAL_HOST']
