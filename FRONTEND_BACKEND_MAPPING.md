# Frontend to Backend API Mapping

This document maps each frontend function/feature to the corresponding backend API endpoint.

---

## Authentication & User Management

### Frontend: Login Page (`lib/views/login_page.dart`)
**Function:** User login/sign up with phone number and name

**Backend API:**
- `POST /auth/login`
- Request: `{ "name": "...", "phone": "..." }`
- Response: User object with token

**Frontend Provider:** `AuthProvider.login()`

---

### Frontend: Profile Page - Logout (`lib/views/profile_page.dart`)
**Function:** User logout

**Backend API:**
- `POST /auth/logout`
- Headers: `Authorization: Bearer {token}`

**Frontend Provider:** `AuthProvider.logout()`

---

### Frontend: Profile Page - Get User Info
**Function:** Display current user information

**Backend API:**
- `GET /auth/me`
- Headers: `Authorization: Bearer {token}`

**Frontend Provider:** `AuthProvider` (stores user info after login)

---

## Product Management

### Frontend: Home Page - Load Products (`lib/views/home_page.dart`)
**Function:** Display all products on home page

**Backend API:**
- `GET /products?featured=true` (for featured products)
- `GET /products` (for all products)

**Frontend Provider:** `ProductProvider.loadProducts()`
**Frontend Service:** `ProductService.getProducts()`

---

### Frontend: Product List Page (`lib/views/product_list_page.dart`)
**Function:** Display all products in grid/list view

**Backend API:**
- `GET /products`
- Query params: `page`, `limit`, `search`, `color`, `available`

**Frontend Provider:** `ProductProvider.loadProducts()`

---

### Frontend: Product Detail Page (`lib/views/product_detail_page.dart`)
**Function:** Display single product details

**Backend API:**
- `GET /products/:productId`

**Frontend Provider:** `ProductProvider.selectProduct()`

---

### Frontend: Product Management Page - Add Product (`lib/views/product_management_page.dart`)
**Function:** Admin adds new product

**Backend API:**
- `POST /products`
- Headers: `Authorization: Bearer {admin_token}`
- Request: Product object (name, description, images, color, etc.)

**Frontend Provider:** `ProductProvider.addProduct()`

---

### Frontend: Product Management Page - Update Product
**Function:** Admin updates existing product

**Backend API:**
- `PUT /products/:productId`
- Headers: `Authorization: Bearer {admin_token}`
- Request: Updated product fields

**Frontend Provider:** `ProductProvider.updateProduct()`

---

### Frontend: Product Management Page - Delete Product
**Function:** Admin deletes product

**Backend API:**
- `DELETE /products/:productId`
- Headers: `Authorization: Bearer {admin_token}`

**Frontend Provider:** `ProductProvider.deleteProduct()`

---

## Shopping Cart

### Frontend: Product Detail Page - Add to Cart
**Function:** Add product to cart from product detail page

**Backend API:**
- `POST /cart/items`
- Headers: `Authorization: Bearer {token}`
- Request: `{ "productId": "...", "selectedSize": "Free Size", "quantity": 1 }`

**Frontend Provider:** `CartProvider.addToCart()`

---

### Frontend: Cart Page (`lib/views/cart_page.dart`)
**Function:** Display cart items and total

**Backend API:**
- `GET /cart`
- Headers: `Authorization: Bearer {token}`
- Response: Cart object with items, totalPrice, itemCount

**Frontend Provider:** `CartProvider.items`, `CartProvider.totalPrice`

---

### Frontend: Cart Page - Update Quantity
**Function:** Update quantity of cart item

**Backend API:**
- `PUT /cart/items/:itemId`
- Headers: `Authorization: Bearer {token}`
- Request: `{ "quantity": 2 }`

**Frontend Provider:** `CartProvider.updateQuantity()`

---

### Frontend: Cart Page - Remove Item
**Function:** Remove item from cart

**Backend API:**
- `DELETE /cart/items/:itemId`
- Headers: `Authorization: Bearer {token}`

**Frontend Provider:** `CartProvider.removeFromCart()`

---

### Frontend: Order Confirmation - Clear Cart
**Function:** Clear cart after successful order

**Backend API:**
- `DELETE /cart`
- Headers: `Authorization: Bearer {token}`

**Frontend Provider:** `CartProvider.clearCart()`

**Note:** This happens automatically after order creation

---

## Order Management

### Frontend: Customer Info Form Page - Create Order (`lib/views/customer_info_form_page.dart`)
**Function:** Create order from cart or single product

**Backend API:**
- `POST /orders`
- Headers: `Authorization: Bearer {token}`
- Request:
  ```json
  {
    "items": [
      {
        "productId": "...",
        "selectedSize": "Free Size",
        "quantity": 1
      }
    ],
    "customerInfo": {
      "name": "...",
      "address": "...",
      "city": "...",
      "district": "...",
      "state": "...",
      "pincode": "...",
      "contactNo": "...",
      "courierService": "DTDC"
    }
  }
  ```

**Frontend Provider:** `OrderProvider.createOrderFromCart()`

**Backend Actions:**
1. Generate order ID (WG####)
2. Calculate total amount
3. Set commission (₹50)
4. Reduce product quantities
5. Clear user cart
6. Return order object

---

### Frontend: Order Management Page (`lib/views/order_management_page.dart`)
**Function:** Display all orders with filtering

**Backend API:**
- `GET /orders?status={status}`
- Headers: `Authorization: Bearer {admin_token}`
- Query params: `status` (all, pending, confirmed, shipped, delivered)

**Frontend Provider:** `OrderProvider.orders`, `OrderProvider.getOrdersByStatus()`

---

### Frontend: Order Management Page - Update Status
**Function:** Update order status (Confirm, Ship, Deliver)

**Backend API:**
- `PUT /orders/:orderId/status`
- Headers: `Authorization: Bearer {admin_token}`
- Request: `{ "status": "confirmed" }`

**Frontend Provider:** `OrderProvider.updateOrderStatus()`

**Status Transitions:**
- Pending → Confirm → `confirmed`
- Confirmed → Ship → `shipped`
- Shipped → Deliver → `delivered`
- Any (except delivered) → Cancel → `cancelled`

---

### Frontend: Order Management Page - Delete Order
**Function:** Delete order

**Backend API:**
- `DELETE /orders/:orderId`
- Headers: `Authorization: Bearer {admin_token}`

**Frontend Provider:** `OrderProvider.deleteOrder()`

---

### Frontend: Order Confirmation Page (`lib/views/order_confirmation_page.dart`)
**Function:** Display order confirmation after successful order creation

**Backend API:**
- Uses order data from `POST /orders` response
- No additional API call needed

**Frontend Provider:** `OrderProvider` (order already created)

---

## Sales Dashboard

### Frontend: Sales Dashboard Page (`lib/views/sales_dashboard_page.dart`)
**Function:** Display sales statistics and analytics

**Backend API:**
- `GET /analytics/dashboard`
- Headers: `Authorization: Bearer {admin_token}`

**Frontend Provider:** `OrderProvider` (calculates from orders)
- `totalRevenue`
- `netProfit`
- `totalCommission`
- `totalOrdersCount`
- `pendingOrdersCount`
- `todayRevenue`
- `thisMonthRevenue`
- `getTopSellingProducts()`

**Backend Should Return:**
```json
{
  "totalRevenue": 50000.0,
  "netProfit": 43750.0,
  "totalCommission": 6250.0,
  "totalOrders": 125,
  "pendingOrders": 10,
  "todayRevenue": 1200.0,
  "todayOrders": 3,
  "thisMonthRevenue": 15000.0,
  "thisMonthOrders": 37,
  "topSellingProducts": [...]
}
```

---

## WhatsApp Integration

### Frontend: Customer Info Form - WhatsApp Order Message
**Function:** Generate WhatsApp message and open WhatsApp

**Backend API:**
- `POST /orders/:orderId/whatsapp-message`
- Headers: `Authorization: Bearer {token}`
- Response: Formatted message and WhatsApp URL

**Frontend Service:** `WhatsAppService.launchWhatsAppWithCustomerInfo()`

**Note:** Currently frontend generates message locally, but backend can provide formatted message

---

### Frontend: Payment Page (`lib/views/payment_page.dart`)
**Function:** Display payment information (GPay, PhonePe numbers)

**Backend API:**
- `GET /payment/info`
- Response: Payment numbers

**Frontend:** Currently uses constants from `lib/utils/constants.dart`

---

## Search & Filtering

### Frontend: Home Page - Search Bar
**Function:** Search products by name/description

**Backend API:**
- `GET /products?search={query}`
- Query param: `search` (string)

**Frontend Provider:** `ProductProvider.loadProducts()` (with search query)

---

### Frontend: Home Page - Filter by Category/Model
**Function:** Filter products by category (Dress Models)

**Backend API:**
- `GET /products?color={color}` (if filtering by color)
- Or custom filter parameter

**Frontend Provider:** `ProductProvider.loadProducts()` (with filter)

---

## Additional Features

### Frontend: Profile Page - Menu Items
**Function:** Navigation to various pages

**Backend APIs:**
- Manage Products → `GET /products` (admin)
- Sales Dashboard → `GET /analytics/dashboard` (admin)
- Order Management → `GET /orders` (admin)

---

## Data Flow Examples

### Complete Order Flow

1. **User browses products:**
   - Frontend: `ProductProvider.loadProducts()`
   - Backend: `GET /products`

2. **User adds to cart:**
   - Frontend: `CartProvider.addToCart()`
   - Backend: `POST /cart/items`

3. **User views cart:**
   - Frontend: `CartProvider.items`
   - Backend: `GET /cart`

4. **User proceeds to checkout:**
   - Frontend: Navigate to Customer Info Form
   - No API call yet

5. **User fills customer info and creates order:**
   - Frontend: `OrderProvider.createOrderFromCart()`
   - Backend: `POST /orders`
   - Backend actions:
     - Create order
     - Reduce inventory
     - Clear cart (via `DELETE /cart`)

6. **Order confirmation:**
   - Frontend: Display order confirmation
   - Backend: Order already created, no additional call

7. **WhatsApp message:**
   - Frontend: `WhatsAppService.launchWhatsAppWithCustomerInfo()`
   - Backend: `POST /orders/:orderId/whatsapp-message` (optional)

8. **Admin verifies payment:**
   - Frontend: Order Management Page
   - Backend: `PUT /orders/:orderId/payment`

9. **Admin updates status:**
   - Frontend: `OrderProvider.updateOrderStatus()`
   - Backend: `PUT /orders/:orderId/status`

---

## Inventory Management Flow

### When Order is Created:
1. Frontend: `POST /orders`
2. Backend:
   - Create order
   - For each item: `product.quantity -= item.quantity`
   - If `product.quantity == 0`: Set `product.isAvailable = false`
   - Return updated product quantities

### When Order is Cancelled:
1. Frontend: `PUT /orders/:orderId/status` with `status: "cancelled"`
2. Backend:
   - Update order status
   - For each item: `product.quantity += item.quantity`
   - If `product.quantity > 0`: Set `product.isAvailable = true`

---

## Commission Calculation

### Frontend Calculation:
- `OrderProvider.totalCommission` = Sum of all `order.commission` (₹50 each)
- `OrderProvider.netProfit` = `totalRevenue - totalCommission`

### Backend Should:
- Set `commission: 50.0` on every order creation
- Include in order object
- Use in analytics calculations

---

## Error Handling Mapping

### Frontend Error States:
- `ProductProvider.error` → Backend: 400/404/500 errors
- `CartProvider` errors → Backend: 400 (out of stock, invalid product)
- `OrderProvider.error` → Backend: 400/422 (validation errors)

### Frontend Loading States:
- `ProductProvider.isLoading` → Backend: During `GET /products`
- `OrderProvider.isLoading` → Backend: During order operations

---

## Summary Table

| Frontend Feature | Frontend File | Frontend Provider/Method | Backend API | Notes |
|-----------------|---------------|-------------------------|-------------|-------|
| Login | `login_page.dart` | `AuthProvider.login()` | `POST /auth/login` | Phone-based auth |
| Logout | `profile_page.dart` | `AuthProvider.logout()` | `POST /auth/logout` | |
| Load Products | `home_page.dart` | `ProductProvider.loadProducts()` | `GET /products` | |
| Product Details | `product_detail_page.dart` | `ProductProvider.selectProduct()` | `GET /products/:id` | |
| Add to Cart | `product_detail_page.dart` | `CartProvider.addToCart()` | `POST /cart/items` | |
| View Cart | `cart_page.dart` | `CartProvider.items` | `GET /cart` | |
| Update Cart | `cart_page.dart` | `CartProvider.updateQuantity()` | `PUT /cart/items/:id` | |
| Remove from Cart | `cart_page.dart` | `CartProvider.removeFromCart()` | `DELETE /cart/items/:id` | |
| Create Order | `customer_info_form_page.dart` | `OrderProvider.createOrderFromCart()` | `POST /orders` | Reduces inventory |
| View Orders | `order_management_page.dart` | `OrderProvider.orders` | `GET /orders` | Admin only |
| Update Order Status | `order_management_page.dart` | `OrderProvider.updateOrderStatus()` | `PUT /orders/:id/status` | Admin only |
| Sales Dashboard | `sales_dashboard_page.dart` | `OrderProvider` (various getters) | `GET /analytics/dashboard` | Admin only |
| Add Product | `product_management_page.dart` | `ProductProvider.addProduct()` | `POST /products` | Admin only |
| Update Product | `product_management_page.dart` | `ProductProvider.updateProduct()` | `PUT /products/:id` | Admin only |
| Delete Product | `product_management_page.dart` | `ProductProvider.deleteProduct()` | `DELETE /products/:id` | Admin only |
| WhatsApp Message | `customer_info_form_page.dart` | `WhatsAppService` | `POST /orders/:id/whatsapp-message` | Optional |

---

## Implementation Priority for Backend

1. **Must Have (Phase 1):**
   - Authentication APIs
   - Product CRUD APIs
   - Cart APIs
   - Order Creation API

2. **Important (Phase 2):**
   - Order Listing & Filtering
   - Order Status Updates
   - Payment Verification

3. **Nice to Have (Phase 3):**
   - Analytics Dashboard API
   - Search & Advanced Filtering
   - WhatsApp Message Generation API

---

For detailed API specifications, see `API_DOCUMENTATION.md`  
For quick reference, see `API_QUICK_REFERENCE.md`

