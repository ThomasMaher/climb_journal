## Climb Journal

This is the backend api for my application for tracking climbing sessions, and visualizing climbing progress over time.

- Ruby 3.2.6
- Ruby on Rails 8.0.5
- PostgreSQL 18
- RSpec

#### Development Tools
- Docker
- Docker Compose
- Git

### Set up

Create a .env file in the project root.

Example:

DATABASE_USER=your_username
DATABASE_PW=your_password
Installation

`bundle install`

Start PostgreSQL with Docker Compose:

`docker compose up -d`

Verify that the container is running:

`docker ps`

Stop the database:

`docker compose down`

#### Database Setup

Create the database (first time only):

`rails db:create db:migrate db:seed`

`rails server`

`bundle exec rspec` to run tests

### Project Structure
backend\
├── app \
├── config\
├── db\
├── spec\
└── Dockerfile

(https://github.com/ThomasMaher/climb-journal-web)
frontend\
├── src\
├── public\
└── package.json


The application currently runs with:

- Rails running locally
- React running locally
- PostgreSQL running in Docker


#### TODO:
- Containerize the Rails application
- Containerize the React frontend
- Authentication
- User accounts
- Improved analytics and visualizations