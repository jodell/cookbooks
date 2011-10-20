Cookbooks
=========

Recipes
=======
* apache2 - Opscode
* basic - Some basic package, timezone, and default editor
* build-essential - Package building, Opscode
* dots: wrapper for setting up personal dotfile repos
* lenny_bootstrap: basic debian lenny setup
* memcached: memcached installer, Opscode
* mongodb: Opscode, patched
* openvpn: openvpn client only, will connect if there's a .vpnpass file
* p4: perforce binary setup
* passenger_enterprise: Opscode, patched
* postgresql: Opscode, additional changes
* ruby_enterprise: REE recipe, patched
* selenium-rc: selenium node bootstrapper
* webserver: generic rails-git-apache2 wrapper
* xen: bootstraps a lenny dom0
* xvfb: xvfb installer for headless X

Rake
====
If you're bootstrapping with nephele, these rake tasks aren't needed directly.  If you want to run a role or recipe on an existing box, you would need to clone, bundle, and then execute the run task:

<pre>
$ rake -vT
rake bootstrap            # Ghetto chef bootstrapping, see bin/bootstrap.sh
rake generate[name]       # Generate a new templated recipe
rake pkg                  # Package these cookbooks
rake run[role_or_recipe]  # Run a role or recipe from this repo
rake update               # self-update this repo
</pre>

Chef Verbosity
==============
This repo lets you tweak logger settings during chef-solo runs via the following env vars.  Setting the log level to 'debug' helps during chef recipe development.

In solo.rb:

<pre>
log_level ENV['CHEF_LOG_LEVEL'] && ENV['CHEF_LOG_LEVEL'].to_sym || :info
log_location ENV['CHEF_LOG_LOCATION'] || STDOUT
verbose_logging ENV['CHEF_VERBOSE_LOGGING']
</pre>
