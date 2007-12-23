namespace :barleysodas do
  desc "Saves permission models to the test fixture file"
  task :extract_permissions => :environment do
    i = "000"
    File.open("#{RAILS_ROOT}/test/fixtures/permissions.yml", 'w') do |file|
      p = Permission.find(:all)
      file.write p.inject({}) { |hash, record|
        hash["permissions_#{i.succ!}"] = record.attributes.reject { |key, val| key == "id" }
        hash
      }.to_yaml
    end
  end
end
