# Login API Design - Westerngram E-Commerce

## Overview

This document provides a comprehensive design for the Login API that handles both **Customer** and **Business Admin** user types using a single unified endpoint.

---

## User Types

### 1. Customer
- Regular users who browse and purchase products
- Can view products, add to cart, place orders
- Can view their own orders
- **Cannot** access admin features

### 2. Business Admin
- Business owners/managers
- Full access to all features
- Can manage products, orders, view analytics
- Can update order status, verify payments
- **Full system access**

---

## API Endpoint

### Login/Sign Up
**Endpoint:** `POST /auth/login`  
**Description:** Unified login endpoint for both Customer and Business Admin  
**Authentication:** Not required (public endpoint)

---

## Request Specification

### Request Headers
```
Content-Type: application/json
```

### Request Body
```json
{
  "name": "string (required, min: 2, max: 100)",
  "phone": "string (required, exactly 10 digits, numeric only)"
}
```

### Request Body Schema
| Field | Type | Required | Validation | Description |
|-------|------|----------|------------|-------------|
| `name` | string | Yes | 2-100 characters | User's full name |
| `phone` | string | Yes | Exactly 10 digits, numeric | Phone number (without country code) |

### Request Examples

#### Customer Login
```json
{
  "name": "John Doe",
  "phone": "9876543210"
}
```

#### Business Admin Login
```json
{
  "name": "Admin User",
  "phone": "9123456789"
}
```

---

## Response Specification

### Success Response (200 OK)

#### Response Structure
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "string",
      "name": "string",
      "phone": "string",
      "email": "string",
      "role": "customer" | "business_admin",
      "permissions": ["string"],
      "createdAt": "ISO 8601 datetime string"
    },
    "token": "string (JWT token)",
    "refreshToken": "string (optional, for refresh token flow)",
    "expiresIn": 86400 (number, seconds)
  },
  "message": "Login successful"
}
```

#### Customer Response Example
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
        "add_to_cart",
        "view_cart",
        "create_order",
        "view_own_orders"
      ],
      "createdAt": "2024-01-15T10:30:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "refresh_token_here",
    "expiresIn": 86400
  },
  "message": "Login successful"
}
```

#### Business Admin Response Example
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
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "refresh_token_here",
    "expiresIn": 86400
  },
  "message": "Login successful"
}
```

---

## Error Responses

### 400 Bad Request - Validation Error
```json
{
  "success": false,
  "error": "Validation failed",
  "code": "VALIDATION_ERROR",
  "details": {
    "name": ["Name is required", "Name must be between 2 and 100 characters"],
    "phone": ["Phone number must be exactly 10 digits", "Phone number must contain only numbers"]
  }
}
```

### 401 Unauthorized - Invalid Credentials
```json
{
  "success": false,
  "error": "Invalid phone number or unauthorized access",
  "code": "UNAUTHORIZED"
}
```

### 500 Internal Server Error
```json
{
  "success": false,
  "error": "Internal server error",
  "code": "INTERNAL_ERROR"
}
```

---

## Business Logic

### Login Flow

1. **Receive Request**
   - Validate request body (name, phone)
   - Validate phone format (10 digits, numeric)

2. **Check User Existence**
   - Query database for user with matching phone number
   - If user exists → Proceed to step 3
   - If user doesn't exist → Create new user (step 4)

3. **Existing User Login**
   - Verify user is active
   - Check user role (customer or business_admin)
   - Generate JWT token with user data and role
   - Return user data with token

4. **New User Sign Up**
   - Create new user account
   - Set role to "customer" by default
   - Generate JWT token
   - Return user data with token

5. **Business Admin Identification**
   - Check if phone number exists in admin whitelist/table
   - If yes, set role to "business_admin"
   - If no, set role to "customer"

### Role Assignment Logic

```javascript
// Pseudo-code
function determineUserRole(phone) {
  // Check if phone is in admin whitelist
  const adminPhones = ["9123456789", "9876543210"]; // From database/config
  const isAdmin = adminPhones.includes(phone);
  
  return isAdmin ? "business_admin" : "customer";
}
```

### Token Generation

**JWT Payload Structure:**
```json
{
  "userId": "user_123",
  "phone": "9876543210",
  "role": "customer" | "business_admin",
  "permissions": ["permission1", "permission2"],
  "iat": 1705312200,
  "exp": 1705398600
}
```

**Token Expiration:**
- Access Token: 24 hours (86400 seconds)
- Refresh Token: 7 days (optional)

---

## Permissions System

### Customer Permissions
```json
[
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
]
```

### Business Admin Permissions
```json
[
  // Customer permissions +
  "view_all_products",
  "create_product",
  "update_product",
  "delete_product",
  "view_all_orders",
  "view_order_details",
  "update_order_status",
  "verify_payment",
  "cancel_order",
  "delete_order",
  "view_analytics",
  "view_dashboard",
  "view_sales_statistics",
  "manage_inventory",
  "view_all_users",
  "manage_users"
]
```

---

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  phone VARCHAR(10) UNIQUE NOT NULL,
  email VARCHAR(255),
  role ENUM('customer', 'business_admin') DEFAULT 'customer',
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX idx_phone (phone),
  INDEX idx_role (role)
);
```

### Admin Whitelist Table (Optional)
```sql
CREATE TABLE admin_whitelist (
  id INT PRIMARY KEY AUTO_INCREMENT,
  phone VARCHAR(10) UNIQUE NOT NULL,
  admin_name VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_phone (phone)
);
```

---

## Security Considerations

### 1. Phone Number Validation
- Must be exactly 10 digits
- Must contain only numbers
- Validate format before database query

### 2. Rate Limiting
- Limit login attempts per phone number
- Example: 5 attempts per 15 minutes
- Prevent brute force attacks

### 3. Token Security
- Use strong JWT secret key
- Include expiration time
- Store tokens securely on client
- Implement refresh token mechanism

### 4. Role-Based Access Control (RBAC)
- Validate user role on every protected endpoint
- Check permissions before allowing actions
- Return 403 Forbidden for unauthorized access

### 5. Input Sanitization
- Sanitize all user inputs
- Prevent SQL injection
- Prevent XSS attacks

---

## Implementation Examples

### Node.js/Express Example
```javascript
// POST /auth/login
async function login(req, res) {
  try {
    const { name, phone } = req.body;
    
    // Validation
    if (!name || name.length < 2 || name.length > 100) {
      return res.status(400).json({
        success: false,
        error: "Name must be between 2 and 100 characters",
        code: "VALIDATION_ERROR"
      });
    }
    
    if (!phone || !/^\d{10}$/.test(phone)) {
      return res.status(400).json({
        success: false,
        error: "Phone number must be exactly 10 digits",
        code: "VALIDATION_ERROR"
      });
    }
    
    // Check if user exists
    let user = await User.findOne({ phone });
    
    if (!user) {
      // Create new user
      const role = await checkAdminWhitelist(phone) ? 'business_admin' : 'customer';
      
      user = await User.create({
        id: generateUserId(),
        name,
        phone,
        email: `${phone}@westerngram.net`,
        role
      });
    }
    
    // Check if user is active
    if (!user.is_active) {
      return res.status(401).json({
        success: false,
        error: "Account is deactivated",
        code: "ACCOUNT_DEACTIVATED"
      });
    }
    
    // Generate token
    const token = generateJWT({
      userId: user.id,
      phone: user.phone,
      role: user.role,
      permissions: getPermissions(user.role)
    });
    
    // Get permissions
    const permissions = getPermissions(user.role);
    
    res.json({
      success: true,
      data: {
        user: {
          id: user.id,
          name: user.name,
          phone: user.phone,
          email: user.email,
          role: user.role,
          permissions,
          createdAt: user.created_at
        },
        token,
        expiresIn: 86400
      },
      message: "Login successful"
    });
    
  } catch (error) {
    res.status(500).json({
      success: false,
      error: "Internal server error",
      code: "INTERNAL_ERROR"
    });
  }
}

function getPermissions(role) {
  const customerPermissions = [
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
  ];
  
  const adminPermissions = [
    ...customerPermissions,
    "view_all_products",
    "create_product",
    "update_product",
    "delete_product",
    "view_all_orders",
    "view_order_details",
    "update_order_status",
    "verify_payment",
    "cancel_order",
    "delete_order",
    "view_analytics",
    "view_dashboard",
    "view_sales_statistics",
    "manage_inventory",
    "view_all_users",
    "manage_users"
  ];
  
  return role === 'business_admin' ? adminPermissions : customerPermissions;
}
```

### Python/FastAPI Example
```python
from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, validator
import re

router = APIRouter()

class LoginRequest(BaseModel):
    name: str
    phone: str
    
    @validator('name')
    def validate_name(cls, v):
        if len(v) < 2 or len(v) > 100:
            raise ValueError('Name must be between 2 and 100 characters')
        return v
    
    @validator('phone')
    def validate_phone(cls, v):
        if not re.match(r'^\d{10}$', v):
            raise ValueError('Phone number must be exactly 10 digits')
        return v

@router.post("/auth/login")
async def login(request: LoginRequest):
    # Check if user exists
    user = await get_user_by_phone(request.phone)
    
    if not user:
        # Create new user
        role = await check_admin_whitelist(request.phone)
        role = 'business_admin' if role else 'customer'
        
        user = await create_user(
            name=request.name,
            phone=request.phone,
            email=f"{request.phone}@westerngram.net",
            role=role
        )
    
    # Check if active
    if not user.is_active:
        raise HTTPException(status_code=401, detail="Account is deactivated")
    
    # Generate token
    token = generate_jwt_token(user)
    permissions = get_permissions(user.role)
    
    return {
        "success": True,
        "data": {
            "user": {
                "id": user.id,
                "name": user.name,
                "phone": user.phone,
                "email": user.email,
                "role": user.role,
                "permissions": permissions,
                "createdAt": user.created_at.isoformat()
            },
            "token": token,
            "expiresIn": 86400
        },
        "message": "Login successful"
    }
```

---

## Testing

### Test Cases

#### 1. Valid Customer Login
```http
POST /auth/login
Content-Type: application/json

{
  "name": "John Doe",
  "phone": "9876543210"
}
```
**Expected:** 200 OK with customer role and permissions

#### 2. Valid Business Admin Login
```http
POST /auth/login
Content-Type: application/json

{
  "name": "Admin User",
  "phone": "9123456789"
}
```
**Expected:** 200 OK with business_admin role and admin permissions

#### 3. New User Sign Up
```http
POST /auth/login
Content-Type: application/json

{
  "name": "New User",
  "phone": "9999999999"
}
```
**Expected:** 200 OK, new user created with customer role

#### 4. Invalid Phone Number
```http
POST /auth/login
Content-Type: application/json

{
  "name": "John Doe",
  "phone": "12345"
}
```
**Expected:** 400 Bad Request, validation error

#### 5. Missing Name
```http
POST /auth/login
Content-Type: application/json

{
  "phone": "9876543210"
}
```
**Expected:** 400 Bad Request, validation error

#### 6. Rate Limiting
```http
# Send 6 requests within 15 minutes with same phone
```
**Expected:** 429 Too Many Requests after 5 attempts

---

## Frontend Integration

### Flutter Example
```dart
Future<Map<String, dynamic>> login(String name, String phone) async {
  final response = await http.post(
    Uri.parse('$baseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'name': name,
      'phone': phone,
    }),
  );
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    // Store token
    await storage.write(key: 'token', value: data['data']['token']);
    
    // Store user info
    final user = data['data']['user'];
    await storage.write(key: 'userId', value: user['id']);
    await storage.write(key: 'userRole', value: user['role']);
    
    // Update AuthProvider
    authProvider.login(
      userId: user['id'],
      userName: user['name'],
      userEmail: user['email'],
      userRole: user['role'], // Add role to provider
    );
    
    return data;
  } else {
    throw Exception('Login failed');
  }
}
```

---

## Access Control Implementation

### Middleware for Protected Routes

```javascript
// Middleware to check authentication and role
function requireAuth(requiredRole = null) {
  return async (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];
    
    if (!token) {
      return res.status(401).json({
        success: false,
        error: "Authentication required",
        code: "UNAUTHORIZED"
      });
    }
    
    try {
      const decoded = verifyJWT(token);
      req.user = decoded;
      
      // Check role if required
      if (requiredRole && decoded.role !== requiredRole) {
        return res.status(403).json({
          success: false,
          error: "Insufficient permissions",
          code: "FORBIDDEN"
        });
      }
      
      next();
    } catch (error) {
      return res.status(401).json({
        success: false,
        error: "Invalid or expired token",
        code: "UNAUTHORIZED"
      });
    }
  };
}

// Usage
router.get('/products', requireAuth()); // Any authenticated user
router.post('/products', requireAuth('business_admin')); // Admin only
router.get('/analytics/dashboard', requireAuth('business_admin')); // Admin only
```

---

## Summary

### Key Points:
1. **Single Endpoint:** Both user types use `POST /auth/login`
2. **Role Detection:** Automatically determines role based on admin whitelist
3. **Auto Sign Up:** Creates new user if doesn't exist
4. **Permissions:** Returns role-specific permissions in response
5. **Security:** Includes validation, rate limiting, and token-based auth
6. **Flexible:** Easy to add more user types in future

### Next Steps:
1. Implement admin whitelist management
2. Add refresh token mechanism
3. Implement password/PIN (optional, for enhanced security)
4. Add OTP verification (optional, for phone verification)
5. Add account deactivation/reactivation

---

**Last Updated:** 2024-01-15  
**Version:** 1.0.0

