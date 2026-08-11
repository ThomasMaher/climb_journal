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

#### Installation

- Clone the repo for the UI: https://github.com/ThomasMaher/climb-journal-web
- In this repo, the ./docker-compose.yml must have the correct location for your local UI repo
  - After cloning the UI, update the path under web:build:context: to match the relative location of your local repo
- run `docker compose up -d`
- Verify that the container is running: `docker ps`

To stop the app run `docker compose down`

#### Database Setup

Create the database (first time only):

`docker compose run --rm rails bin/rails db:prepare db:seed`

#### to run tests

`docker compose run --rm -e RAILS_ENV=test rails bundle exec rspec`


#### TODO:
- ✅ Containerize the Rails application
- ✅Containerize the React frontend
- ✅ Authentication
- ✅ User accounts
- ⏭ Host application
- Allow for searching previously created boulders to add to your session 
- Improved analytics and visualizations
- Upload images of boulders
- Boulders can have overall stats (number of climb attempts, number of sends) 