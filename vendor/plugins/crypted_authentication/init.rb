# mixin functionality to activerecord
ActiveRecord::Base.send(:include, CryptedAuthentication::Authenticator)