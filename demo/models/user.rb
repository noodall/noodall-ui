class User
  include MongoMapper::Document
  include Canable::Cans

  key :email, String
  key :full_name, String
  key :groups, Array

  def admin?
    groups.include?('website administrator')
  end
end
