# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

action :run do
  remote_recipe =  new_resource.recipe || new_resource.name
  tags = new_resource.recipient_tags
  attributues = new_resource.attributes || {}
  remote_request_json ="/tmp/rsc_remote_recipe-#{Time.now.to_i}.json"
    
  
  file remote_request_json do
    mode 0660
    content ::JSON.pretty_generate({
        'remote_recipe' => attributues
      })
  end

  # Send remote recipe request
  log "Running recipe '#{remote_recipe}' on all servers" +
    " with tags '#{tags}'..."
  
  #install fake rs_run_recipe for vagrant testing
  if node[:cloud][:provider] == 'vagrant'
    cookbook_file  "/usr/bin/rs_run_recipe" do
      source "rs_run_recipe"
      cookbook 'rsc_remote_recipe'
      mode 0755
    end
  end

  execute "rs_run_remote #{remote_recipe} with #{tags}" do
    command [
      'rs_run_recipe',
      '--name', remote_recipe,
      '--recipient_tags', tags,
      '--json', remote_request_json
    ]
  end

  file remote_request_json do
    action :delete
  end
end
