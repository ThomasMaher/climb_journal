## Climb Journal

This is the backend api for my application for tracking climbing sessions, and visualizing climbing progress over time.

- Ruby 3.3.9
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

Start PostgreSQL/Rails with Docker Compose:

`docker compose up -d`

Verify that the container is running:

`docker ps`

Stop the database:

`docker compose down`

#### Database Setup

Create the database (first time only):

`docker compose run --rm rails bin/rails db:prepare db:seed`

#### to run tests

`docker compose run --rm -e RAILS_ENV=test rails bundle exec rspec`

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