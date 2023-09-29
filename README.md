> # Professional Social Platform

## Requirements

Make sure your system meets the following requirements:

- Ruby version: 3.2.2
- Rails version: 6.1.7.4
- Node version:16.20.1
- Yarn version: 1.22.19
- PostgresSQL version: 15.1
- Database: PostgreSQL (or the database specified in `config/database.yml`)
- Node.js and Yarn (for JavaScript dependencies)

## Developer Setup

### Direct Setup using curl

Follow these steps to set up the application:

> During this setup **if it ask for password please provide it**. It would mainly ask administrative privilage to run **elastic search**.

1. Copy and paste the below curl command.

   ```bash
   curl -fsSL https://raw.githubusercontent.com/satrujit-kreeti/Professional-Social-Platform-Rails_Final-Project/main/setup.sh | bash
   ```

   > **If curl command is not working** or showing some peer to peer connection error please try to run this command again.

2. To run the dev server

   ```bash
   bin/dev
   ```

### Manual Setup

Follow these steps to set up the application:

1. Clone the repository to your local machine:

   ```bash
   git clone https://github.com/satrujit-kreeti/Professional-Social-Platform-Rails_Final-Project.git
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

8. Create Index for data in elastic search:

   ```bash
   rails c
   User.import
   ```

## Running the Application

To start the Rails server, use the following command:

```bash
rails s
```

## Authentication Credentials

| Role  | Email               | Password   |
| ----- | ------------------- | ---------- |
| Admin | `admin@example.com` | `Super@71` |
| User  | `user1@example.com` | `Super@71` |
| User  | `user2@example.com` | `Super@71` |
| User  | `user3@example.com` | `Super@71` |

For other data follow seeds.rb file
