# Westerngram API - Quick Reference Guide

## Base URL
```
https://api.westerngram.net/v1
```

## Authentication
All authenticated endpoints require: `Authorization: Bearer {token}`

---

## Essential Endpoints Summary

### Authentication
| Method | Endpoint | Description | Auth Required | User Types |
|--------|----------|-------------|---------------|------------|
| POST | `/auth/login` | Login/Sign up (Customer & Admin) | No | Both |
| POST | `/auth/logout` | Logout | Yes | Both |
| GET | `/auth/me` | Get current user | Yes | Both |

### Products
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/products` | Get all products | No |
| GET | `/products/featured` | Get featured products | No |
| GET | `/products/:id` | Get product by ID | No |
| POST | `/products` | Create product | Admin |
| PUT | `/products/:id` | Update product | Admin |
| DELETE | `/products/:id` | Delete product | Admin |

### Cart
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/cart` | Get user cart | Yes |
| POST | `/cart/items` | Add to cart | Yes |
| PUT | `/cart/items/:id` | Update cart item | Yes |
| DELETE | `/cart/items/:id` | Remove from cart | Yes |
| DELETE | `/cart` | Clear cart | Yes |

### Orders
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/orders` | Create order | Yes |
| GET | `/orders` | Get all orders | Yes |
| GET | `/orders/:id` | Get order by ID | Yes |
| PUT | `/orders/:id/status` | Update order status | Admin |
| PUT | `/orders/:id/payment` | Verify payment | Admin |
| DELETE | `/orders/:id` | Delete order | Admin |

### Analytics (Admin Only)
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/analytics/dashboard` | Sales dashboard | Admin |
| GET | `/analytics/orders` | Order statistics | Admin |
| GET | `/analytics/products` | Product analytics | Admin |

---

## Key Business Rules

1. **User Types:**
   - **Customer**: Regular users (browse, cart, orders)
   - **Business Admin**: Full system access (manage products, orders, analytics)
   - Both use same login endpoint, role determined by admin whitelist

2. **Pricing:**
   - All products: ₹400 (fixed)
   - Commission: ₹50 per order
   - Base cost: ₹250 per product

3. **Products:**
   - All products are "Free Size"
   - Quantity: 1 per color variant
   - When quantity = 0, set `isAvailable = false`

4. **Orders:**
   - Order ID format: `WG####` (e.g., WG1234)
   - Status flow: `pending` → `confirmed` → `shipped` → `delivered`
   - On order creation: Reduce inventory, clear cart

5. **Payment:**
   - Payment verified via WhatsApp screenshot
   - When payment verified → Order status = `confirmed`

---

## User Roles & Permissions

### Customer Permissions
- View products
- View product details
- Add to cart
- View/update/remove cart items
- Create orders
- View own orders
- View/update own profile

### Business Admin Permissions
- All customer permissions +
- Create/update/delete products
- View all orders
- Update order status
- Verify payments
- View analytics & dashboard
- Manage inventory
- View sales statistics

### Access Control
- Customer endpoints: Any authenticated user
- Admin endpoints: Require `business_admin` role
- Check role in middleware/authorization layer

---

## Request/Response Examples

### Login (Customer or Admin)
```http
POST /auth/login
Content-Type: application/json

{
  "name": "John Doe",
  "phone": "9876543210"
}
```

**Response:**
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
      "permissions": ["view_products", "add_to_cart", ...]
    },
    "token": "jwt_token_here",
    "expiresIn": 86400
  }
}
```

**Note:** Role automatically determined (customer or business_admin based on admin whitelist)

---

### Create Order
```http
POST /orders
Authorization: Bearer {token}
Content-Type: application/json

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
    "address": "123 Main St",
    "city": "Mumbai",
    "district": "Mumbai",
    "state": "Maharashtra",
    "pincode": "400001",
    "contactNo": "9876543210",
    "courierService": "DTDC"
  }
}
```

### Response
```json
{
  "success": true,
  "data": {
    "id": "WG1234",
    "status": "pending",
    "totalAmount": 400.0,
    "commission": 50.0,
    "orderDate": "2024-01-15T10:30:00Z"
  }
}
```

---

## Data Validation Rules

### Customer Info
- `name`: Required, 2-100 characters
- `address`: Required, 10-200 characters
- `city`: Required, 2-50 characters
- `district`: Required, 2-50 characters
- `state`: Required, 2-50 characters
- `pincode`: Required, exactly 6 digits
- `contactNo`: Required, exactly 10 digits
- `courierService`: "DTDC" or "INDIA POST"

### Product
- `name`: Required, 1-200 characters
- `description`: Required, 1-1000 characters
- `color`: Required, must be from predefined list
- `price`: Always 400.0 (fixed)
- `quantity`: Number, min: 0
- `availableSizes`: Always contains "Free Size"

---

## Error Codes Quick Reference

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 422 | Request validation failed |
| `PRODUCT_NOT_FOUND` | 404 | Product doesn't exist |
| `PRODUCT_OUT_OF_STOCK` | 400 | Insufficient stock |
| `ORDER_NOT_FOUND` | 404 | Order doesn't exist |
| `UNAUTHORIZED` | 401 | Authentication required |
| `FORBIDDEN` | 403 | Insufficient permissions |
| `INVALID_STATUS_TRANSITION` | 400 | Invalid order status change |

---

## Status Codes

### Order Status
- `pending` - Order placed, awaiting payment verification
- `confirmed` - Payment verified, order confirmed
- `shipped` - Order shipped
- `delivered` - Order delivered
- `cancelled` - Order cancelled

### Payment Status
- `pending` - Payment not verified
- `verified` - Payment verified
- `failed` - Payment failed/rejected

---

## Implementation Checklist

### Phase 1: Core APIs
- [ ] Authentication (Login/Logout)
- [ ] Product CRUD
- [ ] Cart Management
- [ ] Order Creation

### Phase 2: Order Management
- [ ] Order Listing
- [ ] Order Status Updates
- [ ] Payment Verification

### Phase 3: Analytics
- [ ] Sales Dashboard
- [ ] Order Statistics
- [ ] Product Analytics

### Phase 4: Additional Features
- [ ] Search & Filtering
- [ ] Pagination
- [ ] Error Handling
- [ ] Rate Limiting

---

## Testing Checklist

- [ ] Test all endpoints with valid data
- [ ] Test validation errors
- [ ] Test authentication/authorization
- [ ] Test order status transitions
- [ ] Test inventory updates
- [ ] Test commission calculations
- [ ] Test pagination
- [ ] Test error responses

---

## Notes for Backend Developers

1. **Order ID Generation:**
   - Use format: `WG####`
   - Ensure uniqueness
   - Can use timestamp or sequential counter

2. **Inventory Management:**
   - Reduce quantity on order creation
   - Restore quantity on order cancellation
   - Update `isAvailable` when quantity = 0

3. **Commission:**
   - Fixed ₹50 per order
   - Tracked in order object
   - Used in profit calculations

4. **WhatsApp Integration:**
   - Generate formatted message for orders
   - Include customer details and payment info
   - Use order WhatsApp number: `919605452566`

5. **Security:**
   - Use HTTPS only
   - Validate all inputs
   - Implement rate limiting
   - Use JWT or secure session tokens

---

For detailed API documentation, see `API_DOCUMENTATION.md`

