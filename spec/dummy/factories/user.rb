Factory.define :user do |user|
  user.full_name       { Faker::Name.name }
  user.email           { |u| Faker::Internet.email(u.full_name) }
end

