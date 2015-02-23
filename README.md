puppet-nolio_server
======================

#Purpose
Puppet module for installing a Nolio (CA Release Automation) Server

#Use
The module is made with the assumption that you will be using it with hiera. 
##Inputs
The original intent of the module was to drive quick install of execution servers, so some of the defaults are set appropriatesl. The ones that are likely to change are:

```
$package_version         
$service_name            
$package_source          
$temp_dir                
$nolio_execution_name    
$nolio_execution_port    
$nolio_product_key       
$template_version        

```

However, the remaining variiables are available to be able to drive the installation of Management and Repository functions as well.

#TODO
What's on the list of things to add to this:

* Input validation
* Tests
* Upgrades


#Credit
Thanks @split3 for the help and guidance!