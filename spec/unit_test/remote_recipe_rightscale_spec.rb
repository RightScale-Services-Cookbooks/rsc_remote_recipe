#
# Cookbook Name:: remote_recipe
# Spec:: remote_recipe_rightscale_spec
#
# Copyright (C) 2013 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe Chef::RemoteRecipeRightscale do
  let(:rs_raw_output) do
    <<-EOF
      {
        "rs-instance-a3cd8e55f106f8c9edfcb84f7d786b19ee7baa46-7712524001": {
          "tags": [
            "database:active=true",
            "rs_dbrepl:slave_instance_uuid=01-83PJQDO8911IT",
            "rs_login:state=restricted",
            "rs_monitoring:state=active",
            "server:private_ip_0=10.100.0.12",
            "server:public_ip_0=157.56.165.202",
            "server:uuid=01-83PJQDO8911IT"
          ]
        },
        "rs-instance-29ad5f04e6c298d9b7837b200c80429da8a3f0b5-7712573001": {
          "tags": [
            "database:active=true",
            "rs_dbrepl:master_active=20130604215532-mylineage",
            "rs_dbrepl:master_instance_uuid=01-25MQ0VQKKDUVQ",
            "rs_login:state=restricted",
            "rs_monitoring:state=active",
            "server:private_ip_0=10.100.0.18",
            "server:public_ip_0=157.56.165.204",
            "server:uuid=01-25MQ0VQKKDUVQ",
            "terminator:discovery_time=Tue Jun 04 22:07:07 +0000 2013"
          ]
        }
      }
    EOF
  end

    
  let(:provider) do
    provider = Chef::RemoteRecipeRightscale.new('123456','https://us-3.rightscale.com')
    provider.stub(:initialize_api_client).and_return(client_stub)
    provider
  end
  
  let!(:client_stub) do
    client = double('RightApi::Client', :log => nil)
    #client.stub(:get_instance).and_return(instance_stub)
    client.stub(:resource).and_return(instance_stub)
    client.stub_chain(:right_scripts,:index)
    client.stub_chain(:tags,:by_tag)
    
    client
  end
  
  let(:runnable_bindings){bindings = double('runnable_bindings') 
    #bindings.stub(:index)#.and_return([:right_script])
    bindings.stub(:index).and_return([bindings])
    bindings.stub(:right_script).and_return(right_script_stub)
    bindings.stub(:sequence).and_return('operational')
    bindings
  }
  
  let(:server_template){template = double('server_template') 
    template.stub_chain(:show,:runnable_bindings,:index).and_return(runnable_bindings)
    
    template
  }
  
  let(:instance_stub) { 
    instance = double('instance', :links => [], :href => 'some_href')
    instance.stub_chain(:show,:state).and_return('operational')
    instance.stub_chain(:show,:server_template).and_return(server_template)
    instance.stub(:run_executable)
    instance
  }
  let(:resources_stub){
    resources = double('resources', :links => [{:href=>'somehref'},
        {:href=>'another'}], :href => 'some_href',
      :resource=>[instance_stub]) 
    resources
  }
  
  let(:right_script_stub){right_script= double('right_script',  :href=>'some_href')
    right_script.stub_chain(:show,:name).and_return("my script")
    right_script
    
  }
  
  let(:attributes){{"text:my_input"=>"input value"}}
  
  describe "#run" do
    
    it "should run a recipe" do
     
      client_stub.tags.should_receive(:by_tag).
        with(hash_including(resource_type: 'instances', tags: ['database:active=true'])).
        and_return([resources_stub])
      
      instance_stub.show.should_receive(:server_template)
      server_template.show.runnable_bindings.index.should_receive(:select).
        at_least(2).times.and_return([runnable_bindings])
      instance_stub.should_receive(:run_executable).
        with(hash_including(right_script_href: right_script_stub.href, inputs: attributes))
        
      provider.run("my script","database:active=true",attributes)
    end
    
    it "no rightscript found" do
      
      client_stub.tags.should_receive(:by_tag).
        with(hash_including(resource_type: 'instances', tags: ['database:active=true'])).
        and_return([resources_stub])
      
      server_template.show.runnable_bindings.should_receive(:index).and_return([])

      instance_stub.should_not_receive(:run_executable)
        
      expect{provider.run("my script","database:active=true",attributes)}.
        to raise_error("RightScript my script not found")
    end
    
    it "no tags found" do
          
      # no tags found
      client_stub.tags.should_receive(:by_tag).
        with(hash_including(resource_type: 'instances', tags: ['database:active=true'])).
        and_return([])
      
      server_template.show.runnable_bindings.should_not_receive(:index)
      
      instance_stub.should_not_receive(:run_executable)
        
      expect{provider.run("my script","database:active=true",attributes)}.
        to raise_error("No Instances found for tag database:active=true")
    end
    
  end
 
end
