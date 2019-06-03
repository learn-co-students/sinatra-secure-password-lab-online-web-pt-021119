class User < ActiveRecord::Base
  validates_presence_of :username
  validates_presence_of :password
  has_secure_password
end
