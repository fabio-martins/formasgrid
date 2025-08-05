# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Setup and Execution

### Prerequisites
- Ensure you have [Docker](https://docs.docker.com/get-docker/) installed on your machine. 🐳

### Starting the Project 🚀
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```
2. Build and start the Docker containers:
   ```bash
   docker compose -f docker-compose.dev.yml up --build
   ```

### Running Tests 🧪
To run the test suite, execute the following command:
```bash
docker compose -f docker-compose.dev.yml run --rm formasgrid-app rspec
```

### Accessing Swagger 📖
Once the application is running, you can access the Swagger documentation at:
```
http://localhost:3000/api-docs
```

