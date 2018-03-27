name             'prototype'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures prototype'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

{
"aws"              => "3.0.0",
"beaver"           => "1.5.0",
"td-agent"         => "3.0.2",
}.each {|key, value| depends "#{key}", "~> #{value}" }
