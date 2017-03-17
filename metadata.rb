# frozen_string_literal: true
name             'rsc_remote_recipe'
maintainer       'RightScale, Inc.'
maintainer_email 'support@rightscale.com'
license          'Apache 2.0'
description      'Runs rightscale remote recipes'
version          '10.1.2'
issues_url 'https://github.com/RightScale-Services-Cookbooks/rsc_remote_recipe/issues' if respond_to?(:issues_url)
source_url 'https://github.com/RightScale-Services-Cookbooks/rsc_remote_recipe' if respond_to?(:source_url)
chef_version '>= 12.0' if respond_to?(:chef_version)

depends 'build-essential'

recipe 'rsc_remote_recipe', 'runs remote recipe'

attribute 'rightscale/refresh_token',
  display_name: 'Rightscale API refreshtoken',
  description: 'The user or service account API refresh token.',
  type: 'string',
  required: 'required',
  recipes: ['rsc_remote_recipe::default']

attribute 'rightscale/api_url',
  display_name: 'Rightscale API url',
  description: 'The user or service account API refresh token.',
  type: 'string',
  default: 'env:RS_SERVER',
  required: 'required',
  recipes: ['rsc_remote_recipe::default']

attribute 'rightscale/account_id',
  display_name: 'Rightscale Account ID',
  description: 'RightScale Account ID',
  type: 'string',
  required: 'required',
  recipes: ['rsc_remote_recipe::default']
