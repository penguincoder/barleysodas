class Invitation < ActiveRecord::Base
  belongs_to :people
  validates_presence_of :people_id
  before_create :set_invitation_code
  
  protected
  
  def set_invitation_code
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    check = nil
    begin
      check = ''
      1.upto(32) { |k| check << chars[rand(chars.size - 1)] }
    end while Invitation.find_by_code(check)
    self.code = check
  end
end
