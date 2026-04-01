# NexusStore App with Backend API - full stack Application

A complete full-stack application built with **Flutter** (frontend) and **Node.js + Express + MongoDB** (backend).

---

## 📂 Project Structure

```
NexusStore/
├── lib/                  # Flutter Mobile App (frontend)
│   ├── auth/             # Login & Register screens
│   ├── home_page.dart    # Product listing
│   ├── cart.dart         # Cart screen
│   ├── profile_page.dart # User profile & orders
│   └── constants.dart    # API base URL config
│
└── api/                  # Node.js REST API (backend)
    ├── server.js         # Main server file (all routes & models)
    ├── package.json      # Dependencies
    ├── .env              # Environment variables (NOT committed)
    └── api_endpoints.txt # Full endpoint reference
```

---

## 🏛️ Architecture

```
Flutter App  ──HTTP──▶  Node.js / Express  ──Mongoose──▶  MongoDB
   (GetX)                  (Port 3000)                   (Atlas / Local)
```

---

## ⚙️ Part 1 — API Setup & Start Server

### Step 1 — Prerequisites

Make sure you have these installed:
- [Node.js v14+](https://nodejs.org/)
- [MongoDB Atlas](https://www.mongodb.com/atlas/database) (free cloud) OR [MongoDB Local](https://www.mongodb.com/try/download/community)

---

### Step 2 — Navigate to API Folder

```bash
cd api
```

---

### Step 3 — Install Dependencies

```bash
npm install
```

This installs: `express`, `mongoose`, `bcryptjs`, `dotenv`, `cors`

---

### Step 4 — Create the `.env` File

Inside the `api/` folder, create a file named **`.env`**:

```env
# MongoDB Atlas (Cloud) — recommended
MONGO_URI=mongodb+srv://<your_username>:<your_password>@cluster0.mongodb.net/ecommerce?retryWrites=true&w=majority

# OR MongoDB Local
# MONGO_URI=mongodb://localhost:27017/ecommerce

PORT=3000
```

> ⚠️ Replace `<your_username>` and `<your_password>` with your actual MongoDB Atlas credentials.
> The `.env` file is in `.gitignore` and will never be committed.

---

### Step 5 — Start the Server

```bash
npm start
```

**Expected output:**
```
Connected to MongoDB
Database seeded with provided products.
API server running at http://localhost:3000
```

Your API is now live at: **`http://localhost:3000`**

---

## 🌐 Part 2 — API Endpoints (How to Call)

Base URL: `http://localhost:3000`

---

### 👤 Authentication

#### ✅ Register a New User
```
POST /register
Content-Type: application/json
```
**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "mysecretpassword"
}
```
**Response:**
```json
{
  "success": true,
  "user_id": "user_m3f9x2k"
}
```
> 💡 Save the `user_id` — you need it for all cart & order requests.

---

#### ✅ Login
```
POST /login
Content-Type: application/json
```
**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "mysecretpassword"
}
```
**Response:**
```json
{
  "success": true,
  "user_id": "user_m3f9x2k"
}
```

---

### 🛍️ Products

#### ✅ Get All Products
```
GET /products
```
**Response:**
```json
{
  "products": [
    {
      "id": "1",
      "name": "Wireless Mouse",
      "price": 15.99,
      "description": "Ergonomic wireless mouse with smooth tracking.",
      "category": "Electronics",
      "in_stock": true,
      "image": "https://picsum.photos/200?random=2"
    }
  ]
}
```

---

### 🛒 Cart

#### ✅ Add Item to Cart
```
POST /cart
Content-Type: application/json
```
**Request Body:**
```json
{
  "user_id": "user_m3f9x2k",
  "product_id": "1",
  "quantity": 2
}
```
**Response:**
```json
{ "success": true }
```

---

#### ✅ View Cart
```
GET /cart/:user_id
```
**Example:** `GET /cart/user_m3f9x2k`

**Response:**
```json
{
  "user_id": "user_m3f9x2k",
  "items": [
    {
      "product_id": "1",
      "name": "Wireless Mouse",
      "price": 15.99,
      "quantity": 2
    }
  ],
  "total": 31.98
}
```

---

### 📦 Orders

#### ✅ Place Order (Checkout)
```
POST /order
Content-Type: application/json
```
**Request Body:**
```json
{ "user_id": "user_m3f9x2k" }
```
**Response:**
```json
{
  "success": true,
  "message": "Order placed",
  "order_id": "1711900800000"
}
```
> Cart is automatically cleared after placing an order.

---

#### ✅ View Order History
```
GET /order/:user_id
```
**Example:** `GET /order/user_m3f9x2k`

**Response:**
```json
{
  "user_id": "user_m3f9x2k",
  "orders": [
    {
      "order_id": "1711900800000",
      "items": [{ "product_id": "1", "quantity": 2 }],
      "date": "2024-04-01T07:00:00.000Z"
    }
  ]
}
```

---

## 📱 Part 3 — Flutter App Setup

### Step 1 — Install Flutter Dependencies

```bash
flutter pub get
```

### Step 2 — Configure the API Base URL

Open `lib/constants.dart` and set your server address:

```dart
// For Android Emulator — use this IP (points to your PC's localhost)
const String baseUrl = 'http://10.0.2.2:3000';

// For Physical Device — use your PC's local IP on the same Wi-Fi
// const String baseUrl = 'http://192.168.x.x:3000';

// For Web / Desktop
// const String baseUrl = 'http://localhost:3000';
```

### Step 3 — Run the App

```bash
flutter run
```

---

## 🧪 Testing with Postman

1. Import the base URL: `http://localhost:3000`
2. **Register** → `POST /register` → Copy `user_id`
3. **Browse** → `GET /products` → Copy a `product_id`
4. **Add to Cart** → `POST /cart` with `user_id` + `product_id`
5. **Checkout** → `POST /order` with `user_id`
6. **Verify** → `GET /order/:user_id`

> Use [Postman](https://www.postman.com/) or [Thunder Client](https://www.thunderclient.com/) (VS Code extension).

---

## 🔄 Quick Reference — All Endpoints

| Method | Endpoint          | Description              |
|--------|-------------------|--------------------------|
| POST   | `/register`       | Register new user        |
| POST   | `/login`          | Login existing user      |
| GET    | `/products`       | Get all products         |
| POST   | `/cart`           | Add item to cart         |
| GET    | `/cart/:user_id`  | View cart with totals    |
| POST   | `/order`          | Place order (checkout)   |
| GET    | `/order/:user_id` | View past orders         |

---

💡 **Tip**: Always start the Node.js server **before** running the Flutter app so it can fetch data from the API!
