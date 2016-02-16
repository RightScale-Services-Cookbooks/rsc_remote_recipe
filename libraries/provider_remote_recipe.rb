#
# Cookbook Name:: remote_recipe
# Library:: provider_remote_recipe
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

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'chef/provider'
require 'resource_remote_recipe'
require 'remote_recipe.rb'

class Chef
  class Provider
    class RemoteRecipe < Chef::Provider
      # Finds an existing `remote_recipe` resource on the node based on `remote_recipe` name
      # and loads the current resource with the attributes on the node.
      #
      # @return [Chef::Resource::RemoteRecipe] the resource found in the node
      #
      def load_current_resource
        @current_resource ||= Chef::Resource::RemoteRecipe.new(@new_resource.name)
        @current_resource.tags(@new_resource.tags)
        @current_resource.attributes(@new_resource.attributes)
        @recipe_helper = get_helper(@run_context.node)
        @current_resource
        
      end

      # Run a remote recipe on the server.
      #
      def action_run
        status = @recipe_helper.run(@new_resource.name,@new_resource.tags,@new_resource.attributes )
        Chef::Log.info "Recipe executed '#{new_resource.name}'"
        new_resource.updated_by_last_action(true)
      end

      private

      # Gets the remote recipe environment based on node values.
      #
      # @param node [Chef::Node] the chef node
      #
      # @return [Chef::RemoteRecipeVagrant, Chef::RemoteRecipeRightscale] the remote recipe environment
      #
      def get_helper(node)
        Chef::RemoteRecipe.factory(node)
      end

    end
  end
end
