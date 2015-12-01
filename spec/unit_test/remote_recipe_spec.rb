#
# Cookbook Name:: remote_recipe
# Spec:: remote_recipe_spec
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

describe Chef::RemoteRecipe do
  let(:node) { Chef::Node.new }

  describe "::factory" do
    let(:shell_out) { Struct.new(:exitstatus) }
    let(:stdout) { Struct.new(:stdout) }

    context "cloud provider is vagrant" do
      it "should return an object of RemoteRecipeVagrant class" do
        node.set['cloud']['provider'] = 'vagrant'
        expect(Chef::Log).to receive(:info).with("RemoteReceipt is not supported in Vagrant")
        Chef::RemoteRecipe.factory(node)
      end
    end


    
    context "Rightscale is the provider" do
      it "should return an object of RemoteRecipeRightscale class" do
        node.set['cloud']['provider'] = 'ec2'
        node.set['rightscale']['refreshtoken'] = 'abc123456'
        Chef::RemoteRecipe.factory(node).should be_an_instance_of(Chef::RemoteRecipeRightscale)
      end
    end
  end
end
