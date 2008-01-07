# Crypted Authentication plugin
# (c) Luke Redpath <contact[AT]lukeredpath.co.uk>
#
# A simple crypted authentication plugin for Rails
require 'digest/sha1'

module CryptedAuthentication
  module Authenticator
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def make_authenticatable
        attr_accessor  :password, :password_confirmation
        attr_protected :encrypted_password, :salt
        before_save    :encrypt_password
      end
      
      def authenticate(username, password)
        user = self.find_by_title(username)
        return nil if user.nil?
        user.matches_password?(password) ? user : nil
      end
    end
    
    def authenticatable?
      true
    end
    
    def matches_password?(cleartext_password)
      self.encrypted_password == encrypt(cleartext_password, self.salt)
    end
    
    protected
      def encrypt_password
        return if self.password.blank? or self.password_confirmation.blank?
        if self.password != self.password_confirmation
          self.errors.add(:passwords, 'do not match')
          return
        end
        generate_salt
        self.encrypted_password = encrypt(self.password, self.salt)
        self.encrypted_password
      end
      
      def generate_salt
        self.salt = encrypt(Time.now, rand.to_s)
      end
      
      def encrypt(string, salt='')
        Digest::SHA1.hexdigest("---#{string}---#{salt}---")
      end
  end
end
