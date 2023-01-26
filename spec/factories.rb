FactoryGirl.define do
  factory :contact do
    name "John Doe"
    email  "johndoe@gmail.com"
    points 0
  end

  factory :referral do
    name 'Mike Johnson'
    email 'mike@gmail.com'
  end
end