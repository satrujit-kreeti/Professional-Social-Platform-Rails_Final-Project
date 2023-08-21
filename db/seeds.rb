# frozen_string_literal: true

def create_user(attributes)
  User.create!(attributes)
end

create_user(
  username: 'admin',
  email: 'admin@example.com',
  password: 'Super@71',
  role: 'admin'
)

users_data = [
  {
    username: 'userone',
    email: 'user1@example.com',
    password: 'Super@71',
    linkedin_profile: 'https://www.linkedin.com/in/user1',
    qualification: 'Computer Science Graduate',
    experience: '2 years',
    current_organization: 'ABC Tech',
    skills: 'Ruby on Rails, JavaScript, React',
    relevant_skill_notification: true,
    cv_download_permission: 'connections',
    report: 0
  },
  {
    username: 'usertwo',
    email: 'user2@example.com',
    password: 'Super@71',
    linkedin_profile: 'https://www.linkedin.com/in/user2',
    qualification: 'Software Engineer',
    experience: '3 years',
    current_organization: 'XYZ Solutions',
    skills: 'Ruby on Rails, Python, SQL',
    relevant_skill_notification: true,
    cv_download_permission: 'connections',
    report: 0
  },
  {
    username: 'userthree',
    email: 'user3@example.com',
    password: 'Super@71',
    linkedin_profile: 'https://www.linkedin.com/in/user3',
    qualification: 'Web Developer',
    experience: '1 year',
    current_organization: 'Tech Innovators',
    skills: 'HTML, CSS, JavaScript, Vue.js , Python',
    relevant_skill_notification: true,
    cv_download_permission: 'connections',
    report: 4
  }

]

users_data.each do |user_data|
  create_user(user_data)
end

def create_post(user, content)
  user.posts.create!(content:, status: %w[pending approved rejected].sample)
end

users = User.where.not(role: 'admin')

users.each do |user|
  5.times do
    create_post(user, "This is a post by #{user.username}")
  end
end

def create_comment(user, post, content)
  return unless post.approved?

  user.comments.create!(post:, content:)
end

# Create comments for posts
posts = Post.all

posts.each do |post|
  users.sample(3).each do |user| # You can change the number of comments per post here (3 in this case)
    create_comment(user, post, "This is a comment by #{user.username} on post ##{post.id}")
  end
end

users.each do |user|
  friend_ids = users.pluck(:id) - [user.id] - user.friends.pluck(:id)

  friend_ids = friend_ids.sample(3)

  friend_ids.each do |friend_id|
    next if User.find(friend_id).admin?

    Friendship.create!(
      user_id: user.id,
      friend_id:,
      connected: rand(2).zero?,
      requested_by_user_id: user.id
    )
  end
end

job_sectors = JobSector.all
job_roles = JobRole.all

# Define an array of job statuses
job_statuses = %w[pending approved rejected]

job_sectors_data = [
  {
    name: 'Information Technology',
    job_roles: ['Software Developer', 'Data Analyst', 'IT Manager']
  },
  {
    name: 'Healthcare',
    job_roles: ['Nurse', 'Doctor', 'Medical Technician']
  },
  {
    name: 'Finance',
    job_roles: ['Accountant', 'Financial Analyst', 'Investment Banker']
  }
  # Add more job sectors and their job roles as needed
]

job_sectors_data.each do |sector_data|
  job_sector = JobSector.new(name: sector_data[:name])
  sector_data[:job_roles].each do |role_name|
    job_sector.job_roles.build(name: role_name)
  end
  job_sector.save!
end

def all_user_ids
  User.pluck(:id)
end

# Helper method to get all post IDs
def all_post_ids
  Post.pluck(:id)
end

# Seed data for likes
all_post_ids.each do |post_id|
  all_user_ids.each do |user_id|
    Like.create(user_id:, post_id:) unless User.find(user_id).admin?
  end
end

all_user_ids.each do |user_id|
  num_requirements = rand(1..5)

  num_requirements.times do
    job_sector = job_sectors.sample
    job_role = job_roles.sample

    job_title = Faker::Job.title
    job_description = Faker::Lorem.paragraph
    vacancies = rand(1..5)
    skills_list = 'Ruby on Rails, JavaScript, React, Python, SQL, HTML, CSS, Vue.js'

    skills_array = skills_list.split(',').map(&:strip)

    skills_required = skills_array.sample(rand(1..skills_array.length)).join(', ')

    status = job_statuses.sample

    JobRequirement.create!(
      job_title:,
      job_description:,
      vacancies:,
      skills_required:,
      job_sector:,
      job_role:,
      user_id:,
      status:
    )
  end
end

users_data = [
  {
    username: 'userfour',
    email: 'user4@example.com',
    password: 'Super@71',
    linkedin_profile: 'https://www.linkedin.com/in/user1',
    qualification: 'Computer Science Graduate',
    experience: '2 years',
    current_organization: 'ABC Tech',
    skills: 'Ruby on Rails, JavaScript, React',
    relevant_skill_notification: true,
    cv_download_permission: 'connections',
    report: 0
  },
  {
    username: 'userfive',
    email: 'user5@example.com',
    password: 'Super@71',
    linkedin_profile: 'https://www.linkedin.com/in/user2',
    qualification: 'Software Engineer',
    experience: '3 years',
    current_organization: 'XYZ Solutions',
    skills: 'Ruby on Rails, Python, SQL',
    relevant_skill_notification: true,
    cv_download_permission: 'connections',
    report: 0
  },
  {
    username: 'usersix',
    email: 'user6@example.com',
    password: 'Super@71',
    linkedin_profile: 'https://www.linkedin.com/in/user3',
    qualification: 'Web Developer',
    experience: '1 year',
    current_organization: 'Tech Innovators',
    skills: 'HTML, CSS, JavaScript, Vue.js , Python',
    relevant_skill_notification: true,
    cv_download_permission: 'connections',
    report: 4
  }

]

users_data.each do |user_data|
  create_user(user_data)
end

puts 'Seeding completed!'
