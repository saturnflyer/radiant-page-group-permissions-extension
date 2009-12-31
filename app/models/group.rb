class Group < ActiveRecord::Base  
  #named_scope :default, :order => "name"
  default_scope :order => "name ASC"
  
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by'
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  has_and_belongs_to_many :users
  has_many :pages
  
  validates_presence_of :name, :message => 'required'
  validates_length_of :name, :maximum => 100, :message => "%d-character limit"
end
