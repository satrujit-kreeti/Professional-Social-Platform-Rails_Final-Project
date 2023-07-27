# Professional Social Platform

## Requirements

Make sure your system meets the following requirements:

- Ruby version: 3.2.2
- Rails version: 6.1.7.4
- Node version:16.20.1
- Yarn version: 1.22.19
- PostgresSQL version: 15.1
- Database: PostgreSQL (or the database specified in `config/database.yml`)
- Node.js and Yarn (for JavaScript dependencies)

## Installation

Follow these steps to set up the application:

1. Clone the repository to your local machine:

   ```bash
   https://github.com/satrujit-kreeti/Professional-Social-Platform-Rails_Final-Project.git
   cd Professional-Social-Platform-Rails_Final-Project
   ```

2. Install required dependency

   ```bash
   bundle install
   ```

3. Install JavaScript dependencies:

   ```bash
   yarn install
   ```

4. Create the database:

   ```bash
   rails db:create
   ```

5. Run database migration:

   ```bash
   rails db:migrate
   ```

6. Start Elasticsearch:

   ```bash
   systemctl restart elasticsearch
   ```

7. Seed the database with sample data:

   ```bash
   rails db:seed
   ```

## Running the Application

To start the Rails server, use the following command:

```bash
rails s
```

## Authentication Credentials

| Role  | Email             | Password |
| ----- | ----------------- | -------- |
| Admin | admin@example.com | password |
| User  | user1@example.com | password |
| User  | user2@example.com | password |
| User  | user3@example.com | password |

For other data follow seeds.rb file
