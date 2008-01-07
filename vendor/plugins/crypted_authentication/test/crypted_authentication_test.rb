ENV['DB'] = 'test'

require 'test/unit'
require File.dirname(__FILE__) + '/ptk_helper'
require File.dirname(__FILE__) + '/../lib/crypted_authentication'

def encrypt(string, salt='')
  Digest::SHA1.hexdigest("---#{string}---#{salt}---")
end

class TestUser < ActiveRecord::Base
end

class ObjectWithCryptedAuthPluginIncluded < Test::Unit::TestCase
  def setup
    TestUser.send(:make_authenticatable)
    @user = TestUser.new
  end
  
  def test_should_be_authenticatable
    assert @user.authenticatable?
  end
  
  def test_should_not_allow_mass_assignment_of_encrypted_password
    @user.attributes = {:encrypted_password => 'foo'}
    assert_nil @user.encrypted_password
  end
  
  def test_should_not_allow_mass_assignment_of_salt
    @user.attributes = {:salt => 'foo'}
    assert_nil @user.salt
  end
end

class NewUserWithCryptedAuthPluginIncluded < Test::Unit::TestCase
  def setup
    TestUser.send(:make_authenticatable)
    @user = TestUser.new
  end
  
  def test_should_have_a_nil_password
    assert_nil @user.password
  end
end

class UserWithNoClearTextPassword < Test::Unit::TestCase
  def setup
    TestUser.send(:make_authenticatable)
    @user = TestUser.new
    @user.password = nil
  end
  
  def test_should_not_change_salt_when_calling_save
    @user.salt = 'foo'
    @user.save
    assert_equal 'foo', @user.salt
  end
  
  def test_should_not_change_encrypted_password_when_calling_save
    @user.encrypted_password = 'password'
    @user.save
    assert_equal 'password', @user.encrypted_password
  end
end

class CryptedAuthUserWithClearTextPassword < Test::Unit::TestCase
  def setup
    TestUser.send(:make_authenticatable)
    @user = TestUser.new
    @user.password = 'password'
  end
  
  def test_should_have_a_random_salt_after_calling_save
    @user.save
    assert_not_nil @user.salt
  end
  
  def test_should_have_an_encrypted_password_after_calling_save
    @user.save
    assert_equal @user.encrypted_password, encrypt('password', @user.salt)
  end
end

class UserWithEncryptedPassword < Test::Unit::TestCase
  def setup
    TestUser.send(:make_authenticatable)
    @user = TestUser.new
    @user.password = 'password'
    @user.save
  end
  
  def test_should_be_authenticatable_with_original_cleartext_password
    assert @user.matches_password?('password')
  end
  
  def test_should_not_be_authenticatable_with_the_wrong_cleartext_password
    assert !@user.matches_password?('wrongpass')
  end
end

class UserAuthenticator < Test::Unit::TestCase
  def setup
    TestUser.send(:make_authenticatable)
    @user = TestUser.new
    @user.username = 'joebloggs'
    @user.password = 'password'
    @user.save
  end
  
  def test_should_return_a_user_for_a_matching_username_and_password
    assert_equal @user, TestUser.authenticate('joebloggs', 'password')
  end
  
  def test_should_return_nil_for_nonexistent_username
    assert_nil TestUser.authenticate('nouser', 'password')
  end
  
  def test_should_return_nil_for_incorrect_password
    assert_nil TestUser.authenticate('joebloggs', 'wrongpassword')
  end
end