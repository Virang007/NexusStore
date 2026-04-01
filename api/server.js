// Simple Node.js API using Express
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Product Model
const productSchema = new mongoose.Schema({
  id: String,
  name: String,
  price: Number,
  description: String,
  category: String,
  in_stock: Boolean,
  tags: [String],
  image: String
});
const Product = mongoose.model('Product', productSchema);

// User Model
const userSchema = new mongoose.Schema({
  user_id: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true }
});
const User = mongoose.model('User', userSchema);

// Cart Model
const cartItemSchema = new mongoose.Schema({
  product_id: String,
  quantity: Number
});
const cartSchema = new mongoose.Schema({
  user_id: { type: String, required: true, unique: true },
  items: [cartItemSchema]
});
const Cart = mongoose.model('Cart', cartSchema);

// Order Model
const orderItemSchema = new mongoose.Schema({
  product_id: String,
  quantity: Number
});
const orderSchema = new mongoose.Schema({
  order_id: { type: String, required: true, unique: true },
  user_id: { type: String, required: true },
  items: [orderItemSchema],
  date: { type: Date, default: Date.now }
});
const Order = mongoose.model('Order', orderSchema);

// Seed Data
const seedData = [
  { "id": "ab9bffad-64fc-44fc-b17a-d25a4512732e", "name": "Smart Watch", "price": 39.43, "description": "High-quality affordable smart watch featuring advanced technology.", "category": "Office", "in_stock": true, "tags": ["new", "sale", "exclusive"], "image": "https://picsum.photos/200?random=1" },
  { "id": "1", "name": "Wireless Mouse", "price": 15.99, "description": "Ergonomic wireless mouse with smooth tracking.", "category": "Electronics", "in_stock": true, "tags": ["popular", "budget"], "image": "https://picsum.photos/200?random=2" },
  { "id": "2", "name": "Bluetooth Headphones", "price": 59.99, "description": "Noise-cancelling headphones with deep bass.", "category": "Audio", "in_stock": true, "tags": ["trending", "premium"], "image": "https://picsum.photos/200?random=3" },
  { "id": "3", "name": "Laptop Stand", "price": 25.5, "description": "Adjustable aluminum laptop stand.", "category": "Office", "in_stock": false, "tags": ["office", "utility"], "image": "https://picsum.photos/200?random=4" },
  { "id": "4", "name": "Gaming Keyboard", "price": 45, "description": "RGB mechanical keyboard.", "category": "Gaming", "in_stock": true, "tags": ["gaming", "rgb"], "image": "https://picsum.photos/200?random=5" },
  { "id": "5", "name": "USB-C Hub", "price": 29.99, "description": "Multi-port USB-C hub.", "category": "Accessories", "in_stock": true, "tags": ["multiport", "essential"], "image": "https://picsum.photos/200?random=6" }
];

const seedDatabase = async () => {
  try {
    const count = await Product.countDocuments();
    if (count === 0) {
      await Product.insertMany(seedData);
      console.log('Database seeded with provided products.');
    }
  } catch (err) {
    console.error('Error seeding database:', err);
  }
};

// POST /register -> register new user
app.post('/register', async (req, res) => {
  try {
    const { name, email, password } = req.body;
    
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ success: false, message: 'Email already exists' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    
    // Generate a unique user_id
    const user_id = 'user_' + Date.now().toString(36);
    
    const newUser = new User({
      user_id,
      name,
      email,
      password: hashedPassword
    });
    
    await newUser.save();
    
    res.json({ success: true, user_id });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Registration failed' });
  }
});

// POST /login -> login existing user
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ success: false, message: 'Invalid credentials' });
    }
    
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ success: false, message: 'Invalid credentials' });
    }
    
    res.json({ success: true, user_id: user.user_id });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Login failed' });
  }
});

// 1. GET /products -> show products
app.get('/products', async (req, res) => {
  try {
    const products = await Product.find();
    res.json({ products });
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch products' });
  }
});

// 2. POST /cart -> user adds item
app.post('/cart', async (req, res) => {
  try {
    const { user_id, product_id, quantity } = req.body;

    let cart = await Cart.findOne({ user_id });
    if (!cart) {
      cart = new Cart({ user_id, items: [] });
    }

    const existingItem = cart.items.find(i => i.product_id === product_id);
    if (existingItem) {
      existingItem.quantity += quantity;
    } else {
      cart.items.push({ product_id, quantity });
    }

    await cart.save();
    res.json({ success: true });
  } catch (err) {
    res.status(500).json({ error: 'Failed to add to cart' });
  }
});

// 3. GET /cart/:user_id -> show cart
app.get('/cart/:user_id', async (req, res) => {
  try {
    const user_id = req.params.user_id;
    const cart = await Cart.findOne({ user_id });
    const cartItems = cart ? cart.items : [];
    
    let enrichedItems = [];
    let total = 0;

    for (let item of cartItems) {
      const product = await Product.findOne({ id: item.product_id });
      if (product) {
        enrichedItems.push({
          product_id: item.product_id,
          name: product.name,
          price: product.price,
          quantity: item.quantity
        });
        total += product.price * item.quantity;
      }
    }

    res.json({
      user_id: user_id,
      items: enrichedItems,
      total: parseFloat(total.toFixed(2))
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to get cart' });
  }
});

// 4. POST /order -> place order
app.post('/order', async (req, res) => {
  try {
    const { user_id } = req.body;
    const cart = await Cart.findOne({ user_id });

    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ success: false, message: "Cart is empty" });
    }

    const order_id = Date.now().toString();
    const newOrder = new Order({
      order_id,
      user_id,
      items: cart.items
    });

    await newOrder.save();

    console.log("Order placed for user:", user_id, "Order ID:", order_id);

    // clear cart
    cart.items = [];
    await cart.save();

    res.json({ success: true, message: "Order placed", order_id });
  } catch (err) {
    res.status(500).json({ success: false, error: 'Failed to place order' });
  }
});

// 5. GET /order/:user_id -> view past orders
app.get('/order/:user_id', async (req, res) => {
  try {
    const user_id = req.params.user_id;
    const userOrders = await Order.find({ user_id });
    res.json({
      user_id: user_id,
      orders: userOrders
    });
  } catch (err) {
    res.status(500).json({ error: 'Failed to get orders' });
  }
});

// Connect to MongoDB and start server
mongoose.connect(process.env.MONGO_URI)
  .then(async () => {
    console.log('Connected to MongoDB');
    await seedDatabase();
    app.listen(PORT, () => {
      console.log(`API server running at http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error('Failed to connect to MongoDB', err);
  });
