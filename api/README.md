# 🛍️ NexusStore App with Backend API - full stack application

A professional, student-friendly Node.js REST API for a NexusStore e-commerce application. Built with **Express**, **MongoDB**, and **BcryptJS** for secure user authentication and product management.

---

## 🚀 Features

- **User Authentication**: Secure Registration & Login with password hashing (BcryptJS).
- **Product Catalog**: Automatic database seeding with sample products.
- **Cart Management**: Add items to a persistent cart and view totals.
- **Order Processing**: Place orders and view historical order data.
- **CORS Enabled**: Ready to be consumed by your Flutter or Web application.

---

## 🛠️ Tech Stack

- **Runtime**: [Node.js](https://nodejs.org/)
- **Framework**: [Express.js](https://expressjs.com/)
- **Database**: [MongoDB](https://www.mongodb.com/) (using [Mongoose](https://mongoosejs.com/))
- **Security**: [BcryptJS](https://www.npmjs.com/package/bcryptjs)
- **Environment**: [Dotenv](https://www.npmjs.com/package/dotenv)

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- [Node.js](https://nodejs.org/) (v14 or higher)
- [MongoDB](https://www.mongodb.com/try/download/community) (Local or [Atlas Cloud](https://www.mongodb.com/atlas/database))

---

## ⚙️ Setup & Installation

1.  **Navigate to the API folder**:
    ```bash
    cd api
    ```

2.  **Install dependencies**:
    ```bash
    npm install
    ```

3.  **Configure Environment Variables**:
    Create a file named `.env` in the `api` folder and add your MongoDB connection string:
    ```env
    MONGO_URI=mongodb+srv://<your_username>:<your_password>@cluster0.mongodb.net/ecommerce?retryWrites=true&w=majority
    PORT=3000
    ```
    > [!IMPORTANT]
    > Replace `<your_username>` and `<your_password>` with your actual MongoDB credentials. For local MongoDB, use `mongodb://localhost:27017/ecommerce`.

4.  **Start the Server**:
    ```bash
    npm start
    ```
    The server will start at `http://localhost:3000`.

---

## 📖 API Reference

### User Endpoints

#### 1. Register User
`POST /register`
- **Body**:
  ```json
  {
    "name": "John Doe",
    "email": "john@example.com",
    "password": "mysecretpassword"
  }
  ```
- **Response**: `200 OK` with a unique `user_id`.

#### 2. User Login
`POST /login`
- **Body**:
  ```json
  {
    "email": "john@example.com",
    "password": "mysecretpassword"
  }
  ```
- **Response**: `200 OK` with the `user_id`.

---

### E-Commerce Endpoints

#### 3. List All Products
`GET /products`
- **Description**: Fetches all available products from the database.
- **Example Response**:
  ```json
  {
    "products": [
      {
        "id": "1",
        "name": "Wireless Mouse",
        "price": 15.99,
        "image": "https://picsum.photos/200?random=2"
      }
    ]
  }
  ```

#### 4. Add to Cart
`POST /cart`
- **Body**:
  ```json
  {
    "user_id": "user_id_here",
    "product_id": "1",
    "quantity": 2
  }
  ```

#### 5. View Cart
`GET /cart/:user_id`
- **Description**: Shows items in the cart with calculated totals.
- **Example**: `GET /cart/user_123`

#### 6. Place Order
`POST /order`
- **Body**: `{ "user_id": "user_id_here" }`
- **Action**: Converts cart items into an order and clears the cart.

#### 7. View Orders
`GET /order/:user_id`
- **Description**: Retrieve past order history for a user.

---

## 🧪 How to Test (For Students)

1.  **Register**: Send a `POST` request to `/register` using Postman. Copy the `user_id`.
2.  **Browse**: Send a `GET` request to `/products`. Copy a `product_id`.
3.  **Cart**: Send a `POST` request to `/cart` with your `user_id` and `product_id`.
4.  **Checkout**: Send a `POST` request to `/order` with your `user_id`.
5.  **Verify**: Check `/order/:user_id` to see your new order!

---

💡 **Tip**: Use [Postman](https://www.postman.com/) or [Thunder Client](https://www.thunderclient.com/) (VS Code extension) for an easy testing experience.
