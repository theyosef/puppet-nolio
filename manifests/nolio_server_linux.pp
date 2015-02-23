# Class: nolio_execution
#
# Install Nolio (CA Release Automation) Execution Server
#

class nolio::nolio_server_linux (

$package_version           = '5.0.2.b78',
$service_name              = 'NolioASAP',
$package_source            = "",
$temp_dir                  = "/tmp",
$nolio_execution_name      = "${::fqdn}",#<EXECUTION SERVER NAME OR IP> 
$nolio_execution_port      = 6600,
$nolio_product_key         = "",
$template_version          = "5x",

$nolio_db_type                          = "0", # 0=Oracle, 1=MS_SQL?
$sys_installationDir                    = "/opt/CA/NolioServer", #Nolio 4ever
$nolio_install_dm                       = false,
$nolio_install_es                       = true,
$nolio_install_agent                       = false,
$nolio_db_mssql_dba_user                = "",
$nolio_db_mssql_dba_password            = "",
$nolio_db_mssql_dba_winauth             = "",
$nolio_nimi_node_id                     = "es_${::fqdn}",
$nolio_nimi_port                        = 6900,
$sys_component_12751                    = true,
$nolio_repository_host                  = "", #default: localhost
$nolio_hiddenport                       = false,
$nolio_nimi_secured                     = false,
$nolio_service_pw                       = "",
$sys_programGroupDisabled               = true,
$nolio_service_user                     = "",
$tomcat_port_shutdown                   = 8005,
$nolio_db_mssql_winauth                 = false,
$nolio_nimi_supernode                   = "default",
$sys_component_336                      = true,
$nolio_db_port                          = "", #1433
$tomcat_port_ajp                        = 8009,
$tomcat_port_ssl                        = 8443,
$nolio_db_user_name                     = "",#<RA DATABASE USERNAME>
$nolio_install_type                     = 1, # 0==Full Install; 1==Custom Install?
$sys_component_12750                    = false,
$nolio_repository_remote                = false,
$nolio_branding_name                    = CA,
$nolio_db_password                      = "",#<RA DATABASE PASSWORD>
$nolio_db_database_name                 = "",#<DATABASE SID OR NAME>
$nolio_db_create                        = false,
$nolio_agents_supernode                 = 127_0_0_1,
$sys_adminRights                        = true,
$sys_languageId                         = en,
$nolio_repository_port                  = "",#8080
$nolio_installation_mode                = 0,
$tomcat_port_http                       = 8080,
$nolio_db_host_name                     = "",#<DATABASE HOSTNAME OR IP>
$nolio_repository_scheme_int            = 0,#0

) {
  
  $src_dir = "${temp_dir}/puppet_nolio"
  $real_package_version = regsubst($package_version, '(\.)', '_', 'G')
  $real_package_name = "nolio_server_linux-x64_${real_package_version}.sh"
  

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

  file{"${src_dir}/server.silent.varfile":
    content => template("nolio/server.silent.varfile-v${template_version}.erb"),
    replace  => "no",
  }->

  exec { "${real_package_name}-install":
    command => "${src_dir}/${real_package_name} -q -varfile ${src_dir}/server.silent.varfile",
    cwd     => "${src_dir}",
    creates => "${sys_installationDir}",
    unless  => "test -x /etc/init.d/${service_name}",
  }



}
