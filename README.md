# Points Transaction Processing API

This is a simple Ruby on Rails application for processing point transactions via single or bulk APIs. The app integrates with mocked external API vendors and stores the data in a PostgreSQL database.

---

## 🚀 Features

- API endpoint to process a **single** point transaction
- API endpoint to process **bulk** point transactions
- Model validations for data integrity
- RSpec tests with Shoulda Matchers
- CI-ready setup (GitHub Actions optional)

---

## 🧰 Tech Stack

- Ruby on Rails
- PostgreSQL
- RSpec
- Shoulda Matchers

---

## 🛠 Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/points-api.git
cd points-api
```

### 2. Install Dependencies
```bash
bundle install
```

### 3. Setup the Database
Ensure PostgreSQL is running locally.
```bash
rails db:create db:migrate
```

### 4. Run the Server
```bash
rails server
```

The app will be available at `http://localhost:3000`

---

## 🔌 API Endpoints

### 📍 POST `/api/v1/transactions/single`
Accepts a single point transaction.

#### Request Body (JSON):
```json
{
  "transaction_id": "tx123",
  "points": 100,
  "user_id": "user001"
}
```

#### Response (Success):
```json
{
  "status": "success",
  "transaction_id": "tx123"
}
```

#### Response (Error):
```json
{
  "status": "error",
  "message": ["Transaction ID can't be blank"]
}
```

---

### 📍 POST `/api/v1/transactions/bulk`
Accepts multiple point transactions in one request.

#### Request Body (JSON):
```json
{
  "transactions": [
    {"transaction_id": "tx124", "points": 50, "user_id": "user002"},
    {"transaction_id": "tx125", "points": 200, "user_id": "user003"}
  ]
}
```

#### Response (Success):
```json
{
  "status": "success",
  "processed_count": 2
}
```

#### Response (Error):
```json
{
  "status": "error",
  "message": ["Transaction ID can't be blank"]
}
```

---

## 🧪 Running Tests

Run all tests:
```bash
bundle exec rspec
```

Tests cover model validations, controller logic, and edge cases for API usage.

---

## ⚙️ Continuous Integration (Optional)
To set up GitHub Actions CI:

1. Add `.github/workflows/ci.yml`
2. Include a job to install dependencies, setup DB, and run tests.
