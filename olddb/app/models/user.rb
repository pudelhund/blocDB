# encoding: utf-8
require "digest"

class User < ActiveRecord::Base
  attr_accessible :birthday, :email, :external_key, :firstname, :gender, :is_admin, :is_creator, :is_visible, :last_activity, :last_login, :lastname, :password, :signature, :username, :password_confirmation, :avatar, :arm_span, :height, :last_visited_location_id

  has_many :boulder_creators
  has_many :boulders, :through => :boulder_creators

  has_many :boulder_conquerors
  has_many :boulders, :through => :boulder_conquerors

  has_many :event_participants
  has_many :events, :through => :event_participants

  has_one :event, :class_name => "Event", :foreign_key => :creator_id

  mount_uploader :avatar, AvatarUploader

  attr_accessor :password_confirmation, :update_password    # getter / setter
  before_save :encrypt_password


  validates :username, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :email, :presence => true, :uniqueness => {:case_sensitive => false}, :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Ungültige Adresse" }
  validates :gender, :presence => true
  validates :password, :confirmation => true, :presence => {:on => :create}
  validates :password_confirmation, :presence => {:on => :create}
  validates :arm_span, :numericality => true, :allow_nil => true
  validates :height, :numericality => true, :allow_nil => true


  def self.authenticate(username, password)
    user = find(:first, :conditions => ['LOWER(username) = ? AND password = ?', username.downcase, Digest::MD5.hexdigest(password)])

    if user
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present? && update_password
      self.password = Digest::MD5.hexdigest(password)
      self.password_confirmation = Digest::MD5.hexdigest(password_confirmation)
    end
  end
end
