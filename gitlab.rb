# Entire settings list
# https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template
require 'ostruct'

vars =
  OpenStruct.new(
    virtual_host:          ENV['VIRTUAL_HOST'],
    registry_virtual_host: ENV['REGISTRY_VIRTUAL_HOST']
  )

external_url vars.virtual_host if vars.virtual_host
registry_external_url vars.registry_external_url if vars.registry_external_url
