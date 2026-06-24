# WeatherCast 🌤️

WeatherCast is a beautifully designed, immersive weather app built completely in SwiftUI. Providing accurate, up-to-date weather forecasts, it leverages stunning glassmorphic UI elements and dynamic backgrounds to bring the forecast to life directly on your device.

## 🎨 UI/UX & Design Concept
WeatherCast is crafted with a focus on premium visual excellence. The user experience is built around a modern glassmorphic design system, dynamic gradients, and gorgeous custom 3D weather icons that dynamically adapt based on the time of day and conditions.

> **[Placeholder: Insert UI Mockups, Screenshots, or App Posters here]**

## ✨ Key Features
- **Real-time Weather:** Accurate current conditions, temperature, high/low, and feels-like data.
- **Detailed Forecasts:** Navigate seamlessly through hourly and 7-day weekly forecasts in an intuitive bottom sheet layout.
- **Comprehensive Data Widgets:** In-depth weather metrics including Air Quality Index (AQI), Sunrise/Sunset, UV Index, Wind Speed & Direction, Rainfall, Humidity, Visibility, and Atmospheric Pressure.
- **Current Location Support:** Automatic, on-demand weather fetching for your device's current location via GPS.
- **Location Management:** Search for cities globally (optimized with request debouncing) and save your favorites.
- **Dynamic Theming:** Background visuals and typography intelligently adapt depending on whether it is day or night in the selected city.

## 🛠 Tech Stack & Tools
- **Language:** Swift 5.9+
- **UI Toolkit:** SwiftUI
- **State Management:** Observation Framework (`@Observable`)
- **Local Persistence:** SwiftData
- **Location Services:** CoreLocation
- **Networking:** Native `URLSession` with `async/await` concurrency
- **External API:** [WeatherAPI](https://www.weatherapi.com)

## 🏗 Architecture & Design Patterns
WeatherCast follows a clean **MVVM (Model-View-ViewModel)** architectural pattern to ensure scalability and maintainability:
- **Models:** Codable structs defining the data structure matching the WeatherAPI JSON responses, alongside `@Model` classes for local persistence.
- **ViewModels:** Encapsulate business logic, network requests, and manage application state using the modern `@Observable` macro.
- **Views:** Declarative, modular SwiftUI views that automatically react to state changes in the ViewModels.
- **Data Persistence:** User's saved locations are persisted locally using Apple's modern **SwiftData** framework, ensuring seamless data retrieval and offline capability for favorite cities.

## 🔒 Environment Setup (Security)
To protect sensitive credentials, API keys are kept out of source control. Before running the app, you must set up your local environment:
1. Locate the `WeatherCast App/Utils/Secrets-Template.swift` file.
2. Duplicate this file and rename the copy to `Secrets.swift`.
3. Open `Secrets.swift` and replace `"YOUR_API_KEY_HERE"` with your actual API key from [WeatherAPI](https://www.weatherapi.com).
4. *Note: Ensure `Secrets.swift` is added to your Xcode target if prompted. It is already ignored by `.gitignore` so your key will remain safe.*

## 🚀 Installation & Running

1. **Clone the repository:**
   ```bash
   git clone https://github.com/albaraasayed/WeatherApp-SwiftUI.git
   ```
2. **Open the project:**
   Open the `WeatherCast App.xcodeproj` file in **Xcode 15** or later.
3. **Set Up API Key:**
   Follow the **Environment Setup** instructions above to create your `Secrets.swift` file.
4. **Build and Run:**
   Select your preferred iOS Simulator or physical device and hit `Cmd + R` to run the application.

## 📂 Project Structure
```text
WeatherCast App/
├── Model/               # Data structures and SwiftData (@Model) definitions
├── Module/
│   ├── ViewModels/      # Business logic, state management, and API orchestration
│   └── Views/
│       ├── Screens/     # Main full-screen views (Home Weather, Saved Locations)
│       ├── Components/  # Reusable UI elements (Cards, Lists, Bottom Sheets)
│       └── Widgets/     # Specialized weather metric widgets (AQI, Wind, UV, etc.)
├── Networking/          # API services handling search and forecast data requests
├── Utils/               # Helpers, Color Extensions, Gradients, and Icon Mappers (and Secrets)
└── Assets.xcassets/     # Custom 3D icons, dynamic backgrounds, and colors
```

## 🤝 Credits & Acknowledgements
- **Contributors:** [Placeholder for contributors or team members]
- **Design Inspiration:** [Placeholder for design inspiration or UI/UX creator credits]
- **API:** Powered by [WeatherAPI.com](https://www.weatherapi.com)
