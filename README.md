# RemoteConfigDemo

A sample iOS app demonstrating how to use **Firebase Remote Config** to control when and how a user is prompted to rate your app. The demo uses SwiftUI overlays for rating and feedback forms, alongside a UIKit-based app structure.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [How It Works](#how-it-works)
  - [Remote Config Setup](#remote-config-setup)
  - [Review Prompt Logic](#review-prompt-logic)
  - [Feedback Flow](#feedback-flow)
- [Testing the Prompt](#testing-the-prompt)
- [Customization](#customization)
- [License](#license)

---

## Overview

This project showcases an in-app rating and feedback flow that is conditionally triggered based on values fetched from **Firebase Remote Config**. The app:

1. Tracks how many times the user has opened the app.
2. Fetches remote configuration to see if the review prompt is enabled and what the minimum number of sessions should be before showing it.
3. If conditions are met, displays a SwiftUI-based prompt that asks the user to rate the app.  
   - If the user rates it **4 stars or higher**, the system’s native review prompt (`SKStoreReviewController`) is requested.
   - If the user rates it **3 stars or lower**, a feedback form is shown instead.

---

## Features

- **Firebase Remote Config** integration:
  - Dynamically enable or disable the review prompt (`enable_review_prompt`).
  - Configure the minimum number of sessions needed (`min_sessions_before_review`).
- **Session Tracking** via `UserDefaults`:
  - Increments a session count every time the app is launched.
- **Conditional Review Prompt**:
  - Uses `SKStoreReviewController.requestReview(in:)`.
- **SwiftUI Overlays** for rating and feedback:
  - `RatingPromptView` for star-based rating.
  - `FeedBackView` for user input.
  - `FeedbackSentView` for confirmation.
- **Firebase Analytics** event logging:
  - Logs a custom event when the review prompt is shown.

---

## Project Structure

```
RemoteConfigDemo
│
├── AppDelegate.swift
│   └── Configures Firebase, sets default Remote Config values,
│       fetches/activates them, and tracks session count.
│
├── SceneDelegate.swift (if using the SceneDelegate lifecycle)
│
├── ViewController.swift
│   └── Basic UIKit view controller that checks session count
│       and presents the rating prompt if the count is high enough.
│
├── ReviewManager.swift
│   └── Singleton that handles the logic of whether to show the
│       rating prompt based on Remote Config and session count.
│
├── AppReviewHostingController.swift
│   └── Wraps SwiftUI views (RatingPromptView) inside a UIKit view controller.
│
├── SwiftUI Views
│   ├── RatingPromptView.swift
│   │   └── Main star rating prompt. If the user rates >= 4, requests review;
│   │       otherwise shows a feedback form.
│   ├── FeedBackView.swift
│   │   └── Allows the user to provide additional feedback if they rate low.
│   ├── FeedbackSentView.swift
│   │   └── Displays a success or failure message after feedback submission.
│
└── Other files (e.g., Info.plist, GoogleService-Info.plist, etc.)
```

---

## Prerequisites

1. **Xcode 14+**  
2. **iOS 14+** (or higher)
3. A **Firebase** project with the following setup:
   - **Firebase Remote Config** enabled.
   - **GoogleService-Info.plist** file added to your app target.
4. **Swift Package Manager** or **CocoaPods** for installing Firebase dependencies.  
   *(This example uses `import Firebase` directly, so ensure Firebase is added to your project’s dependencies.)*

---

## Getting Started

1. **Clone or download** this repository.
2. **Add your `GoogleService-Info.plist`** file to the project:
   - Make sure it’s included in the app’s build target.
3. **Install Firebase** dependencies if you haven’t:
   - **Swift Package Manager**: Add `https://github.com/firebase/firebase-ios-sdk.git` to your project.
   - **CocoaPods**: Add `pod 'Firebase/Core'` and `pod 'Firebase/RemoteConfig'` to your Podfile, then run `pod install`.
4. **Open** `RemoteConfigDemo.xcodeproj` (or `.xcworkspace` if using CocoaPods).
5. **Run** the app on a simulator or device.

---

## How It Works

### Remote Config Setup

In **Firebase Console** under **Remote Config**:

1. Create a parameter named `enable_review_prompt` (Boolean).
2. Create a parameter named `min_sessions_before_review` (Number).
3. Set default values (e.g., `false` for `enable_review_prompt`, `5` for `min_sessions_before_review`).
4. Optionally create conditions to change these values based on user properties or other criteria.

Example in the code:
```swift
let defaults: [String: NSObject] = [
  "enable_review_prompt": false as NSNumber,
  "min_sessions_before_review": 5 as NSNumber
]
remoteConfig.setDefaults(defaults)
```

### Review Prompt Logic

- **`ReviewManager`** checks:
  1. Whether `enable_review_prompt` is `true`.
  2. Whether the user’s session count >= `min_sessions_before_review`.
  3. How many days have passed since the last review request (to avoid spamming users).
- If conditions are met, it calls `requestReview()`, which:
  - Uses `SKStoreReviewController.requestReview(in: scene)` for iOS 14+.

### Feedback Flow

- **`RatingPromptView`**:
  - Shows 5 stars. If user taps **4 or 5 stars**:
    - Immediately calls `requestReview()` (system prompt).
    - Dismisses the rating overlay.
  - If user taps **1, 2, or 3 stars**:
    - Displays `FeedBackView` for optional text feedback.
    - On submission, shows `FeedbackSentView` as a success/failure overlay.

---

## Testing the Prompt

1. **Adjust Defaults**  
   In `AppDelegate.swift` (or the Firebase Console), set:
   ```swift
   let defaults: [String: NSObject] = [
       "enable_review_prompt": true as NSNumber,
       "min_sessions_before_review": 1 as NSNumber
   ]
   ```
   This forces the prompt to appear almost immediately.
   
2. **Reset UserDefaults**  
   - Uncomment `UserDefaults.standard.removeObject(forKey: "last_review_request_date")` to clear the last request date.
   - This helps you test repeated prompts.
   
3. **Run the App**  
   - Each launch increments the session count.
   - Once session count meets or exceeds `min_sessions_before_review`, the prompt should appear.

> **Note**: The iOS system might not always show the review prompt, even if requested. Apple has built-in logic to limit the number of prompts per user per year.

---

## Customization

- **Prompt Delay**: Modify `minimumDaysBetweenRequests` in `ReviewManager` if you want a different interval.
- **UI Styling**: All SwiftUI overlays can be styled further. For example, change colors, corner radius, or images.
- **Feedback Handling**: Currently, the feedback text is only displayed locally. In a real-world scenario, you’d send it to a server or an email address.

---

## License

This project is provided under the [MIT License](LICENSE). Feel free to modify and integrate it into your own projects.
