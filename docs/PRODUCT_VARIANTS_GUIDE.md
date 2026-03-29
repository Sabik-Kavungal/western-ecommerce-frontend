# Product Variants Integration Guide

This guide explains how to use the new **Product Variants** feature in the Westerngram API. You can now create a product with multiple color options in a single request, with automatic image-to-color matching.

## Endpoint: Create Product with Variants
- **URL**: `/api/v1/products`
- **Method**: `POST`
- **Auth**: Required (Business Admin only)

### Request Structure (JSON)

| Field | Type | Description |
| :--- | :--- | :--- |
| `name` | string | **Required**. Name of the product group (e.g., "Polo T-Shirt"). |
| `description` | string | **Required**. Product description. |
| `price` | number | **Required**. Price (applies to all variants). |
| `categoryId` | string | **Required**. The UUID/ID of the category. |
| `images` | array[string] | Global list of image URLs. Used for auto-matching colors. |
| `variants` | array[object] | **Optional**. List of color variants. |

#### Variant Object Structure
| Field | Type | Description |
| :--- | :--- | :--- |
| `color` | string | Name of the color (e.g., "Red", "Sky Blue"). |
| `quantity` | number | Stock level for this specific color. |
| `images` | array[string] | *Optional*. If empty, backend matches from global `images` using the `color` name. |

---

### Example JSON Payloads

#### 1. Creating Multiple Variants with Auto-Image Matching
If you upload multiple images to the `/upload` API first, you can send them all in the `images` array. The backend will look for the color name inside the image URL.

```json
{
  "name": "Summer Polo",
  "description": "Breathable cotton polo for summer.",
  "price": 450,
  "categoryId": "cat_01",
  "images": [
    "https://storage.com/img_red_01.jpg",
    "https://storage.com/img_red_02.jpg",
    "https://storage.com/img_yellow_01.jpg",
    "https://storage.com/img_blue.jpg"
  ],
  "variants": [
    { "color": "Red", "quantity": 15 },
    { "color": "Yellow", "quantity": 10 },
    { "color": "Blue", "quantity": 8 }
  ]
}
```
*Note: The "Red" variant will automatically get the two images containing "red" in their name.*

#### 2. Creating a Single Product (No Variants)
This still works exactly as before.

```json
{
  "name": "Classic Jeans",
  "description": "Blue denim jeans.",
  "price": 899,
  "categoryId": "cat_02",
  "color": "Blue",
  "quantity": 50,
  "images": ["https://storage.com/jeans.jpg"]
}
```

## Grouped Response Structure (GET /products)

The API now groups variants under a single parent product. The product list will only show "Parent" products, and each parent will have a `variants` array.

### Example Response
```json
{
  "id": "prod_parent123",
  "name": "Summer Polo",
  "description": "Breathable cotton polo for summer.",
  "variants": [
    {
      "id": "prod_parent123",
      "color": "Red",
      "images": [{"url": "..."}],
      "price": 450,
      "quantity": 15
    },
    {
      "id": "prod_child456",
      "color": "Yellow",
      "images": [{"url": "..."}],
      "price": 450,
      "quantity": 10
    }
  ]
}
```

---

### Pro-Tips for Frontend Developers (Flutter/Web)

1.  **Image Upload Strategy**: First call your `/api/v1/upload/images` endpoint to get the URLs. When naming files locally before upload, use names like `shirt_yellow.jpg` or `shirt_red.jpg` to take advantage of the auto-matching.
2.  **Display Logic**: The `GET /products` list now returns grouped data. Use the `variants` array to build color swatches.
3.  **Color Picker**: When a user selects a color, update the UI with the `images` and `id` from the corresponding variant object.
