require File.expand_path('../../../../test/test_helper', __FILE__)

#Engines::Testing.set_fixture_path
ActiveRecord::Fixtures.create_fixtures(File.dirname(__FILE__) + '/fixtures/',
                                       File.basename('issue_external_items', '.*'))
class RedmineIssueExternalItem::TestCase
  def self.prepare
    Role.find(1, 2, 3, 4).each do |r|
      r.permissions << :update_external_items
      r.save
    end

    Project.find(1, 2, 3, 4, 5).each do |project|
      EnabledModule.create(project: project, name: 'issue_external_item')
    end
  end

end
