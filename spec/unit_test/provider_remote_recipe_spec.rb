#
# Cookbook Name:: remote_recipe
# Spec:: provider_remote_recipe_spec
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

require "spec_helper"

describe Chef::Provider::RemoteRecipe do
  let(:provider) do
    provider = Chef::Provider::RemoteRecipe.new(new_resource, run_context)
    provider.stub(:get_helper).and_return(helper_stub)
    provider
  end

  let(:new_resource) { Chef::Resource::RemoteRecipe.new(name) }
  let(:events) { Chef::EventDispatch::Dispatcher.new }
  let(:run_context) { Chef::RunContext.new(node, {}, events) }
  let(:node) do
    node = Chef::Node.new
    node
  end
  let(:name) {'myrecipe'}
  let(:tags) {'namespace:predicate=value' }
  let(:attributes){ 
    hash={}; 
    hash[:foo]='bar' 
    hash
    }
  
  let(:helper_stub) { double('remote_recipe') }

  describe 'actions' do
    before(:each) do
      provider.load_current_resource
    end

    it "should run_execuatble" do
      new_resource.tags tags
      new_resource.attributes attributes
      helper_stub.should_receive(:run).with(name,tags,attributes,false)
      provider.run_action(:run)
    end
  end
end
