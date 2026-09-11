# Product Catalog — Neurogine Technical Assessment

A Flutter product catalog application built as part of the Neurogine Junior Mobile Developer technical assessment.

The application uses the DummyJSON API to display products, support pagination and search, and show product details.

## Features

* Display the first 20 products
* Infinite scroll pagination
* Product title, thumbnail and price
* Product detail popup
* Product description, price, rating and images
* Loading states
* Error states with retry
* Empty search result state
* Debounced product search
* Immediate search when pressing Enter
* Pull-to-refresh
* Scroll-to-top / scroll-to-bottom floating action button
* Product image display using network images

## Tech Stack

* **Flutter**
* **Dart**
* **Android Studio**
* **HTTP package** for API requests
* **DummyJSON REST API**
* **ChangeNotifier** for controller state management

## API

The application uses the following DummyJSON endpoints:

### Product list

```text
GET https://dummyjson.com/products?limit=20&skip=0
```

Pagination is implemented by changing the `skip` value:

```text
skip=0
skip=20
skip=40
...
```

### Product detail

```text
GET https://dummyjson.com/products/{id}
```

### Product search

```text
GET https://dummyjson.com/products/search?q={query}
```

## Architecture

The application uses a simple layered architecture:

```text
View
  ↓
Controller
  ↓
API Service
  ↓
DummyJSON API
```

### View

The View is responsible for displaying the user interface and handling user interactions.

Main UI files:

```text
lib/views/
├── products_page.dart
├── product_detail_page.dart
└── widgets/
    └── product_card.dart
```

`ProductsPage` displays the product list, search field, pagination loading state, refresh functionality and scroll action button.

`ProductDetailPage` displays the selected product details.

`ProductCard` is a reusable widget for displaying a product in the list.

### Controller

The controller manages application state and coordinates communication between the View and API Service.

```text
lib/controllers/
└── product_controller.dart
```

`ProductController` handles:

* Initial product loading
* Pagination
* Search
* Product detail loading
* Loading states
* Error states
* Refreshing the product list

`ChangeNotifier` and `notifyListeners()` are used to notify the UI when the state changes.

### API Service

```text
lib/data/service/
└── product_api.dart
```

The API service is responsible for communicating with DummyJSON.

Keeping API requests in a separate service prevents the UI from directly handling HTTP requests and keeps the responsibilities separated.

### Model

```text
lib/data/models/
└── product.dart
```

The `Product` model represents the product data returned by the API and converts JSON responses into Dart objects.

## Search Behaviour

The search field uses a 500 ms debounce.

When the user stops typing for approximately 500 ms, the search request is sent.

Pressing Enter performs the search immediately without waiting for the debounce timer.

If the search field is cleared, the application returns to the normal product list.

## Pagination

The application initially loads 20 products.

When the user approaches the bottom of the list, the controller requests the next 20 products and appends them to the existing list.

A separate loading indicator is displayed at the bottom while the next page is being loaded.

## Product Details

When a product is selected, the application requests the full product information using its product ID.

The detail interface is displayed as a popup dialog with:

* Product title
* Product images
* Full description
* Price
* Rating

A loading indicator is shown while the detail request is in progress, and an error message with a retry action is shown if the request fails.

## Pull-to-Refresh

The product list supports pull-to-refresh.

Refreshing resets the pagination state and requests the first page of products again.

## Scroll Action Button

A floating action button changes according to the current scroll position.

* Near the top: `↓` scrolls to the bottom.
* After scrolling down: `↑` scrolls back to the top.

The scrolling uses an animation rather than an immediate jump.

## How to Run

### Requirements

Make sure Flutter and Android Studio are installed and configured.

Check the Flutter installation with:

```bash
flutter doctor
```

## Project Structure

```text
lib/
├── controllers/
│   └── product_controller.dart
│
├── data/
│   ├── models/
│   │   └── product.dart
│   └── service/
│       └── product_api.dart
│
├── views/
│   ├── products_page.dart
│   ├── product_detail_page.dart
│   └── widgets/
│       └── product_card.dart
│
└── main.dart
```

## AI Assistance

AI assistance was used during development as a learning and development aid.

I used AI for step-by-step guidance, explanations of Flutter concepts, suggestions for implementation approaches, and code examples for parts of the application.

The AI assistance included guidance related to:

* Flutter project structure
* Model and JSON parsing
* HTTP API integration
* `ChangeNotifier` state management
* Pagination
* Debounced search
* Dialog-based product details
* Pull-to-refresh
* Scroll position handling
* Error and loading states

I reviewed, tested and integrated the implementation in my project and used the development process to understand how each part works.

I understand that I am responsible for the final code and must be able to explain the implementation and architectural decisions during the walkthrough.

## Incomplete / Not Implemented

The following items were not implemented:

* Unit tests were not included.
* Dedicated image loading/error placeholder handling was not implemented.

These were considered optional improvements rather than core functionality for the assessment.

## Development Approach

The application was developed incrementally, with features added and committed separately.

The main development stages were:

1. Flutter project setup
2. Product model
3. DummyJSON API service
4. Product controller
5. Product card UI
6. Pagination
7. Pagination loading indicator
8. Product detail popup
9. Product detail loading/error handling
10. Debounced search
11. Pull-to-refresh
12. Scroll position action button

The goal was to keep the implementation simple while separating UI, application state and API responsibilities.
