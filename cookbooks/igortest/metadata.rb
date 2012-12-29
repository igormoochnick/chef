maintainer       "Percipio Media"
maintainer_email "igor@percipiomedia.com"
license          "All rights reserved"
description      "Installs/Configures igortest"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"


depends "app"
#depends "web_apache"
#depends "db_mysql"
#depends "repo"
depends "rightscale"

recipe "igortest::default", "Prints hello world output"
recipe "about_city::my_city","Information about my city"
recipe "igortest::kettle", "Installs and configures Kettle server"

