class nolio::nolio_agent(
  $agent_id                  = "${::fqdn}",
  $agent_port                = 6900,
  $install_dir               = '/opt/CA/NolioAgent',
  $execution_server_host,
  $execution_server_port     = 6600,
  $execution_server_secure   = false,
  $agent_mapping_application = '',
  $agent_mapping_environment = '',
  $agent_mapping_servertype  = '',
  $package_name              = '',
  $package_version           = '5.0.2.b78',
  $service_name              = 'nolioagent',
  $package_source            = 'http://splat.changethis.yoyoyo',
  $temp_dir                  = "/tmp",
  $template_version          = "5x",
) {

  case "${::operatingsystem}" {
    'CentOS': {
      nolio::nolio_agent_linux {'Install_CentOS_Agent':
      agent_id                  => "${nolio::nolio_agent::agent_id}",
      agent_port                => "${nolio::nolio_agent::agent_port}",
      install_dir               => "${nolio::nolio_agent::install_dir}",
      execution_server_host     => "${nolio::nolio_agent::execution_server_host}",
      execution_server_port     => "${nolio::nolio_agent::execution_server_port}",
      execution_server_secure   => "${nolio::nolio_agent::execution_server_secure}",
      agent_mapping_application => "${nolio::nolio_agent::agent_mapping_application}",
      agent_mapping_environment => "${nolio::nolio_agent::agent_mapping_environment}",
      agent_mapping_servertype  => "${nolio::nolio_agent::agent_mapping_servertype}",
      package_version           => "${nolio::nolio_agent::package_version}",
      service_name              => "${nolio::nolio_agent::service_name}",
      package_source            => "${nolio::nolio_agent::package_source}",
      temp_dir                  => "${nolio::nolio_agent::temp_dir}",
      template_version          => "${nolio::nolio_agent::template_version}",
    }#end CentOS
    'Windows':{
      nolio::nolio_agent_windows {'Install_Windows_agent':
      agent_id                  => "${nolio::nolio_agent::agent_id}",
      agent_port                => "${nolio::nolio_agent::agent_port}",
      execution_server_host     => "${nolio::nolio_agent::execution_server_host}",
      execution_server_port     => "${nolio::nolio_agent::execution_server_port}",
      execution_server_secure   => "${nolio::nolio_agent::execution_server_secure}",
      agent_mapping_application => "${nolio::nolio_agent::agent_mapping_application}",
      agent_mapping_environment => "${nolio::nolio_agent::agent_mapping_environment}",
      agent_mapping_servertype  => "${nolio::nolio_agent::agent_mapping_servertype}",
      template_version          => "${nolio::nolio_agent::template_version}",

      package_name              => "${nolio::nolio_agent::package_name}",
      package_version           => "${nolio::nolio_agent::package_version}",
      service_name              => "${nolio::nolio_agent::service_name}",

      temp_dir                  => "${nolio::nolio_agent::temp_dir}",
      install_dir               => "${nolio::nolio_agent::install_dir}",
      package_source            => "${nolio::nolio_agent::package_source}",
    }#end Windows
  }#end case operatingsystem

}#end module