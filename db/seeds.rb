# Skills

skills = [
  ["Ruby", "Programming"],
  ["Python", "Programming"],
  ["JavaScript", "Programming"],
  ["HTML, CSS", "Web Development"],
  ["Ruby on Rails", "Framework"],
  ["Odoo", "ERP"],
  ["Postgresql, SQL", "Database"],
  ["Git, Github", "Tools"],
  ["Webhook, Rest API", "Backend"],
  ["Linux", "Tools"],
  ["Flutter", "Mobile Development"],
  ["System Administration", "IT/Infrastructure"]
]

skills.each do |name, category|
  Skill.find_or_create_by!(name: name) do |skill|
    skill.category = category
  end
end


# Projects

projects = [
  {
    title: "Prayer Book Mobile App",
    description: "A mobile application built with Flutter to provide users with convenient access to prayer and religious content.\n\nTechnologies: Flutter, Dart",
    github_url: "https//:example.com"
  },
  {
    title: "Odoo E-Commerce System",
    description: "An e-commerce platform developed using Odoo, with integrations and customizations for online shopping and business processes.\n\nTechnologies: Odoo, Python, PostgreSQL",
    github_url: "https//:example.com"
  },
  {
    title: "Water Level Monitoring System",
    description: "An IoT-based system using ESP32 to monitor water levels and provide real-time readings for easier monitoring and management.\n\nTechnologies: ESP32, IoT, Sensors, C/C++",
    github_url: "https//:example.com"
  },
  {
    title: "Potfolio Website",
    description: "My personal portfolio built with Ruby on Rails. Technologies: Ruby on Rails, Postgresql",
    github_url: "https://github.com/example/portfolio"
  }
]

projects.each do |project|
  Project.find_or_create_by!(title: project[:title]) do |p|
    p.description = project[:description]
    p.github_url = project[:github_url]
  end
end


# Experiences

experiences = [
  {
    company: "DrukSmart Private Limited",
    position: "Software Developer Intern",
    description: "Completed a 6-month internship as a Software Developer, contributing to the development and customization of web-based applications. Worked with Odoo, Python, web technologies, and system integrations while gaining practical experience in software development.",
    period: 0
  },
  {
    company: "Selise Bhutan",
    position: "Backend Developer",
    description: "Currently working as a Backend Developer, focusing on building and maintaining backend services, developing APIs, working with databases, and implementing reliable software solutions.",
    period: 1
  }
]

experiences.each do |experience|
  Experience.find_or_create_by!(company: experience[:company]) do |e|
    e.position = experience[:position]
    e.description = experience[:description]
    e.period = experience[:period]
  end
end


# Education

educations = [
  {
    institution: "College of Science and Technology",
    qualification: "Bachelors of Engineering in Information Technology"
  },
  {
    institution: "Karma Academy",
    qualification: "Higher Secondary Education"
  },
  {
    institution: "Nganglam Higher Secondary School",
    qualification: "Middle Secondary Education"
  }
]

educations.each do |education|
  Education.find_or_create_by!(institution: education[:institution]) do |e|
    e.qualification = education[:qualification]
  end
end

puts "Portfolio data seeded successfully!"
