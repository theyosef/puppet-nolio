# Class: nolio_execution
#
# Install Nolio (CA Release Automation) Execution Agent
#

class nolio::nolio_agent_windows (
 $agent_id                  = "${::fqdn}",
$agent_port                = 6900,
$install_dir               = '',
$execution_server_host,
$execution_server_port     = 6600,
$execution_server_secure   = false,
$agent_mapping_application = '',
$agent_mapping_environment = '',
$agent_mapping_servertype  = '',
$package_version           = '5.0.2.b78',
$service_name              = 'nolioagent',
$package_source            = "",
$template_version          = "5x",
$temp_dir                  = "c:\\media",
$package_name              = "Release Automation Agent",
) {

include staging
  
  $src_dir = "${temp_dir}\\puppet_nolio"
  $real_package_version = regsubst($package_version, '(\.)', '_', 'G')
  $real_package_name = "nolio_agent_windows_${real_package_version}.exe"
  
  Exec {
    path => "${::path}",
  }

  if ! defined(File["${temp_dir}"]) {
    file { "${temp_dir}":
      ensure=>directory,
    }
  }  
  if ! defined(File["${src_dir}"]) {
    file { "${src_dir}":
      ensure=>directory,
      require=>File["${temp_dir}"],
    }
  }   

  staging::file { "${real_package_name}.msi":
    source  => "${package_source}",
  }->
  file { "${src_dir}\\${real_package_name}":
    ensure => 'file',
    source => "${staging::path}/nolio_agent_windows/${real_package_name}",
    replace => false,
    require => File[$src_dir],
  }->

  file{"${src_dir}/agent.silent.varfile":
    content => template("nolio/agent.silent.varfile-v${template_version}.erb"),
    replace  => "yes",
  }

  package { $package_name:
    ensure  => $package_ensure,
    source  => "${src_dir}\\${real_package_name}",
    install_options => ['-q -varfile ${src_dir}/agent.silent.varfile'],
    require => File["${src_dir}/agent.silent.varfile"],
  }

  service { $service_name:
    ensure  => running,
    require => Package[$package_name],
  }

}
