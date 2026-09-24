# App Store Connect checklist — version 1.0.0, build 4

Files referenced below are in `screenshots/`.

## 1. TestFlight (test before resubmitting)

- [ ] Wait for build **1.0.0 (4)** to finish processing (email from Apple, or TestFlight → iOS Builds shows it).
- [ ] If it shows **Missing Compliance**: answer "None of the algorithms mentioned above". (It shouldn't; the build declares no encryption.)
- [ ] TestFlight → build 4 → **What to Test**: paste `app-store-text/testflight-what-to-test.txt`.
- [ ] Make sure the **Private** group has build 4, then install it from the TestFlight app on your iPhone.
- [ ] Test: haptics with Full Access on, the space above the numbers row in Safari and other apps, the comma under Z, symbol pages, long-presses.

## 2. Screen recording for App Review (on your iPhone, with build 4)

- [ ] Start a screen recording from Control Center.
- [ ] Launch Simple Keyboard from the home screen (the recording must start with the launch).
- [ ] Tap **Open Settings** → General → Keyboard → Keyboards → Add New Keyboard → Simple Keyboard (or show it already added).
- [ ] Tap Simple Keyboard → show the **Allow Full Access** switch, and mention (or show) it is optional.
- [ ] Back in the app: tap the field, hold 🌐, choose Simple Keyboard.
- [ ] Type a sentence with the numbers row, comma and period.
- [ ] Tap 123 → 1/2 → ABC.
- [ ] Long-press C → č, long-press the period → !.
- [ ] Open Messages or Notes and type a few words.
- [ ] Stop the recording.

## 3. Version page (Distribution → iOS App Version 1.0.0)

- [ ] **Previews and Screenshots → iPhone 6.5"**: Delete All, then upload in this order:
  1. `app-store-6.5/01-letters.png`
  2. `app-store-6.5/02-long-press-letters.png`
  3. `app-store-6.5/03-symbols.png`
  4. `app-store-6.5/04-more-symbols.png`
  5. `app-store-6.5/05-long-press-period.png`
  - App preview: replace with `app-preview/app-preview-886x1920.mp4`; pick a poster frame around 6 s (period popup open).
- [ ] **Promotional Text**: unchanged (`app-store-text/promotional-text.txt`).
- [ ] **Description**: replace with `app-store-text/description.txt` (the privacy paragraph and setup steps now mention optional Full Access).
- [ ] **Keywords** / **Subtitle**: unchanged.
- [ ] **Support URL**: `https://github.com/milosozegovic/simple-ios-keyboard/issues`
- [ ] **Build**: remove build 2 and add **1.0.0 (4)**.
- [ ] **App Review Information → Notes**: replace with `app-store-text/review-notes.txt`. "Sign-in required": off.
- [ ] Save.

## 4. App settings (left sidebar)

- [ ] **App Privacy**: still "Data Not Collected". Full Access doesn't change this; the keyboard collects and sends nothing.
- [ ] **App Information → Privacy Policy URL**: `https://milosozegovic.com/simple-ios-keyboard/privacy.html` (already updated for Full Access).

## 5. Reply and resubmit

- [ ] Distribution → App Review → the rejected submission → **Reply to App Review**.
- [ ] Paste `app-store-text/app-review-reply.txt` and attach the screen recording.
- [ ] Send, then click **Update Review** / **Resubmit to App Review** on the version page.
