# Authentication & Customer API Documentation

**Base URL:** `http://localhost:8080/api/v1`  
**Version:** 1.0.0

---

## Overview

All authenticated endpoints require a JWT in the `Authorization` header:

```
Authorization: Bearer <your_jwt_token>
```

- Token is returned from `POST /auth/register` or `POST /auth/login`.
- Token expires in **24 hours** (`expiresIn`: 86400 seconds).
- Algorithm: **HS256**.

---

## Response Format

### Success

```json
{
  "success": true,
  "data": { ... },
  "message": "Optional message"
}
```

If `message` is empty, it may be omitted.

### Error

```json
{
  "success": false,
  "error": "Human-readable message",
  "code": "ERROR_CODE",
  "details": { ... }
}
```

- `code`: e.g. `VALIDATION_ERROR`, `UNAUTHORIZED`, `NOT_FOUND`, `ACCOUNT_DEACTIVATED`.
- `details`: optional; for validation errors, a map of field → array of messages.

---

## Endpoints

---

### 1. Register (customer only, app)

**`POST /api/v1/auth/register`**

- **Auth:** None (public).
- **Behavior:** Creates a new **customer** only. Required: **name**, **phone**, **password**. **Email** is optional. Default role is `customer`. Business admins cannot be created via this endpoint. Intended for app-only customer sign-up.
- **If phone already registered:** `409 Conflict` with `ALREADY_REGISTERED`.

#### Request Body

| Field     | Type   | Required | Constraints                          |
|-----------|--------|----------|--------------------------------------|
| `name`    | string | ✅       | 2–100 characters                     |
| `phone`   | string | ✅       | Exactly 10 digits                    |
| `password`| string | ✅       | At least 6 characters                |
| `email`   | string | ❌       | If omitted, `phone@westerngram.net` is used |

**Example (with optional email):**

```json
{
  "name": "Jane Doe",
  "phone": "9876543210",
  "password": "secret123",
  "email": "jane@example.com"
}
```

**Example (email omitted):**

```json
{
  "name": "Jane Doe",
  "phone": "9876543210",
  "password": "secret123"
}
```

#### Success Response `201 Created`

```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user_xxx",
      "name": "Jane Doe",
      "phone": "9876543210",
      "email": "jane@example.com",
      "role": "customer",
      "permissions": ["view_products", "view_product_details", "add_to_cart", "view_cart", "update_cart", "remove_from_cart", "create_order", "view_own_orders", "view_own_profile", "update_own_profile"],
      "createdAt": "2025-01-25T10:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 86400
  },
  "message": "Registration successful"
}
```

#### Error Responses

| Status | `code`              | When                                                |
|--------|---------------------|-----------------------------------------------------|
| 422    | `VALIDATION_ERROR`  | Invalid JSON or missing `name`/`phone`/`password` (binding) |
| 400    | `VALIDATION_ERROR`  | Name not 2–100 chars, phone not 10 digits, or password &lt; 6 chars |
| 409    | `ALREADY_REGISTERED`| Phone number already registered                     |
| 500    | `INTERNAL_ERROR`    | Server or DB error                                  |

---

### 2. Login (registered users only)

**`POST /api/v1/auth/login`**

- **Auth:** None (public).
- **Behavior:** Login only for **already registered** users. Does **not** create new users. If the phone is not registered → `404` with `NOT_REGISTERED`; user must register first via `POST /auth/register`.

#### Request Body

| Field  | Type   | Required | Constraints                          |
|--------|--------|----------|--------------------------------------|
| `name` | string | ✅       | 2–100 characters                     |
| `phone`| string | ✅       | Exactly 10 digits                    |

**Example:**

```json
{
  "name": "John Doe",
  "phone": "9876543210"
}
```

#### Success Response `200 OK`

```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "name": "John Doe",
      "phone": "9876543210",
      "email": "9876543210@westerngram.net",
      "role": "customer",
      "permissions": ["read:products", "create:orders", ...],
      "createdAt": "2025-01-25T10:00:00Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expiresIn": 86400
  },
  "message": "Login successful"
}
```

- `role`: `customer` or `business_admin`.
- `expiresIn`: seconds until token expiry (86400 = 24h).

#### Error Responses

| Status | `code`              | When                                                |
|--------|---------------------|-----------------------------------------------------|
| 422    | `VALIDATION_ERROR`  | Invalid JSON or missing `name`/`phone` (binding)    |
| 400    | `VALIDATION_ERROR`  | Name not 2–100 chars or phone not 10 digits         |
| 404    | `NOT_REGISTERED`    | Phone number not registered; must register first    |
| 401    | `ACCOUNT_DEACTIVATED` | Account is deactivated                            |
| 500    | `INTERNAL_ERROR`    | Server or DB error                                  |

**Example 400 (validation):**

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

---

### 3. Logout

**`POST /api/v1/auth/logout`**

- **Auth:** None.
- **Behavior:** Client-side only; invalidate token on the frontend. Server returns success.

#### Success Response `200 OK`

```json
{
  "success": true,
  "data": null,
  "message": "Logged out successfully"
}
```

---

### 4. Get Current User (Auth)

**`GET /api/v1/auth/me`**  
**`GET /api/v1/customers/me`**

- **Auth:** Required (`Authorization: Bearer <token>`).
- **Behavior:** Returns the current user profile.

#### Success Response `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "John Doe",
    "phone": "9876543210",
    "email": "john@example.com",
    "role": "customer",
    "createdAt": "2025-01-25T10:00:00Z"
  }
}
```

#### Error Responses

| Status | `code`        | When                          |
|--------|---------------|-------------------------------|
| 401    | `UNAUTHORIZED`| Missing/invalid/expired token |
| 404    | `NOT_FOUND`   | User not found                |

---

### 5. Update Profile

**`PUT /api/v1/customers/me`**

- **Auth:** Required.
- **Behavior:** Update `name` and/or `email`. Omitted fields are left unchanged.

#### Request Body

| Field   | Type   | Required | Notes              |
|---------|--------|----------|--------------------|
| `name`  | string | ❌       | 2–100 chars        |
| `email` | string | ❌       | At least one of name/email |

**Example:**

```json
{
  "name": "John Updated",
  "email": "john.new@example.com"
}
```

#### Success Response `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "John Updated",
    "phone": "9876543210",
    "email": "john.new@example.com",
    "role": "customer",
    "createdAt": "2025-01-25T10:00:00Z"
  },
  "message": "Profile updated successfully"
}
```

#### Error Responses

| Status | When                          |
|--------|-------------------------------|
| 401    | Missing/invalid/expired token |
| 422    | Validation (e.g. binding)     |
| 500    | Server/DB error               |

---

### 6. Get Saved Address

**`GET /api/v1/customers/me/address`**

- **Auth:** Required.
- **Behavior:** Returns the customer’s saved delivery address. `data` is `null` if none.

#### Success Response `200 OK` (with address)

```json
{
  "success": true,
  "data": {
    "name": "John Doe",
    "address": "123 Main St, Block A",
    "city": "Mumbai",
    "district": "Mumbai",
    "state": "Maharashtra",
    "pincode": "400001",
    "contactNo": "9876543210",
    "courierService": "DTDC"
  }
}
```

#### Success Response `200 OK` (no address)

```json
{
  "success": true,
  "data": null
}
```

#### Error Responses

| Status | When                          |
|--------|-------------------------------|
| 401    | Missing/invalid/expired token |
| 500    | Server/DB error               |

---

### 7. Save Address

**`PUT /api/v1/customers/me/address`**

- **Auth:** Required.
- **Behavior:** Upsert delivery address (one per user). Used when placing orders if no `customerInfo` is sent.

#### Request Body (`CustomerInfo`)

| Field           | Type   | Required | Constraints              |
|-----------------|--------|----------|--------------------------|
| `name`          | string | ✅       | 2–100 characters         |
| `address`       | string | ✅       | Non-empty                |
| `city`          | string | ✅       | Non-empty                |
| `district`      | string | ✅       | Non-empty                |
| `state`         | string | ✅       | Non-empty                |
| `pincode`       | string | ✅       | Exactly 6 digits         |
| `contactNo`     | string | ✅       | Exactly 10 digits        |
| `courierService`| string | ❌       | e.g. `DTDC`, `INDIA POST`|

**Example:**

```json
{
  "name": "John Doe",
  "address": "123 Main St, Block A",
  "city": "Mumbai",
  "district": "Mumbai",
  "state": "Maharashtra",
  "pincode": "400001",
  "contactNo": "9876543210",
  "courierService": "DTDC"
}
```

#### Success Response `200 OK`

```json
{
  "success": true,
  "data": { "saved": true },
  "message": "Address saved successfully"
}
```

#### Error Responses

| Status | `code`             | When                                                       |
|--------|--------------------|------------------------------------------------------------|
| 401    | `UNAUTHORIZED`     | Missing/invalid/expired token                              |
| 400    | `VALIDATION_ERROR` | address/name/city/district/state/pincode/contactNo invalid |
| 422    | `VALIDATION_ERROR` | JSON binding error                                         |
| 500    | —                  | Server/DB error                                            |

**Validation rules:**

- `name`: 2–100 characters  
- `address`: required  
- `city`, `district`, `state`: required  
- `pincode`: 6 digits  
- `contactNo`: 10 digits  

---

## Auth Error Details (401)

When `Authorization` is missing or invalid:

```json
{
  "success": false,
  "error": "Authorization required",
  "code": "UNAUTHORIZED"
}
```

```json
{
  "success": false,
  "error": "Invalid authorization header format",
  "code": "UNAUTHORIZED"
}
```

```json
{
  "success": false,
  "error": "Invalid or expired token",
  "code": "UNAUTHORIZED"
}
```

Use **`Authorization: Bearer <token>`**; `Bearer` is case-insensitive.

---

## Roles

| Role             | Value           | Description        |
|------------------|-----------------|--------------------|
| Customer         | `customer`      | Default for signup |
| Business Admin   | `business_admin`| From `ADMIN_PHONES` whitelist |

---

## Summary Table

| Method | Path                      | Auth   | Description           |
|--------|---------------------------|--------|-----------------------|
| POST   | `/api/v1/auth/register`   | ❌     | Register (customer, app-only) |
| POST   | `/api/v1/auth/login`      | ❌     | Login (registered only) |
| POST   | `/api/v1/auth/logout`     | ❌     | Logout (client-side)  |
| GET    | `/api/v1/auth/me`         | ✅     | Get current user      |
| GET    | `/api/v1/customers/me`    | ✅     | Get current user      |
| PUT    | `/api/v1/customers/me`    | ✅     | Update profile        |
| GET    | `/api/v1/customers/me/address` | ✅ | Get saved address     |
| PUT    | `/api/v1/customers/me/address` | ✅ | Save address          |

---

## App Implementation

| Backend path              | App usage |
|---------------------------|-----------|
| `POST /auth/register`     | `AuthApi.register()` → `AuthViewModel.register()` → `RegisterPage` |
| `POST /auth/login`        | `AuthApi.login()` → `AuthViewModel.login()`. On `NOT_REGISTERED` → "Phone number not registered. Please create an account first." |
| `POST /auth/logout`       | `AuthApi.logout()` → `AuthViewModel.logout()` |
| `GET /auth/me`            | `AuthApi.getMe()` → `AuthViewModel.restoreSession()` |
| `GET /customers/me`       | `CustomerApi.getMe()` |
| `PUT /customers/me`       | `CustomerApi.updateProfile()` |
| `GET /customers/me/address`  | `CustomerApi.getAddress()` |
| `PUT /customers/me/address`  | `CustomerApi.saveAddress()` |

**Base URL:** `Constants.apiBaseUrl` in `lib/core/constants/app_constants.dart` = `http://localhost:8080/api/v1`. All HTTP via `ApiService` in `lib/core/api/api_service.dart`.
