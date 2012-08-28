# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = ["Advertising", "BioTech", "eCommerce", "Enterprise", "Games", "Mobile", "Security", "Social", "Other", "Accelerator", "Coworking", "Investor", "Education", "Service Providers", "Community"]

admin = User.where(username: 'admin@suskc.com').first
admin = User.create(username: 'admin@suskc.com', password: '111111') unless admin
