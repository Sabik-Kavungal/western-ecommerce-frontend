# System Scalability and Load Assessment

This document assesses the current frontend (Flutter) and API integration capability to handle high traffic, specifically focusing on the scenario of **1000 concurrent customers** placing orders simultaneously.

## 1. Frontend Performance & UI (Live Traffic)

### Current Strength: Rendering Efficiency
- **Virtualization**: The product and order lists use `GridView.builder` and `ListView.builder`. This ensures that only the visible items are rendered, preventing memory overflow even with 1000+ items.
- **Isolated Repaints**: Use of `RepaintBoundary` around product cards and complex UI elements prevents the entire screen from rebuilding when only one part changes.
- **State Management**: `Provider` with `ChangeNotifier` is used. For 1000 orders, the memory footprint of state objects is negligible (~20-50MB), which modern smartphones handle easily.

### Potential Bottleneck: JSON Parsing
- **Synchronous Decoding**: Current `ApiService` uses `jsonDecode` on the main UI thread. 
- **Recommendation**: For fetching large lists (e.g., 1000 previous orders in one call), moving `jsonDecode` to a background worker using `compute()` or `Isolate.run()` will prevent UI stutters.

## 2. API Integration & Network Load

### Current Setup: Sequential Execution
The checkout process (`submitCheckout` in `CheckoutViewModel`) performs several API calls in sequence:
1. `saveAddress`
2. `getAddress`
3. `createOrder`
4. `getWhatsAppMessage`
5. `loadCart`

**Impact**: With 1000 concurrent users, the backend receives **5000 specialized requests** in a short window. 

### Risk: Timeout & Network Blips
- **Timeouts**: The current 15-second timeout is reasonable, but in a high-load scenario (backend under stress), requests might take 10-20 seconds.
- **Retry Logic**: The current code lacks automatic retry. If 1 out of the 5 sequential calls fails due to a minor network glitch, the entire checkout fails.

### Possibility of Crash
- **Frontend Crash**: Highly unlikely. Flutter manages memory well, and the sequential nature of calls keeps the local resource usage low.
- **API/Backend Crash**: High possibility if the backend server and database are not optimized for 1000 concurrent writes (database locking, connection pool exhaustion).

## 3. Checkout Improvements (Concurrency)

### **Order Creation**
*   **URL:** `/api/v1/orders`
*   **Method:** `POST`

**Behavioral Changes:**
1.  **Strict Stock Check**: The API now performs an atomic check. If multiple users try to buy the last item simultaneously, only the first transaction to hit the database will succeed.
2.  **Rollback Protection**: If order creation fails (e.g., database glitch), any stock subtracted is automatically rolled back via a database transaction.

**New Error Case (Stock Exhaustion):**
If a product goes out of stock between the time it was added to the cart and the "Place Order" button being clicked:
*   **Status Code:** `500 Internal Server Error` (or `400` if validation caught it earlier)
*   **Response Body:**
    ```json
    {
      "success": false,
      "message": "insufficient stock or product not found",
      "errorCode": "INTERNAL_ERROR"
    }
    ```
*   **Frontend Recommendation**: Always check if `success` is true. If false, alert the user and ask them to verify their cart.

---

## 4. High-Load Resilience Recommendations

To ensure smooth operation with 1000+ live customers, we recommend the following enhancements:

### A. API Optimization (Urgent)
- **Retry Mechanism**: Implement exponential backoff for failed GET requests.
- **Request Batching**: Combine `saveAddress` and `createOrder` into a single API endpoint to reduce round-trips.
- **Rate Limit Handling**: Explicitly handle HTTP 429 (Too Many Requests) by showing a "Server Busy - Please Wait" UI.

### B. Scalable Data Loading
- **Pagination**: Ensure `loadOrders` always uses the `page` and `limit` parameters (currently implemented but must be enforced).
- **Isolate-based Decoding**: Update `ApiService` to handle large JSON responses in a separate thread.

### C. Backend Considerations (System-wide)
- **Load Balancer**: Use a load balancer (Nginx/Kong) to distribute 1000 concurrent connections across multiple service instances.
- **Database Indexing**: Ensure the `orders` and `products` tables have indexes on `status`, `userId`, and `createdAt` to keep query times under 100ms.

## Conclusion
**Will it work smooth?**
- **UI**: Yes, the UI code is well-optimized for rendering.
- **API Connection**: It will work for 100 concurrent users easily. For **1000+ concurrent customers**, the backend must be robustly scaled (Docker/Kubernetes + Database Tuning), and the frontend should be updated with retry logic and isolate-based parsing to handle slower response times without "feeling" broken to the user.

**Possibility of Crash**: 
- **Frontend**: Near 0%.
- **API**: Modern servers can handle 1000 concurrent *connections*, but 1000 concurrent *database writes* requires a high-performance database cluster.
