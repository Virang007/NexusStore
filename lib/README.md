# NexusStore — Full Stack Flutter App with Node.js Backend API

A modern, high-performance mobile application built with **Flutter** and **GetX**. This app serves as the frontend for the Search Test E-commerce system, connecting seamlessly to a Node.js backend to provide a real-time shopping experience.

---

## ✨ Features

- **Smooth Onboarding**: Beautiful splash screen and integrated authentication (Login/Register).
- **Dynamic Product Browsing**: 
    - **Real-time Search**: Instant product lookup as you type.
    - **Category Filtering**: Browse products by category (Electronics, Audio, etc.).
- **Interactive Shop**: 
    - **Add to Cart**: Direct interaction with the backend cart system.
    - **Likes/Favorites**: Persistent liking system within the app.
- **User Profile**: Access order history and user details.
- **Cart Management**: Real-time total calculation and checkout flow.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [GetX](https://pub.dev/packages/get) (for ultra-fast performance and clean state management)
- **Routing**: [GetX Routing](https://getx.site/docs/routing)
- **API Communication**: [GetConnect](https://getx.site/docs/getconnect) / [HTTP](https://pub.dev/packages/http)
- **Icons**: [Material Icons](https://api.flutter.dev/flutter/material/Icons-class.html)

---

## ⚙️ Setup & Installation

1.  **Prerequisites**: 
    Ensure you have [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured on your machine.

2.  **Get Dependencies**:
    In the root directory, run:
    ```bash
    flutter pub get
    ```

3.  **Configure API Connection**:
    Open `lib/constants.dart` and update the `baseUrl` to reflect your backend's location.
    ```dart
    // For Android Emulator:
    static const String baseUrl = 'http://10.0.2.2:3000';
    
    // For iOS Simulator / Local Web:
    static const String baseUrl = 'http://localhost:3000';
    
    // For Physical Device:
    static const String baseUrl = 'http://YOUR_LOCAL_IP:3000';
    ```
    > [!IMPORTANT]
    > If using an Android Emulator, the server on your computer is accessible at `10.0.2.2`.

4.  **Run the App**:
    ```bash
    flutter run
    ```

---

## 📂 Project Structure

- **`lib/main.dart`**: Entry point and global theme configuration.
- **`lib/auth/`**: Authentication screens (Splash, Login, Register).
- **`lib/home_page.dart`**: The main discovery screen with product grid and search.
- **`lib/home_controller.dart`**: Logic layer for fetching products, searching, and adding to cart.
- **`lib/cart.dart`**: UI for viewing the user's shopping cart.
- **`lib/profile_page.dart`**: User account and order history details.
- **`lib/constants.dart`**: Centralized API endpoints and configuration.

---

## 🏛️ State Management Logic (GetX)

The app uses `HomeController` (in `lib/home_controller.dart`) to manage all product-related states.
- **`getdata()`**: Fetches raw data from the server.
- **`search(query)`**: Filters products locally for instant results.
- **`addToCart(product)`**: Synchronizes with the Node.js API to persist cart items.

---

💡 **Tip**: To debug network calls, use the **Flutter DevTools** Network tab to see requests being sent to the backend.
