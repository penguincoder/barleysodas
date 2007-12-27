class HelpStartPage < ActiveRecord::Migration
  def self.up
redcloths = "
h1. Thanks for using BarleySodas

Please check out these topics for more specialized information.

* [[Peoples]]
* [[Beers]]
* [[Breweries]]
* [[Discussions]]
* [[Pages]]
* [[Sessions]]
"
    Page.create :title => 'HomePage', :owner_type => 'Help', :redcloth => redcloths
  end

  def self.down
    Page.destroy_all("owner_type = 'Help'")
  end
end
