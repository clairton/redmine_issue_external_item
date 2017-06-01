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

Now you should be able to see the plugin in **Administration > Plugins**.

## Usage

The Redmine Issue ExternalItem plugin enables you to add external_items to Redmine issues.

To add a external_item to an issue, enter the external_item item text into the the **ExternalItem** field in the issue description and click the **+** button.  
![external_item item](doc/issue_external_item_2.png)

You can add as many external_item items as you need. To rearrange the external_item, drag and drop the items in the desired order. To delete an item, click the trash bin icon.  
![external_item item](doc/issue_external_item_3.png)

To mark the completed external_item items, select the corresponding check boxes. The plugin will display the changes in the issue log and change the issue done ratio, if you have configured it accordingly.  
![progress](doc/issue_external_item_4.png)

To manage external_item-related permissions, go to **Administration > Roles and permissions**, click the role name and select or clear the required check boxes.  
![permissions](doc/issue_external_item_5.png)

## Testing

Run tests using the following command:

    rake redmine:plugins:test NAME=redmine_issue_external_item RAILS_ENV=test_sqlite3
    
## Maintainers

Danil Tashkinov, [github.com/nodecarter](https://github.com/nodecarter)
 
## License

Redmine ExternalItem plugin is open source and released under the terms of the GNU General Public License v2 (GPL).
