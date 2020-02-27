FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "defaultuser#{n}@test.com"} # TODO
    password{ (Devise.friendly_token[0,20] + "aA1!").squeeze } # TODO
    sequence(:authentication_token) {|n| "j#{n}-#{n}DwiJY4XwSnmywdMW"}
  end
end
