## GitLab configuration settings
##! This file is generated during initial installation and **is not** modified
##! during upgrades.
##! Check out the latest version of this file to know about the different
##! settings that can be configured by this file, which may be found at:
##! https://gitlab.com/gitlab-org/omnibus-gitlab/raw/master/files/gitlab-config-template/gitlab.rb.template
require 'ostruct'

vars =
  OpenStruct.new(
    virtual_host:          ENV['VIRTUAL_HOST'],
    registry_virtual_host: ENV['REGISTRY_VIRTUAL_HOST']
  )

external_url vars.virtual_host if vars.virtual_host
registry_external_url vars.registry_external_url if vars.registry_external_url
