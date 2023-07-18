# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# admin = User.create!(
#     username: 'Admin',
#     email: 'admin@gmail.com',
#     password: 'password',
#     role: 'admin'
# )

# puts 'Admin user created successfully.'



job_sectors = [
    { name: 'Manufacturing' },
    { name: 'IT' },
    { name: 'Banking' },
    { name: 'Medical' }
  ]
  
  job_sectors.each do |sector|
    JobSector.create(sector)
  end
  
  # Create job roles
  job_roles = [
    { name: 'Designer', job_sector_id: JobSector.find_by(name: 'IT').id },
    { name: 'Developer', job_sector_id: JobSector.find_by(name: 'IT').id },
    { name: 'Receptionist', job_sector_id: JobSector.find_by(name: 'Medical').id },
    { name: 'Medical Representative', job_sector_id: JobSector.find_by(name: 'Medical').id },
    { name: 'Manager', job_sector_id: JobSector.find_by(name: 'Banking').id }
  ]
  
  job_roles.each do |role|
    JobRole.create(role)
  end