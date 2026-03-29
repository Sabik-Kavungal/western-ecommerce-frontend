# Westerngram Backend API - Implementation Guide

## 📋 Overview

This directory contains comprehensive documentation for building the backend APIs for the **Westerngram E-Commerce** Flutter application. All frontend functions are implemented and finalized. This documentation provides everything needed to build matching backend APIs.

---

## 📚 Documentation Files

### 1. **API_DOCUMENTATION.md** (Main Documentation)
Complete API specification with:
- All endpoints with request/response formats
- Data models and schemas
- Authentication requirements
- Business rules and logic
- Error handling
- Security considerations

**👉 Start here for detailed API specifications**

---

### 2. **API_QUICK_REFERENCE.md** (Quick Guide)
Quick reference for developers:
- Essential endpoints summary table
- Key business rules
- Common error codes
- Implementation checklist
- Testing checklist

**👉 Use this for quick lookups during development**

---

### 3. **FRONTEND_BACKEND_MAPPING.md** (Mapping Guide)
Maps frontend features to backend APIs:
- Every frontend function → corresponding backend API
- Data flow examples
- Complete order flow
- Inventory management flow
- Summary table of all mappings

**👉 Use this to understand how frontend connects to backend**

---

## 🚀 Quick Start

### Step 1: Understand the Application
- **App Name:** Westerngram - Premium Western Wear
- **Type:** E-commerce platform for western wear
- **Frontend:** Flutter (already implemented)
- **Backend:** To be built (use this documentation)

### Step 2: Review Business Rules
- Fixed price: ₹400 per product
- Commission: ₹50 per order
- All products: "Free Size" (one size fits all)
- Orders confirmed via WhatsApp payment verification
- Delivery: 3 working days

### Step 3: Start Implementation
Follow the priority order in `API_DOCUMENTATION.md`:
1. **Phase 1:** Core APIs (Auth, Products, Cart, Orders)
2. **Phase 2:** Order Management
3. **Phase 3:** Analytics
4. **Phase 4:** Enhancements

---

## 🎯 Key Features to Implement

### Authentication
- Phone number based login/sign up
- JWT or session-based authentication
- Role-based access (customer vs admin)

### Products
- CRUD operations for products
- Featured products
- Search and filtering
- Inventory management

### Shopping Cart
- Add/remove items
- Update quantities
- Persistent cart (per user)

### Orders
- Create orders from cart
- Order status management
- Payment verification
- Customer information handling

### Analytics (Admin)
- Sales dashboard
- Revenue and profit calculations
- Order statistics
- Top selling products

---

## 📊 Data Models

### Core Models:
1. **Product** - Product information
2. **CartItem** - Shopping cart items
3. **Order** - Order details
4. **CustomerInfo** - Customer shipping information
5. **User** - User account information

See `API_DOCUMENTATION.md` for complete model specifications.

---

## 🔐 Authentication Flow

1. User provides name and phone number
2. Backend creates/retrieves user account
3. Backend returns user object (and token if using JWT)
4. Frontend stores authentication state
5. Subsequent requests include authentication token

---

## 📦 Order Flow

1. **User adds products to cart**
   - `POST /cart/items`

2. **User proceeds to checkout**
   - Fills customer information form

3. **Order is created**
   - `POST /orders`
   - Backend: Generate order ID (WG####)
   - Backend: Calculate total amount
   - Backend: Set commission (₹50)
   - Backend: Reduce inventory
   - Backend: Clear cart

4. **WhatsApp message generated**
   - User opens WhatsApp with order details
   - Includes payment information

5. **Payment verification** (Admin)
   - Admin verifies payment screenshot
   - `PUT /orders/:id/payment` → status: "verified"
   - Order status → "confirmed"

6. **Order fulfillment**
   - Admin updates status: `confirmed` → `shipped` → `delivered`

---

## 💰 Pricing & Commission

### Product Pricing:
- **Base Cost:** ₹250 per product
- **Selling Price:** ₹400 per product (fixed)
- **Profit per product:** ₹150

### Order Commission:
- **Commission per order:** ₹50 (to "Abi Bro")
- **Net profit per order:** Total amount - ₹50

### Example:
- Order with 2 products:
  - Total: ₹800
  - Commission: ₹50
  - Net Profit: ₹750

---

## 🗄️ Database Schema Suggestions

### Users Table
```
- id (PK)
- name
- phone (unique)
- email
- role (customer/admin)
- createdAt
- updatedAt
```

### Products Table
```
- id (PK)
- name
- description
- images (JSON array)
- price (fixed 400.0)
- color
- quantity
- availableSizes (JSON array, always ["Free Size"])
- isFeatured
- isAvailable
- createdAt
- updatedAt
```

### Cart Items Table
```
- id (PK)
- userId (FK)
- productId (FK)
- selectedSize (always "Free Size")
- quantity
- createdAt
- updatedAt
```

### Orders Table
```
- id (PK, format: WG####)
- userId (FK)
- status
- totalAmount
- commission (fixed 50.0)
- paymentStatus
- paymentScreenshot (URL, optional)
- orderDate
- createdAt
- updatedAt
```

### Order Items Table
```
- id (PK)
- orderId (FK)
- productId (FK)
- productName (snapshot)
- quantity
- size
- price
- totalPrice
- color
```

### Customer Info Table
```
- id (PK)
- orderId (FK, one-to-one)
- name
- address
- city
- district
- state
- pincode
- contactNo
- courierService
```

---

## 🔧 Technology Stack Recommendations

### Backend Framework Options:
- **Node.js + Express** (JavaScript/TypeScript)
- **Python + FastAPI/Django** (Python)
- **Java + Spring Boot** (Java)
- **PHP + Laravel** (PHP)
- **Go + Gin** (Go)

### Database Options:
- **PostgreSQL** (Recommended for relational data)
- **MySQL/MariaDB** (Alternative)
- **MongoDB** (If using NoSQL)

### Authentication:
- **JWT (JSON Web Tokens)** (Recommended)
- **Session-based** (Alternative)

### Additional Services:
- **File Storage:** AWS S3, Cloudinary (for product images)
- **Email Service:** SendGrid, AWS SES (for notifications, optional)
- **Caching:** Redis (for performance)

---

## ✅ Implementation Checklist

### Phase 1: Core APIs
- [ ] Set up project structure
- [ ] Database setup and migrations
- [ ] Authentication API (`POST /auth/login`, `POST /auth/logout`, `GET /auth/me`)
- [ ] Product CRUD APIs
- [ ] Cart APIs (GET, POST, PUT, DELETE)
- [ ] Order Creation API

### Phase 2: Order Management
- [ ] Order Listing API with filters
- [ ] Order Status Update API
- [ ] Payment Verification API
- [ ] Order by ID API

### Phase 3: Analytics
- [ ] Sales Dashboard API
- [ ] Order Statistics API
- [ ] Product Analytics API

### Phase 4: Enhancements
- [ ] Search functionality
- [ ] Advanced filtering
- [ ] Pagination
- [ ] Error handling
- [ ] Rate limiting
- [ ] Logging
- [ ] Testing

---

## 🧪 Testing

### Test Cases to Cover:
1. **Authentication:**
   - Login with valid/invalid credentials
   - Logout
   - Token expiration

2. **Products:**
   - Get all products
   - Get featured products
   - Get product by ID
   - Create/Update/Delete product (admin)

3. **Cart:**
   - Add to cart
   - Update quantity
   - Remove from cart
   - Clear cart

4. **Orders:**
   - Create order
   - Get orders (with filters)
   - Update order status
   - Payment verification
   - Inventory updates on order creation/cancellation

5. **Analytics:**
   - Dashboard data accuracy
   - Commission calculations
   - Revenue calculations

---

## 📝 Important Notes

1. **Order ID Format:** Must be `WG####` (e.g., WG1234)
2. **Inventory Management:** Automatically reduce quantity on order creation
3. **Commission:** Fixed ₹50 per order, always included
4. **Product Price:** Always ₹400, cannot be changed
5. **Free Size:** All products are "Free Size", no size variations
6. **Payment:** Verified via WhatsApp screenshot (manual process)
7. **Cart:** Should be persistent per user (stored in database)

---

## 🐛 Common Issues & Solutions

### Issue: Order ID Collision
**Solution:** Use UUID or timestamp-based generation with uniqueness check

### Issue: Inventory Race Condition
**Solution:** Use database transactions and locks when updating inventory

### Issue: Cart Persistence
**Solution:** Store cart in database, not just in memory

### Issue: Commission Calculation
**Solution:** Always calculate as: Number of orders × ₹50

---

## 📞 Support

For questions or clarifications:
1. Review `API_DOCUMENTATION.md` for detailed specifications
2. Check `FRONTEND_BACKEND_MAPPING.md` for frontend connections
3. Refer to `API_QUICK_REFERENCE.md` for quick lookups

---

## 🎉 Next Steps

1. **Choose your tech stack**
2. **Set up development environment**
3. **Create database schema**
4. **Start with Phase 1 APIs**
5. **Test with Flutter frontend**
6. **Iterate and improve**

---

## 📄 File Structure

```
.
├── API_DOCUMENTATION.md          # Complete API specification
├── API_QUICK_REFERENCE.md        # Quick reference guide
├── FRONTEND_BACKEND_MAPPING.md   # Frontend to backend mapping
└── BACKEND_API_README.md         # This file (overview)
```

---

**Good luck with your backend implementation! 🚀**

For detailed information, always refer to `API_DOCUMENTATION.md`

