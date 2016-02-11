#
# Cookbook Name:: remote_recipe
# Library:: remote_recipe_rightscale
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

require_relative 'remote_recipe_base'

class Chef
  class RemoteRecipeRightscale < RemoteRecipeBase
    
    def initialize(refresh_token,api_url)
      @refresh_token = refresh_token
      @api_url = api_url
    end
    
    def initialize_api_client
      require "right_api_client"
      RightApi::Client.new(:refresh_token => @refresh_token, :api_url=>@api_url)
    end
    
    def api_client
      @api_client = initialize_api_client
    end
    
    # Creates a tag on the server.
    # @param name [String] name of the recipe to run
    # @param tags [Array<String>] the recipient tags 
    # @param attributes [Hash] the attribute for the recipe
    #
    def run(name, tags, attributes)        
      resources = api_client.tags.by_tag(resource_type: 'instances', tags: [tags] )
      raise "No Instances found for tag #{tags}" if resources.empty?

      resources.first.links.each do |link|
        resource = api_client.resource(link["href"])
        # find the server_template of the instance
        st = resource.show.server_template 
        # find the exact runnable bindings by name and which are operational on the instance
        runnable_bindings = st.show.runnable_bindings.index.select{|r| 
          r.right_script.show.name==name && r.sequence=='operational' 
        }
        raise "RightScript #{name} not found" if runnable_bindings.empty?
        right_script = runnable_bindings.first.right_script
        if resource.show.state=='operational'
          # run the found rightscript on the instance and pass the attributes as inputs.
          status =  resource.run_executable(right_script_href: right_script.first.href, inputs: attributes)
        end
      end
      
    end
  end
end
