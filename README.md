# ListeniQur'an

Technical Test for Mobile App Developer (Jakarta Site) – Transcosmos Indonesia

## Overview

ListeniQur'an is a Flutter-based mobile application that allows users to browse and listen to Quran recitations using the public Quran API provided by AlQuran Cloud.

This project was developed as part of the technical assessment process for the Mobile App Developer position at Transcosmos Indonesia.

API Source:
https://alquran.cloud

Repository:
https://github.com/rivandasyah/ListeniQur-an

---

## Features

### Search Surah

* Search Surah by name
* Real-time filtering
* Local search implementation

### Juz Navigation

* Quick access to Juz 1–30
* Simplified navigation experience

### Audio Playback

* Play audio recitation
* Pause audio playback
* Resume audio playback

### Progress Display

* Display current playback position
* Display current ayah duration
* Interactive progress slider

### Seeking

* Navigate within the currently playing ayah using the slider
* Skip forward 5 seconds
* Skip backward 5 seconds

---

## State Management

This project uses **GetX** for:

* State Management
* Dependency Injection
* Route Management

Reasons for using GetX:

* Lightweight
* Simple architecture
* High maintainability
* Fast development workflow

---

## Project Structure

```text
lib/
└── app/
    ├── models/
    ├── modules/
    │   ├── splash/
    │   ├── home/
    │   └── player/
    │
    ├── network/
    ├── routes/
    ├── theme/
    └── widgets/
```


### Architecture Overview

* **Models**: Data models used for API response mapping.
* **Modules**: Feature-based modules containing screens, controllers, and bindings.
* **Network**: API communication layer using Dio.
* **Routes**: Centralized route management using GetX.
* **Theme**: Application design system including colors, typography, spacing, and styling.
* **Widgets**: Reusable UI components shared across the application.
---

## Libraries Used

| Package       | Purpose                                            |
| ------------- | -------------------------------------------------- |
| get           | State management, navigation, dependency injection |
| dio           | HTTP client for API communication                  |
| just_audio    | Audio playback                                     |
| audio_session | Audio session handling                             |
| flutter_svg   | SVG asset support                                  |

The implementation prioritizes custom business logic while using external libraries only when necessary.

---

## User Interface

The application follows a modern and minimalist design approach inspired by iOS design principles.

Design characteristics:

* Clean layout
* Modern blue color palette
* Minimal visual distractions
* Large touch targets
* Consistent spacing and typography
* Focus on readability and usability

---

## Screenshots

### Splash Screen

(Add Screenshot Here)

### Home Screen

(Add Screenshot Here)

### Player Screen

(Add Screenshot Here)

---

## How to Run

1. Clone the repository

```bash
git clone https://github.com/rivandasyah/ListeniQur-an.git
```

2. Install dependencies

```bash
flutter pub get
```

3. Run the application

```bash
flutter run
```

---

## Notes

The Quran API provides audio in a verse-by-verse format. Therefore, playback is implemented as sequential ayah playback while maintaining a continuous listening experience for users.

---
