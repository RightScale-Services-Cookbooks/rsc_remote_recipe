# rsc_remote_recipe
A LWRP for running remote recipes within RightScale. Searches for servers with recipient_tags and runs recipes on them  Examples would be to attach to load balancers or detach from load balancers.  See example below.

### Attributes
* recipe - the name of the remote recipe to call
* recipient_tags - RightScale tags on remote server(s) to search for.
* attributes - A HASH of attributes expected on the remote recipe.

### Example

```
rsc_remote_recipe "attach to load balancer" do
  recipe "rs-haproxy::frontend"
  recipient_tags "load_balancer:active_myapp=true",
  attributes {'application_bind_ip' => node['cloud'][private_ips][0],
      'application_bind_port' => node['mycookbook']['listen_port'],
      'application_server_id' => node['rightscale']['instance_uuid'],
      'pool_name' => node['mycookbook']['application_name'],
      'vhost_path' => node['mycookbook']['vhost_path'],
      'application_action' => 'attach'}
  action :run
end
```


