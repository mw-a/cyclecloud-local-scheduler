name 'local_scheduler'
maintainer 's+c'
maintainer_email 'support@cyclecomputing.com'
license 'MIT'
description 'Installs/Configures local scheduler customization'
long_description 'Installs/Configures local scheduler customization'
version '1.0.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

%w{ cvolume }.each {|c| depends c}
