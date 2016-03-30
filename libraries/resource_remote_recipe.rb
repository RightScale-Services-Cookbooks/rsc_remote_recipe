#
# Cookbook Name:: remote_recipe
# Library:: resource_remote_recipe
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

require 'chef/resource'

class Chef
  class Resource
    class RemoteRecipe < Chef::Resource

      def initialize(name, run_context = nil)
        super
        @resource_name = :remote_recipe
        @allowed_actions.push(:run)
        @provider = Chef::Provider::RemoteRecipe
        @action = :run
        @name=name

        
      end

      # Name of the remote recipe
      #
      # @param arg [String] the remote recipe name
      #
      # @return [String] the remote recipe name
      #
      def name(arg = nil)
        set_or_return(
          :name,
          arg,
          :kind_of => String,
          :default => ""
        )
      end

      def tags(arg = nil)
        set_or_return(
          :tags,
          arg,
          :kind_of => [ String, Array ]
        )
      end

      def attributes(arg = nil)
        set_or_return(
          :attributes,
          arg,
          :kind_of =>[ Hash, NilClass ]
        )
      end

      def match_all(arg=nil)
        set_or_return(
          :match_all,
          arg,
          :kind_of => [ TrueClass, FalseClass, NilClass ],
          :default => false,
          :required => false
        )
      end
    end
  end
end
