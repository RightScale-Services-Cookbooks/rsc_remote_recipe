name             "rsc_remote_recipe"
maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Apache 2.0"
description      "Runs rightscale remote recipes" 
version          "10.0.0"

depends 'build-essential'

recipe "rsc_remote_recipe", "runs remote recipe" 

attribute "rightscale/refresh_token",
  :display_name => "Rightscale API refreshtoken",
  :description => "The user or service account API refresh token.",
  :type => 'string',
  :required => "required",
  :recipes => ['rsc_remote_recipe::default',  ]

attribute "rightscale/api_url",
  :display_name => "Rightscale API url",
  :description => "The user or service account API refresh token.",
  :type => 'string',
  :default=> "env:RS_SERVER",
  :required => "required",
  :recipes => ['rsc_remote_recipe::default',  ]