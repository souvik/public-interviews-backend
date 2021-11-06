# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Account.create([
  {
    first_name: 'Melissa T',
    last_name: 'Kirk',
    email: 'melissa.kirk@mailinator.com',
    phone_number: '7879787789',
    status: Account.statuses[:verified],
    balance: rand(1000)
  },
  {
    first_name: 'Jennifer E',
    last_name: 'Tanner',
    email: 'jennifer.tanner@mailinator.com',
    phone_number: '3127865397',
    status: Account.statuses[:verified],
    balance: rand(1000)
  },
  {
    first_name: 'Ivan S',
    last_name: 'Harris',
    email: 'ivan.harris@mailinator.com',
    phone_number: '8579762466',
    status: Account.statuses[:pending],
    balance: 0
  },
  {
    first_name: 'Laurie D',
    last_name: 'Stevenson',
    email: 'laurie.stevenson@mailinator.com',
    phone_number: '5673256969',
    status: Account.statuses[:unverified],
    balance: 0
  }
])
