##
# This model will hold all forum and comment type chunks of text for a Page.
#
class Discussion < ActiveRecord::Base
  belongs_to :page
end
