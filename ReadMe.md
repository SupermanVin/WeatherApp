---

# 📄 README – WeatherNow 🌦️

## 1. Project Title & Overview

A modular iOS Weather App built with Clean Architecture and SwiftUI, following best practices in design system and code organization.
Displays current weather and multi-day forecasts for the user’s location or searched cities.

---

## 2. ✨ Features

* 🌍 Current weather based on user location
* 🔍 Search for weather by city
* 📊 Multi-day forecast display
* 📱 Reusable Design System components
* 🎨 Centralized theme (colors, typography, spacing)
* ⚠️ Error states and offline handling

---

## 3. 🏗️ Architecture

The project follows **Clean Architecture + MVVM**, organized into distinct layers:

* **Presentation** → SwiftUI Views, ViewModels
* **Domain** → Entities, Use Cases, Repository protocols
* **Data** → DTOs, Network Manager, Repository implementations
* **Core** → Resources (Assets, Colors, Typography, Spacing, Constants)
* **App Layer** → `@main` entry point, AppDelegate, Info.plist
* **DesignSystem** → Shared reusable UI components (WeatherCard, Tag, ForecastPill, etc.)

This ensures scalability, testability, and maintainability.

---

## 4. 📂 Folder Structure

```
WeatherNow/
│
├── App/                        # Application entry point
│   ├── WeatherNowApp.swift      # @main entry file
│   └── Info.plist               # App configuration file
│
├── Core/                        # Shared resources & utilities
│   ├── Resources/               # Assets, constants, configurations
│   │   └── Assets.xcassets
│   └── Extensions/              # Global Swift/SwiftUI extensions
│       ├── String+Extensions.swift
│       ├── Date+Extensions.swift
│       ├── Color+Extensions.swift
│       └── View+Extensions.swift
│
├── Presentation/
│   └── DesignSystem/            # Reusable UI system
│       ├── Components/          # Shared UI components (WeatherCard, Tag, etc.)
│       └── Tokens/              # Theme tokens (Colors, Typography, Spacing, Shadows)
│
├── Features/
│   └── Weather/                 # Weather feature module
│       ├── Data/                # Data layer
│       │   ├── DTOs/            # API DTOs (decoding JSON)
│       │   ├── Network/         # API client (WeatherManager, Endpoints)
│       │   └── Repositories/    # Repository implementations
│       │
│       ├── Domain/              # Domain layer
│       │   ├── Entities/        # Business entities
│       │   ├── UseCases/        # Interactors (business rules)
│       │   └── Repositories/    # Repository protocols (abstractions)
│       │
│       └── Presentation/        # Presentation layer (MVVM)
│           ├── ViewModels/      # SwiftUI ViewModels
│           └── Views/           # SwiftUI Views (Screens)
│
├── Infrastructure/              # System services
│   └── Location/                # Location service implementation
│       └── LocationManager.swift
│
├── Docs/                        # Documentation & screenshots
│   └── Screenshots/
│       └── HomeScreen.png
│
└── Tests/                       # Unit tests & UI tests
```

---

## 5. ⚙️ Technical Details

* Language: Swift 5.9
* Framework: SwiftUI
* Architecture: Clean Architecture + MVVM
* Minimum iOS: 15.0
* Xcode: 16+
* No third-party dependencies (only native frameworks)
* Dependency Injection used for testability
* Unit Tests included for key components

---

## 6. 🌐 API Usage

* Weather data is fetched from [OpenWeatherMap](https://openweathermap.org/api).
* API key is **not hardcoded** in the codebase.
* API key is securely handled via **Cloudflare Worker**, acting as a proxy between the app and OpenWeatherMap API.
* This ensures the real API key is never exposed inside the client app (since even storing in Keychain, Info.plist, or `.xcconfig` can be reverse engineered).
* Client communicates with Cloudflare endpoint → Cloudflare securely appends the API key → OpenWeather API.

---

## 7. 🚀 Setup Instructions
1. Clone this repo.
2. Open `WeatherNow.xcodeproj` in Xcode.
3. Add your OpenWeatherMap API Key in `Configurations/debug.xcconfig`:

   ```sh
   WEATHER_API_KEY = your_api_key_here
   ```
4. Build & Run (iOS 15+)
---

## 8. 📝 Notes

* Code follows SOLID principles and clean coding practices.
* All assets are centralized in `Core/Resources`.
* `Info.plist` configured in App layer.
* No third-party dependencies used.
* Weather API key secured via Cloudflare Worker proxy.
* Tested properly on a **real device** to verify functionality.

⚠️ **Important Simulator Bug Notice**  
- Cloudflare returns weather data over **HTTP/3 (QUIC)**.  
- Due to an **iOS 18.4 simulator bug** ([Expo issue #36136](https://github.com/expo/expo/issues/36136), [Apple Technote TN3102](https://developer.apple.com/documentation/technotes/tn3102-http3-in-your-app)), HTTP/3 responses may not work in **iOS 18.4 simulator**.  
- ✅ Please test on **iOS 18.2 simulator or a real device** where it works correctly.  
- For location-based weather, set a **Custom Location** in Simulator:  
  **Features → Location → Custom Location…**
---

## 9. 📸 Screenshots

![Home Screen](https://raw.githubusercontent.com/SupermanVin/WeatherApp/main/WeatherNow/Docs/Screenshots/HomeScreen.jpeg)




