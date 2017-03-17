# frozen_string_literal: true
require_relative 'spec_helper'

describe 'rsc_remote_recipe::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['rightscale']['refresh_token'] = '123abc'
      node.set['rightscale']['api_url'] = 'https://us-3.rightscale.com'
    end.converge(described_recipe)
  end
  let(:node) { chef_run.node }

  it 'includes install recipe' do
    expect(chef_run).to include_recipe('build-essential')
  end

  it 'installs a chef_gem with the default action' do
    expect(chef_run).to install_chef_gem('right_api_client')
  end
end
