ActiveRecord::Schema.define(:version => 2) do
  
  create_table "test_users", :force => true do |t|
    t.column "username",         :string
    t.column "encrypted_password", :string
    t.column "salt",             :string
  end
  
end