# Westerngram E-Commerce - Backend API Documentation

## Table of Contents
1. [Overview](#overview)
2. [Data Models](#data-models)
3. [Authentication APIs](#authentication-apis)
4. [Product APIs](#product-apis)
5. [Cart APIs](#cart-apis)
6. [Order APIs](#order-apis)
7. [Customer APIs](#customer-apis)
8. [Analytics & Dashboard APIs](#analytics--dashboard-apis)
9. [Payment & WhatsApp Integration](#payment--whatsapp-integration)
10. [Error Handling](#error-handling)

---

## Overview

**Application Name:** Westerngram - Premium Western Wear  
**Base URL:** `https://api.westerngram.net/v1` (Replace with your actual backend URL)  
**API Version:** v1  
**Content-Type:** `application/json`

### Business Rules
- All products have a fixed online price: **₹400**
- Base cost per product: **₹250**
- Commission per order: **₹50** (to "Abi Bro")
- All products are "Free Size" (one size fits all)
- Orders are confirmed via WhatsApp payment verification
- Delivery time: **3 working days**
- Courier services: **DTDC** or **INDIA POST**

---

## Data Models

### Product Model
```json
{
  "id": "string (required, unique)",
  "name": "string (required)",
  "description": "string (required)",
  "images": ["string"] (array of image URLs),
  "price": 400.0 (fixed, number),
  "color": "string (required, e.g., 'Pink', 'Blue', 'Red')",
  "quantity": 1 (number, available stock),
  "availableSizes": ["Free Size"] (array, always contains 'Free Size'),
  "isFeatured": false (boolean),
  "isAvailable": true (boolean),
  "createdAt": "ISO 8601 datetime string",
  "updatedAt": "ISO 8601 datetime string"
}
```

### CartItem Model
```json
{
  "productId": "string (required)",
  "selectedSize": "Free Size" (string, always 'Free Size'),
  "quantity": 1 (number, min: 1)
}
```

### CustomerInfo Model
```json
{
  "name": "string (required, min: 2, max: 100)",
  "address": "string (required, min: 10, max: 200)",
  "city": "string (required, min: 2, max: 50)",
  "district": "string (required, min: 2, max: 50)",
  "state": "string (required, min: 2, max: 50)",
  "pincode": "string (required, exactly 6 digits)",
  "contactNo": "string (required, exactly 10 digits)",
  "courierService": "DTDC" or "INDIA POST" (string, default: 'DTDC')
}
```

### Order Model
```json
{
  "id": "string (required, format: 'WG####', e.g., 'WG1234')",
  "items": [
    {
      "productId": "string",
      "productName": "string",
      "quantity": 1,
      "size": "Free Size",
      "price": 400.0,
      "totalPrice": 400.0,
      "color": "string"
    }
  ],
  "orderDate": "ISO 8601 datetime string",
  "status": "pending | confirmed | shipped | delivered | cancelled",
  "totalAmount": 400.0 (number),
  "customerInfo": {
    // CustomerInfo object
  },
  "commission": 50.0 (number, fixed),
  "paymentStatus": "pending | verified | failed",
  "paymentScreenshot": "string (URL to payment screenshot, optional)",
  "createdAt": "ISO 8601 datetime string",
  "updatedAt": "ISO 8601 datetime string"
}
```

### User Model
```json
{
  "id": "string (required, unique)",
  "name": "string (required)",
  "phone": "string (required, 10 digits)",
  "email": "string (optional, can be auto-generated)",
  "role": "customer | business_admin" (string, default: 'customer'),
  "permissions": ["string"] (array of permission strings),
  "isActive": true (boolean),
  "createdAt": "ISO 8601 datetime string",
  "updatedAt": "ISO 8601 datetime string"
}
```

### User Roles
- **customer**: Regular users who can browse, add to cart, and place orders
- **business_admin**: Business owners with full system access (manage products, orders, analytics)

---

## Authentication APIs

### 1. User Login/Sign Up
**Endpoint:** `POST /auth/login`  
**Description:** Unified login endpoint for both Customer and Business Admin. Automatically creates new user if doesn't exist. Role is determined based on admin whitelist.

**Request Body:**
```json
{
  "name": "John Doe",
  "phone": "9876543210"
}
```

**Request Validation:**
- `name`: Required, 2-100 characters
- `phone`: Required, exactly 10 digits, numeric only

**Response (200 OK) - Customer:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_cust_123",
      "name": "John Doe",
      "phone": "9876543210",
      "email": "9876543210@westerngram.net",
      "role": "customer",
      "permissions": [
        "view_products",
        "view_product_details",
        "add_to_cart",
        "view_cart",
        "update_cart",
        "remove_from_cart",
        "create_order",
        "view_own_orders",
        "view_own_profile",
        "update_own_profile"
      ],
      "createdAt": "2024-01-15T10:30:00Z"
    },
    "token": "jwt_token_here",
    "refreshToken": "refresh_token_here" (optional),
    "expiresIn": 86400
  },
  "message": "Login successful"
}
```

**Response (200 OK) - Business Admin:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_admin_456",
      "name": "Admin User",
      "phone": "9123456789",
      "email": "admin@westerngram.net",
      "role": "business_admin",
      "permissions": [
        "view_products",
        "create_product",
        "update_product",
        "delete_product",
        "view_all_orders",
        "update_order_status",
        "verify_payment",
        "view_analytics",
        "view_dashboard",
        "manage_inventory"
      ],
      "createdAt": "2024-01-10T08:00:00Z"
    },
    "token": "jwt_token_here",
    "refreshToken": "refresh_token_here" (optional),
    "expiresIn": 86400
  },
  "message": "Login successful"
}
```

**Business Logic:**
1. Validate request (name, phone format)
2. Check if user exists by phone number
3. If user doesn't exist:
   - Check if phone is in admin whitelist
   - Create new user with appropriate role (customer or business_admin)
4. If user exists:
   - Verify user is active
   - Return existing user data
5. Generate JWT token with user ID, phone, role, and permissions
6. Return user data with token

**Role Assignment:**
- Phone numbers in admin whitelist → `business_admin` role
- All other phone numbers → `customer` role

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "error": "Validation failed",
  "code": "VALIDATION_ERROR",
  "details": {
    "name": ["Name must be between 2 and 100 characters"],
    "phone": ["Phone number must be exactly 10 digits"]
  }
}
```

**Error Response (401 Unauthorized):**
```json
{
  "success": false,
  "error": "Account is deactivated",
  "code": "ACCOUNT_DEACTIVATED"
}
```

**Rate Limiting:**
- 5 login attempts per phone number per 15 minutes
- Returns 429 Too Many Requests if exceeded

---

### 2. User Logout
**Endpoint:** `POST /auth/logout`  
**Description:** Logout current user  
**Headers:** `Authorization: Bearer {token}` (if using JWT)

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

### 3. Get Current User
**Endpoint:** `GET /auth/me`  
**Description:** Get current authenticated user details  
**Headers:** `Authorization: Bearer {token}` (if using JWT)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "user_123",
    "name": "John Doe",
    "phone": "9876543210",
    "email": "9876543210@westerngram.net",
    "role": "customer"
  }
}
```

---

## Product APIs

### 1. Get All Products
**Endpoint:** `GET /products`  
**Description:** Retrieve all products with optional filtering

**Query Parameters:**
- `featured` (boolean, optional): Filter featured products
- `available` (boolean, optional): Filter available products
- `color` (string, optional): Filter by color
- `search` (string, optional): Search by name or description
- `page` (number, optional): Page number for pagination (default: 1)
- `limit` (number, optional): Items per page (default: 20)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "products": [
      {
        "id": "prod_1",
        "name": "Floral Summer Dress",
        "description": "Beautiful floral print dress...",
        "images": ["https://..."],
        "price": 400.0,
        "color": "Pink",
        "quantity": 1,
        "availableSizes": ["Free Size"],
        "isFeatured": true,
        "isAvailable": true
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 50,
      "totalPages": 3
    }
  }
}
```

---

### 2. Get Featured Products
**Endpoint:** `GET /products/featured`  
**Description:** Get all featured products

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "products": [
      // Array of featured products
    ]
  }
}
```

---

### 3. Get Product by ID
**Endpoint:** `GET /products/:productId`  
**Description:** Get single product details

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "prod_1",
    "name": "Floral Summer Dress",
    "description": "Beautiful floral print dress...",
    "images": ["https://..."],
    "price": 400.0,
    "color": "Pink",
    "quantity": 1,
    "availableSizes": ["Free Size"],
    "isFeatured": true,
    "isAvailable": true
  }
}
```

**Error Response (404 Not Found):**
```json
{
  "success": false,
  "error": "Product not found"
}
```

---

### 4. Create Product (Admin Only)
**Endpoint:** `POST /products`  
**Description:** Create a new product  
**Headers:** `Authorization: Bearer {admin_token}`

**Request Body:**
```json
{
  "name": "New Product",
  "description": "Product description",
  "images": ["https://image-url.com/image.jpg"],
  "color": "Pink",
  "quantity": 1,
  "isFeatured": false,
  "isAvailable": true
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "prod_new",
    "name": "New Product",
    "description": "Product description",
    "images": ["https://image-url.com/image.jpg"],
    "price": 400.0,
    "color": "Pink",
    "quantity": 1,
    "availableSizes": ["Free Size"],
    "isFeatured": false,
    "isAvailable": true,
    "createdAt": "2024-01-15T10:30:00Z"
  },
  "message": "Product created successfully"
}
```

---

### 5. Update Product (Admin Only)
**Endpoint:** `PUT /products/:productId`  
**Description:** Update existing product  
**Headers:** `Authorization: Bearer {admin_token}`

**Request Body:** (All fields optional, only include fields to update)
```json
{
  "name": "Updated Product Name",
  "description": "Updated description",
  "images": ["https://new-image.jpg"],
  "color": "Blue",
  "quantity": 2,
  "isFeatured": true,
  "isAvailable": true
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    // Updated product object
  },
  "message": "Product updated successfully"
}
```

---

### 6. Delete Product (Admin Only)
**Endpoint:** `DELETE /products/:productId`  
**Description:** Delete a product  
**Headers:** `Authorization: Bearer {admin_token}`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Product deleted successfully"
}
```

---

## Cart APIs

### 1. Get User Cart
**Endpoint:** `GET /cart`  
**Description:** Get current user's cart items  
**Headers:** `Authorization: Bearer {token}`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "productId": "prod_1",
        "product": {
          // Full product object
        },
        "selectedSize": "Free Size",
        "quantity": 2
      }
    ],
    "totalPrice": 800.0,
    "itemCount": 2
  }
}
```

---

### 2. Add Item to Cart
**Endpoint:** `POST /cart/items`  
**Description:** Add product to cart  
**Headers:** `Authorization: Bearer {token}`

**Request Body:**
```json
{
  "productId": "prod_1",
  "selectedSize": "Free Size",
  "quantity": 1
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "items": [
      // Updated cart items
    ],
    "totalPrice": 400.0,
    "itemCount": 1
  },
  "message": "Item added to cart"
}
```

**Error Response (400 Bad Request):**
```json
{
  "success": false,
  "error": "Product out of stock" or "Product not available"
}
```

---

### 3. Update Cart Item Quantity
**Endpoint:** `PUT /cart/items/:itemId`  
**Description:** Update quantity of cart item  
**Headers:** `Authorization: Bearer {token}`

**Request Body:**
```json
{
  "quantity": 3
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    // Updated cart object
  },
  "message": "Cart updated"
}
```

---

### 4. Remove Item from Cart
**Endpoint:** `DELETE /cart/items/:itemId`  
**Description:** Remove item from cart  
**Headers:** `Authorization: Bearer {token}`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    // Updated cart object
  },
  "message": "Item removed from cart"
}
```

---

### 5. Clear Cart
**Endpoint:** `DELETE /cart`  
**Description:** Clear all items from cart  
**Headers:** `Authorization: Bearer {token}`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Cart cleared"
}
```

---

## Order APIs

### 1. Create Order
**Endpoint:** `POST /orders`  
**Description:** Create a new order from cart or single product  
**Headers:** `Authorization: Bearer {token}`

**Request Body:**
```json
{
  "items": [
    {
      "productId": "prod_1",
      "selectedSize": "Free Size",
      "quantity": 1
    }
  ],
  "customerInfo": {
    "name": "John Doe",
    "address": "123 Main Street",
    "city": "Mumbai",
    "district": "Mumbai",
    "state": "Maharashtra",
    "pincode": "400001",
    "contactNo": "9876543210",
    "courierService": "DTDC"
  }
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "data": {
    "id": "WG1234",
    "items": [
      {
        "productId": "prod_1",
        "productName": "Floral Summer Dress",
        "quantity": 1,
        "size": "Free Size",
        "price": 400.0,
        "totalPrice": 400.0,
        "color": "Pink"
      }
    ],
    "orderDate": "2024-01-15T10:30:00Z",
    "status": "pending",
    "totalAmount": 400.0,
    "customerInfo": {
      // CustomerInfo object
    },
    "commission": 50.0,
    "paymentStatus": "pending"
  },
  "message": "Order created successfully"
}
```

**Business Logic:**
- Generate order ID in format `WG####` (e.g., WG1234)
- Calculate total amount from items
- Set commission to ₹50
- Set status to "pending"
- Set paymentStatus to "pending"
- Reduce product quantities in inventory
- Clear user's cart after order creation

---

### 2. Get All Orders
**Endpoint:** `GET /orders`  
**Description:** Get all orders (filtered by user role)  
**Headers:** `Authorization: Bearer {token}`

**Query Parameters:**
- `status` (string, optional): Filter by status (pending, confirmed, shipped, delivered, cancelled)
- `page` (number, optional): Page number
- `limit` (number, optional): Items per page
- `startDate` (ISO 8601, optional): Filter orders from date
- `endDate` (ISO 8601, optional): Filter orders to date

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "orders": [
      {
        // Order objects
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "totalPages": 5
    }
  }
}
```

**Note:** 
- Regular users see only their own orders
- Admin users see all orders

---

### 3. Get Order by ID
**Endpoint:** `GET /orders/:orderId`  
**Description:** Get single order details  
**Headers:** `Authorization: Bearer {token}`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    // Full order object
  }
}
```

---

### 4. Update Order Status (Admin Only)
**Endpoint:** `PUT /orders/:orderId/status`  
**Description:** Update order status  
**Headers:** `Authorization: Bearer {admin_token}`

**Request Body:**
```json
{
  "status": "confirmed" // pending | confirmed | shipped | delivered | cancelled
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    // Updated order object
  },
  "message": "Order status updated"
}
```

**Status Flow:**
- `pending` → `confirmed` → `shipped` → `delivered`
- Any status (except `delivered`) → `cancelled`

---

### 5. Verify Payment (Admin Only)
**Endpoint:** `PUT /orders/:orderId/payment`  
**Description:** Verify payment for an order  
**Headers:** `Authorization: Bearer {admin_token}`

**Request Body:**
```json
{
  "paymentStatus": "verified", // pending | verified | failed
  "paymentScreenshot": "https://screenshot-url.com/image.jpg" (optional)
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    // Updated order object
  },
  "message": "Payment verified"
}
```

**Business Logic:**
- When payment is verified, automatically update order status to "confirmed"
- Send confirmation notification (if notification system exists)

---

### 6. Delete Order (Admin Only)
**Endpoint:** `DELETE /orders/:orderId`  
**Description:** Delete an order  
**Headers:** `Authorization: Bearer {admin_token}`

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Order deleted successfully"
}
```

---

## Customer APIs

### 1. Get Customer Info
**Endpoint:** `GET /customers/me`  
**Description:** Get current user's customer information  
**Headers:** `Authorization: Bearer {token}`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "id": "user_123",
    "name": "John Doe",
    "phone": "9876543210",
    "email": "9876543210@westerngram.net",
    "addresses": [
      {
        // Address objects if multiple addresses feature exists
      }
    ]
  }
}
```

---

### 2. Update Customer Profile
**Endpoint:** `PUT /customers/me`  
**Description:** Update customer profile  
**Headers:** `Authorization: Bearer {token}`

**Request Body:**
```json
{
  "name": "Updated Name",
  "email": "newemail@example.com" (optional)
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    // Updated customer object
  },
  "message": "Profile updated successfully"
}
```

---

## Analytics & Dashboard APIs

### 1. Get Sales Dashboard Data (Admin Only)
**Endpoint:** `GET /analytics/dashboard`  
**Description:** Get sales dashboard statistics  
**Headers:** `Authorization: Bearer {admin_token}`

**Query Parameters:**
- `startDate` (ISO 8601, optional): Start date for statistics
- `endDate` (ISO 8601, optional): End date for statistics

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "totalRevenue": 50000.0,
    "netProfit": 43750.0,
    "totalCommission": 6250.0,
    "totalOrders": 125,
    "pendingOrders": 10,
    "todayRevenue": 1200.0,
    "todayOrders": 3,
    "thisMonthRevenue": 15000.0,
    "thisMonthOrders": 37,
    "topSellingProducts": [
      {
        "productId": "prod_1",
        "productName": "Floral Summer Dress",
        "totalSold": 45,
        "revenue": 18000.0
      }
    ]
  }
}
```

**Calculations:**
- `totalRevenue` = Sum of all order totalAmounts
- `totalCommission` = Number of orders × ₹50
- `netProfit` = totalRevenue - totalCommission
- `todayRevenue` = Sum of orders placed today
- `thisMonthRevenue` = Sum of orders placed this month
- `topSellingProducts` = Top 5 products by quantity sold

---

### 2. Get Order Statistics (Admin Only)
**Endpoint:** `GET /analytics/orders`  
**Description:** Get order statistics by status  
**Headers:** `Authorization: Bearer {admin_token}`

**Query Parameters:**
- `startDate` (ISO 8601, optional)
- `endDate` (ISO 8601, optional)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "byStatus": {
      "pending": 10,
      "confirmed": 25,
      "shipped": 15,
      "delivered": 70,
      "cancelled": 5
    },
    "byDate": [
      {
        "date": "2024-01-15",
        "orders": 5,
        "revenue": 2000.0
      }
    ]
  }
}
```

---

### 3. Get Product Analytics (Admin Only)
**Endpoint:** `GET /analytics/products`  
**Description:** Get product sales analytics  
**Headers:** `Authorization: Bearer {admin_token}`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "popularProducts": [
      {
        "productId": "prod_1",
        "productName": "Floral Summer Dress",
        "totalSold": 45,
        "revenue": 18000.0
      }
    ],
    "lowStockProducts": [
      {
        "productId": "prod_2",
        "productName": "Casual Denim Jacket",
        "quantity": 0,
        "isAvailable": false
      }
    ]
  }
}
```

---

## Payment & WhatsApp Integration

### 1. Generate WhatsApp Order Message
**Endpoint:** `POST /orders/:orderId/whatsapp-message`  
**Description:** Generate formatted WhatsApp message for order  
**Headers:** `Authorization: Bearer {token}`

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "message": "Hi, I want to confirm this order\n\nOrder ID: WG1234\n\nProduct: Floral Summer Dress – Pink – Free Size\nPrice: ₹400\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\nTotal Amount: ₹400\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n📋 Customer Details:\nName: John Doe\nMobile: 9876543210\nAddress: 123 Main Street\nCity: Mumbai\nDistrict: Mumbai\nState: Maharashtra\nPincode: 400001\nCourier: DTDC OR India Post\n\n💳 Payment Options:\nGoogle Pay: 8075997930\nPhonePe: 8075997930\n\nThank you for ordering from Westerngram®.\nPlease complete payment and share screenshot to confirm your order.",
    "whatsappUrl": "https://wa.me/919605452566?text=..."
  }
}
```

---

### 2. Get Payment Information
**Endpoint:** `GET /payment/info`  
**Description:** Get payment details (GPay, PhonePe numbers)

**Response (200 OK):**
```json
{
  "success": true,
  "data": {
    "gpayNumber": "8075997930",
    "phonepeNumber": "8075997930",
    "whatsappNumber": "919605452566",
    "orderWhatsAppNumber": "919605452566"
  }
}
```

---

## Error Handling

### Standard Error Response Format
```json
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE" (optional),
  "details": {} (optional, additional error details)
}
```

### HTTP Status Codes
- `200 OK` - Successful request
- `201 Created` - Resource created successfully
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `409 Conflict` - Resource conflict (e.g., duplicate)
- `422 Unprocessable Entity` - Validation errors
- `500 Internal Server Error` - Server error

### Common Error Codes
- `VALIDATION_ERROR` - Request validation failed
- `PRODUCT_NOT_FOUND` - Product doesn't exist
- `PRODUCT_OUT_OF_STOCK` - Insufficient stock
- `ORDER_NOT_FOUND` - Order doesn't exist
- `UNAUTHORIZED` - Authentication required
- `FORBIDDEN` - Insufficient permissions
- `INVALID_STATUS_TRANSITION` - Invalid order status change

### Validation Error Response (422)
```json
{
  "success": false,
  "error": "Validation failed",
  "code": "VALIDATION_ERROR",
  "details": {
    "field": ["Error message for field"],
    "pincode": ["Pincode must be 6 digits"],
    "contactNo": ["Contact number must be 10 digits"]
  }
}
```

---

## Additional Notes

### Order ID Generation
- Format: `WG####` (e.g., WG1234)
- Generate using: Last 4 digits of timestamp or sequential number
- Ensure uniqueness

### Inventory Management
- When order is created, reduce product quantity
- If quantity becomes 0, set `isAvailable` to `false`
- When order is cancelled, restore product quantity

### Commission Calculation
- Fixed commission: ₹50 per order
- Automatically calculated on order creation
- Tracked separately for analytics

### Payment Verification Flow
1. Customer places order → Status: `pending`, Payment: `pending`
2. Customer sends payment screenshot via WhatsApp
3. Admin verifies payment → Status: `confirmed`, Payment: `verified`
4. Admin ships order → Status: `shipped`
5. Order delivered → Status: `delivered`

### Search Functionality
- Search should work on product name and description
- Case-insensitive
- Partial matching supported

### Pagination
- Default page size: 20 items
- Maximum page size: 100 items
- Include pagination metadata in all list responses

---

## API Rate Limiting (Recommended)
- Public endpoints: 100 requests/minute
- Authenticated endpoints: 200 requests/minute
- Admin endpoints: 500 requests/minute

---

## Security Considerations
1. **Authentication:**
   - Use JWT tokens or session-based authentication
   - Token expiration: 24 hours (configurable)
   - Refresh token mechanism recommended

2. **Authorization:**
   - Role-based access control (customer vs admin)
   - Users can only access their own orders/cart
   - Admin endpoints require admin role

3. **Data Validation:**
   - Validate all input data
   - Sanitize user inputs
   - Prevent SQL injection, XSS attacks

4. **CORS:**
   - Configure CORS for Flutter app domain
   - Allow only necessary HTTP methods

5. **HTTPS:**
   - All API calls must use HTTPS
   - Never send sensitive data over HTTP

---

## Testing Endpoints

### Health Check
**Endpoint:** `GET /health`  
**Response:**
```json
{
  "status": "ok",
  "timestamp": "2024-01-15T10:30:00Z",
  "version": "1.0.0"
}
```

---

## Implementation Priority

### Phase 1 (Core Functionality)
1. Authentication APIs
2. Product APIs (CRUD)
3. Cart APIs
4. Order Creation API

### Phase 2 (Order Management)
1. Order Status Updates
2. Order Listing & Filtering
3. Payment Verification

### Phase 3 (Analytics)
1. Sales Dashboard API
2. Order Statistics
3. Product Analytics

### Phase 4 (Enhancements)
1. Search functionality
2. Advanced filtering
3. Notifications (optional)

---

## Contact & Support
For API implementation questions or issues, contact the development team.

**Last Updated:** 2024-01-15  
**Version:** 1.0.0

