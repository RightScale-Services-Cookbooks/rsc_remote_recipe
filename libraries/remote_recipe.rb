#
# Cookbook Name:: remote_recipe
# Library:: remote_recipe_helper
#
# Copyright (C) 2015 RightScale, Inc.
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

require_relative 'remote_recipe_rightscale'

class Chef
  module RemoteRecipe

    # Factory method for instantiating the correct remote recipe class based on
    # `node['cloud']['provider']` value. This value will be set to `'vagrant'` on
    # Vagrant environments.
    #
    # @param node [Chef::Node] the chef node
    #
    # @return [Chef::RemoteRecipeBase] the instance corresponding to
    #   the remote recipe environment
    #
    def self.factory(node)
      
      if node['cloud'] && node['cloud']['provider'] != 'vagrant'
        # This is a RightScale environment
        Chef::RemoteRecipeRightscale.new(node["rightscale"]["refresh_token"])
      elsif node['cloud'] && node['cloud']['provider'] == 'vagrant'
        # This is a Vagrant environment
        #hostname, cache_dir = vagrant_params_from_node(node)
        Chef::Log.info("RemoteReceipt is not supported in Vagrant")
        #Chef::RemoteRecipeVagrant.new(hostname, cache_dir)
      else
        raise "Could not detect a supported remote receipe environment."
      end
    end
    

  end

end
