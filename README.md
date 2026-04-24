# Book Shop

Book Shop is a Flutter bookstore app prototype with a polished shopping flow, mock authentication, and state management powered by Riverpod. It showcases a complete browsing-to-checkout experience for a modern mobile bookstore UI.

## Features

- Splash screen with session restore flow
- Mock sign in and sign up with persisted local session
- Browse a curated catalog of books with featured selections
- Search by title, author, genre, and rating-based suggestions
- Filter by category and minimum rating
- Sort by relevance, popularity, newest, rating, and price
- View detailed book pages with stock, description, rating, and pricing
- Save books to wishlist
- Add books to cart and adjust quantities
- Checkout with saved address and payment method selection
- Order success flow with mock order history updates
- Account screen with wishlist, order history, saved addresses, and app preferences
- Light and dark theme support

## Tech Stack

- Flutter
- Dart
- Riverpod for state management
- Shared Preferences for local persistence
- Dio for API-ready networking
- Google Fonts and HugeIcons for UI styling

## Current Data Model

The app currently runs primarily on local mock data and in-memory state for the storefront experience:

- Authentication is mocked and stored locally using Shared Preferences
- Book catalog data is defined in Riverpod providers
- Wishlist, cart, and order history are managed in app state
- A `BooksApiService` is included for future backend integration

## Project Structure

```text
lib/
  app/
    providers/
    theme/
  core/
    constants/
    errors/
    widgets/
  features/
    account/
    auth/
    books/
    checkout/
    shell/
    splash/
```

## Main User Flow

1. App launches into a splash screen
2. Existing local session is restored if available
3. User signs in or creates a mock account
4. User browses, searches, filters, and sorts books
5. User opens book details, saves favorites, or adds books to cart
6. User proceeds through checkout and places an order
7. Order appears in account history

## Getting Started

### Prerequisites

- Flutter SDK installed
- Dart SDK included with Flutter
- Android Studio, VS Code, or another Flutter-compatible IDE

### Run the App

```bash
flutter pub get
flutter run
```

## Build Targets

This Flutter project includes platform folders for:

- Android
- iOS
- Web
- Windows
- macOS
- Linux

## Assets

Screenshots are stored in the `assets/` directory.
## Notes

- This project is a UI-rich bookstore prototype, not a production-connected commerce app
- Payment, addresses, and order placement are simulated inside the app
- The networking layer is prepared for future API integration, but the current browsing experience uses mock catalog data

## Future Improvements

- Connect the catalog, auth, cart, and orders to a real backend
- Add pagination and remote search
- Add product reviews and ratings submission
- Add localization and full Arabic support
- Add state persistence for cart, wishlist, and order history
- Add automated widget and integration tests

## License

This project is private and not published to `pub.dev`.
