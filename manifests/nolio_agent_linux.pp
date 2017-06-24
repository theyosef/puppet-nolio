# Class: nolio_execution
#
# Install Nolio (CA Release Automation) Execution Agent
#

define nolio::nolio_agent_linux (
$agent_id                  = "${::fqdn}",
$agent_port                = 6900,
$install_dir               = '/opt/CA/NolioAgent',
$execution_server_host,
$execution_server_port     = 6600,
$execution_server_secure   = false,
$agent_mapping_application = '',
$agent_mapping_environment = '',
$agent_mapping_servertype  = '',
$package_version           = '5.0.2.b78',
$service_name              = 'nolioagent',
$package_source            = "",
$temp_dir                  = "/tmp",
$template_version          = "5x",
) {


  
  $src_dir = "${temp_dir}/puppet_nolio"
  $real_package_version = regsubst($package_version, '(\.)', '_', 'G')
  $real_package_name = "nolio_agent_linux_${real_package_version}.sh"
  

  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  } 

  if ! defined(File["${src_dir}"]) {
    file { "${src_dir}":
      ensure=>directory,
    }
  }   


  exec { "${real_package_name}_download":
    command => "/usr/bin/wget -N '${package_source}' -O ${real_package_name}",
    cwd     => "${src_dir}",
    creates => "${src_dir}/${real_package_name}",
    unless  => "test -x /etc/init.d/${service_name}",
    require => File["${src_dir}"],
    timeout => 0,
  }->

  file{"${src_dir}/${real_package_name}":
    mode => 'a+x',
  }->

  file{"${src_dir}/agent.silent.varfile":
    content => template("nolio/agent.silent.varfile-v${template_version}.erb"),
    replace  => "yes",
  }->

  exec { "${real_package_name}-install":
    command => "${src_dir}/${real_package_name} -q -varfile ${src_dir}/agent.silent.varfile",
    cwd     => "${src_dir}",
    creates => "${install_dir}",
    unless  => "test -x /etc/init.d/${service_name}",
  }

# a test/exec to force a quick re-install of the agent if we have a change in configs:
  exec { "/sbin/service nolioagent stop && ${src_dir}/${real_package_name} -q -varfile ${src_dir}/agent.silent.varfile ; /sbin/service nolioagent restart":
    subscribe   => File["${src_dir}/agent.silent.varfile"],
    refreshonly => true,
  }

}
