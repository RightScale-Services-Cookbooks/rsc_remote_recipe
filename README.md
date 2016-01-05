# remote_recipe
A LWRP for running remote recipes within RightScale. Examples would be to attach 
to load balancers or detach from load balancers.  

### Attributes
* tags - RightScale tags on remote server(s) to search for.
* attributes - A HASH of attributes expected on the remote recipe.

### Example

```
remote_recipe "Haproxy Frontend - chef" do
  tags "load_balancer:active_myapp=true"
  attributes( {'application_bind_ip' => node['cloud']["private_ips"][0],
      'application_bind_port' => node['mycookbook']['listen_port'],
      'application_server_id' => node['rightscale']['instance_uuid'],
      'pool_name' => node['mycookbook']['application_name'],
      'vhost_path' => node['mycookbook']['vhost_path'],
      'application_action' => 'attach'})
  action :run
end
```


### Testing
* Bundle install
* bundle exec berks install
* bundle exec strainer test