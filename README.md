# Redmine Issue External Item Plugin

[![Build Status](https://travis-ci.org/clairton/redmine_issue_external_item.svg?branch=master)](https://travis-ci.org/Restream/redmine_issue_external_item)
[![Code Climate](https://codeclimate.com/github/clairton/redmine_issue_external_item/badges/gpa.svg)](https://codeclimate.com/github/Restream/redmine_issue_external_item)

This plugin enables you to add external items to Redmine issues. 

The initial author of the plugin is [Kirill Bezrukov](http://www.redminecrm.com/projects/external_item/pages/1)

## Compatibility

This plugin version is compatible only with Redmine 3.0 and later.

## Installation

1. To install the plugin
    * Download the .ZIP archive, extract files and copy the plugin directory into #{REDMINE_ROOT}/plugins.
    
    Or

    * Change you current directory to your Redmine root directory:  

            cd {REDMINE_ROOT}
            
      Copy the plugin from GitHub using the following commands:
      
            git clone https://github.com/Restream/redmine_issue_external_item.git plugins/redmine_issue_external_item
            
2. Update the Gemfile.lock file by running the following commands:  

        bundle install
            
3. This plugin requires a migration. Run the following command to upgrade your database (make a database backup before):  

        bundle exec rake redmine:plugins:migrate RAILS_ENV=production 
        
4. Restart Redmine.

Now you should be able to see the plugin in **Administration > Custom Field > Issues**.

## Usage

Create a connection called "external_item_production" to retrieve items, PS: the query is static yet

Put configuration in your enviroment file like config/environment/production.rb as

```ruby
Rails.application.configure do
  ...
  config.issue_external_item = ActiveSupport::OrderedOptions.new
  config.issue_external_item.export_dir = '/tmp/'
  ...
end

```
 
## License

Redmine ExternalItem plugin is open source and released under the terms of the GNU General Public License v2 (GPL).
