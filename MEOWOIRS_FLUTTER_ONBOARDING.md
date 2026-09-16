# Meowoirs Flutter Onboarding Implementation & Parity (Phase 6)

## Overview

The Meowoirs Flutter onboarding flow is a strict, faithful implementation of the immutable Kotlin V0.1 onboarding specification (`OnboardingScreen.kt` and `strings.xml`). It guides the user through the philosophy, journaling aesthetic, cat relationship models, and offline privacy boundaries of the product before allowing entry into the main application.

---

## 1. 4-Page Editorial Structure

| Page | Title & Theme | Key Elements |
|---|---|---|
| **Page 1** | **CİLT I — BÖLÜM 01**<br>*Opening & Philosophy* | • Top Chapter: `CİLT I — BÖLÜM 01`<br>• Window cat photograph with `GÜNÜN IŞIĞI` badge<br>• Quote overlay: `«Sessiz bir fısıltı gibi...»`<br>• Introductory tag: `GİRİŞ NOTU` • `AÇILIŞ`<br>• Headline: `Her kedinin bir hikâyesi var.`<br>• Description: `Meowoirs, kedilerinle paylaştığın küçük anları, fotoğrafları ve hikâyeleri saklamak için kişisel alanın.`<br>• Feature Card: `Kişisel Arşivinizi Oluşturun`<br>• Footer: `MEOWOIRS ARŞİVİ • İLK SAYFA` |
| **Page 2** | **BÖLÜM II — GÜNLÜK PARÇALARI**<br>*Journal Fragments* | • Top Chapter: `BÖLÜM II — GÜNLÜK PARÇALARI`<br>• Title: `Küçük anları sakla.`<br>• Subtitle: `Bir fotoğraf, birkaç kelime ve o anın duygusu.`<br>• Card Badges: `ANNO. 128` (sage pulsing dot) & `08:45 Sabah Uykusu`<br>• Date badge: `14 Ekim` with mood tag `Huzurlu`<br>• Quote: `«Koltukta kıvrılmış, güneşin sıcaklığıyla uykuya dalmıştı...»`<br>• Editorial Card: `Meowoirs, sıradan anları unutmak istemeyeceğin küçük hikâyelere dönüştürür.`<br>• Footer: `KİŞİSEL ARŞİV • KÜÇÜK ANLAR` |
| **Page 3** | **BÖLÜM III — HİKÂYENDEKİLER**<br>*Dual Cat Profiles* | • Top Chapter: `BÖLÜM III — HİKÂYENDEKİLER`<br>• Title: `Her kedi hikâyende yer alabilir.`<br>• Subtitle: `Evindeki kediden sokakta karşılaştığın bir dosta kadar, hayatına dokunan küçük anları sakla.`<br>• Overlapping Photographic Cards:<br>  - Card 1: `EVDE` badge & `Evimizin Hikâyesi`<br>  - Card 2: `SOKAK HİKÂYESİ` badge & `Sokağın Ruhu` / `Zeytin — Mahalledeki eski dost`<br>• Feature Card: `Evde veya Sokakta` (`Evindeki ya da sokakta karşılaştığın kedileri kendi hikâyene dahil et.`)<br>• Footer: `MEOWOIRS ARŞİVİ • HER KEDİ` |
| **Page 4** | **BÖLÜM IV • MAHREMİYET & GÜVEN**<br>*Privacy, Terms & Legal Gate* | • Top Chapter: `BÖLÜM IV • MAHREMİYET & GÜVEN`<br>• Brand Shield & Lock Illustration<br>• Title: `Hikâyen senin.`<br>• Offline Guarantee: `Anıların ve fotoğrafların cihazında kalır. Meowoirs, bunları kendi sunucularında saklamaz ve hesap veya bulut senkronizasyonu gerektirmez.`<br>• Feature Card: `Cihazında Kalır` (`Kedi profillerin, fotoğrafların, notların ve anıların cihazında yerel olarak saklanır.`)<br>• Checkbox 1: `Gizlilik Politikası'nı okudum ve kabul ediyorum.`<br>• Checkbox 2: `Kullanım Koşulları'nı okudum ve kabul ediyorum.`<br>• CTA: `Meowoirs'e Başla →`<br>• Footer: `MEOWOIRS • KİŞİSEL ARŞİV` |

---

## 2. Navigation, Skip & Back Behavior

1. **Forward & Sequential Navigation**:
   - Tapping the bottom CTA button (`Devam Et →`) on Pages 1–3 advances to the next step.
   - Smooth `AnimatedSwitcher` with subtle slide and fade transitions (300ms, `Curves.fastOutSlowIn`).
2. **Skip ("ATLA")**:
   - Header shows `ATLA` text button on Pages 1–3 only.
   - Tapping `ATLA` navigates directly to Page 4 (Legal Gate).
   - On Page 4, `ATLA` is omitted (`showSkip: uiState.currentStep < 4`).
3. **Android System Back Navigation**:
   - Governed by `PopScope(canPop: uiState.currentStep == 1)`.
   - On Pages 2–4, pressing the system back button retreats to the previous onboarding step (`currentStep - 1`).
   - Android back can **never** bypass the legal gate and cannot transition to Home without legal acceptance.

---

## 3. Legal Gating & Offline Document Viewer

- **Interactive Checkboxes**:
  - Checkbox 1 (Privacy Policy) and Checkbox 2 (Terms of Service) both initialize to `false`.
  - Both checkboxes must be explicitly checked (`canStart = privacyAccepted && termsAccepted`).
  - CTA Button `Meowoirs'e Başla →` remains disabled (`onPressed: null`) until both are checked.
- **Native Legal Document Viewer**:
  - Tapping the inline link keywords (`Gizlilik Politikası` or `Kullanım Koşulları`) opens `LegalDocumentViewerDialog.show(context, document)`.
  - Content is rendered from local bundled assets (`assets/legal/privacy_policy.txt` and `assets/legal/terms_of_service.txt`).
  - Completely self-contained; does not load external WebViews or send telemetry.

---

## 4. Persistence & First Launch Handling

- When the user taps `Meowoirs'e Başla →`:
  1. `PreferencesRepository.completeOnboarding(AppConfig.currentLegalVersion)` is invoked.
  2. Sets `onboarding_completed = true` in `SharedPreferences`.
  3. Sets `accepted_legal_version = "1"` in `SharedPreferences`.
  4. State notifier marks `isCompleted = true`, triggering callback `onOnboardingFinished()`, routing user to `/` (Home).
- On application restart:
  - `routerProvider` checks `prefs.isOnboardingCompleted()`.
  - If `true`, the onboarding route `/onboarding` is bypassed entirely, opening the home shell directly.

---

## 5. Design System Tokens & Assets

- **Colors Normalized**:
  - Cream Background: `#FFF9F2` (`kCream`)
  - Orange Primary: `#E8753D` (`kOrangePrimary`)
  - Sage Green: `#79A88B` (`kSage`)
  - Lavender Accent: `#A99BCB` (`kLavender`)
  - Dark Brown Text/Icons: `#594A42` (`kDarkBrown`)
- **Typography**: Plus Jakarta Sans via `MeowoirsTypography` with graceful fallback to system sans-serif and serif styles for quotes and editorial titles.
- **Assets Preserved**:
  - Header logo: `assets/images/onboarding_logo.png`
  - Page 1 hero: `assets/onboarding/onboarding_step1_hero.png`
  - Page 2 hero: `assets/onboarding/onboarding_step2_hero.png`
  - Page 3 home card: `assets/onboarding/onboarding_step3_home.png`
  - Page 3 street card: `assets/onboarding/onboarding_step3_street.png`

---

## 6. Localization Across 10 Languages

Strings are bound dynamically through `AppLocalizations.of(context)` with full support for:
1. `tr` (Turkish - Default/Primary)
2. `en` (English - Fallback)
3. `de` (German)
4. `fr` (French)
5. `es` (Spanish)
6. `it` (Italian)
7. `pt` (Portuguese)
8. `nl` (Dutch)
9. `pl` (Polish)
10. `ja` (Japanese)

Language selector dropdown in `OnboardingHeader` enables immediate language switching and persistence without restarting the onboarding process.

---

## 7. Privacy & Ad Boundary

- **No Personal Data Collected**:
  - No user name, nickname, cat profile creation, contact sync, GPS/location, or photos requested during onboarding.
- **No Ads**:
  - No `BannerAd`, `InterstitialAd`, or preloading ad units are triggered or visible on `/onboarding`.
- **Crashlytics Boundary**:
  - No legal acceptance contents or onboarding user actions are transmitted to Crashlytics.
