namespace :barleysodas do
  desc "Loads permission models from the test fixture file"
  task :load_permissions => :environment do
    YAML::load_file("#{RAILS_ROOT}/test/fixtures/permissions.yml").each do |k,p|
      Permission.create(p)
    end
  end
end
