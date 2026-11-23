# MEOWOIRS — CANONICAL LEGAL DOCUMENTATION PACKAGE

> **DOCUMENT NOTICE:**  
> This document package constitutes the canonical legal documentation for the Meowoirs Android application operated by LIMANEX.  
> Effective Date: September 7, 2026  
> Last Updated: September 7, 2026  
> Legal Version: 1.0  
> Application Package: `com.limanex.meowoirs`  
> Public Privacy Policy: `https://limanexstudio.com/privacy`  
> Public Terms of Service: `https://limanexstudio.com/terms`  
> Official Contact: `limanexsoftware@outlook.com`

---

## PART I — PRIVACY POLICY

# MEOWOIRS PRIVACY POLICY

**Effective Date:** September 7, 2026  
**Last Updated:** September 7, 2026  
**Legal Version:** 1.0

---

### 1. Introduction
Welcome to **Meowoirs** (the "Application"). Meowoirs is an offline-first personal digital companion and memory journal designed to help individuals record thoughts, stories, milestones, and daily interactions with their companion and community cats.

This Privacy Policy explains how information is handled within Meowoirs. Our core design principle is **privacy by design**: all personal journal entries, cat profiles, and notes remain stored locally on your Android device.

---

### 2. Operator Information
The Application is developed, published, and operated by:
- **Developer / Operator:** LIMANEX
- **Country:** Türkiye
- **Official Contact Email:** limanexsoftware@outlook.com
- **Official Website:** https://limanexstudio.com
- **Public Privacy Policy URL:** https://limanexstudio.com/privacy
- **Public Terms of Service URL:** https://limanexstudio.com/terms

---

### 3. Scope
This Privacy Policy applies to your installation, access, and use of the Meowoirs mobile software application for Android (`com.limanex.meowoirs`). It describes the local storage of user-created content and the handling of technical telemetry and advertising identifiers by integrated third-party SDKs.

---

### 4. Definitions
- **"Application"** or **"Meowoirs"**: The mobile software application for Android with package ID `com.limanex.meowoirs`.
- **"User"**, **"you"**, or **"your"**: Any individual downloading, installing, or interacting with Meowoirs.
- **"User Content"**: All cat profiles, names, memories, notes, emotional reflections, and photo references created or selected by the User.
- **"Device"**: The compatible Android smartphone, tablet, or portable hardware running Meowoirs.
- **"Third-Party SDKs"**: Google Mobile Ads (AdMob), Google User Messaging Platform (UMP), and Firebase Crashlytics.
- **"Advertising ID"**: The Google Advertising ID (GAID / AAID) provided by Android Google Play Services.

---

### 5. What Meowoirs Stores Locally
Meowoirs operates on a local-first architecture. All content you create in the journal is stored locally on your physical device in an internal SQLite database managed via AndroidX Room, and user preferences are maintained via Android Jetpack DataStore:
1. **Cat Profiles:** Cat name, pet classification (Home or Street), profile photo reference (local Content URI), optional profile note, and creation timestamp.
2. **Memories (Journal Entries):** Associated cat identifier, journal note text, attached photo reference (local Content URI), cat mood selection, user emotional reflection, and creation timestamp.
3. **Application Preferences:** User nickname, avatar choice, favorite cat selection, onboarding completion status, and UI theme preferences.

---

### 6. Cat Profiles & Deletion Behavior
You can create, edit, and delete cat profiles.
**Important Database Behavior:** When you delete a cat profile, the profile record is removed from the local database. However, in accordance with the current database architecture, associated memory entries are preserved to prevent accidental loss of user journal entries. If you wish to delete both a cat and its memories, the memories must be deleted individually.

---

### 7. Memories & Journal Entries
Memories consist of text, timestamps, optional mood reflections, and photo references. When you delete a memory record from within the application, that record is removed from the local Room database. Because LIMANEX does not maintain any cloud database or remote backup of your journal entries, deleted records should be considered permanently lost.

---

### 8. Notes & Reflections
Notes entered in cat profiles or memories remain strictly on your device. LIMANEX cannot view, read, analyze, or process your written notes.

---

### 9. Mood Selections
Meowoirs provides subjective mood selections for cats and emotional reflections for users. These fields are purely expressive journaling tools for personal reflection. They do not constitute veterinary behavioral assessments or medical diagnoses.

---

### 10. Photos and Photo Picker
Meowoirs integrates Android's system Photo Picker (`ActivityResultContracts.PickVisualMedia`).
- **No Broad Media Permission:** Meowoirs does not request broad storage permissions (such as `READ_EXTERNAL_STORAGE` or `READ_MEDIA_IMAGES`).
- **No Camera Permission:** Meowoirs does not request the `CAMERA` permission or access your hardware camera sensor.
- **No Cloud Upload:** Photos chosen via the Photo Picker are never uploaded to LIMANEX. Meowoirs only stores local Content URI references on your device.

---

### 11. Profile Preferences
Preferences such as your nickname, chosen avatar, and favorite cat are saved locally on your device via Android Jetpack DataStore.

---

### 12. Local Room Database
All relational journal records are stored locally within an embedded SQLite database utilizing AndroidX Room located inside the application's private internal storage sandbox.

---

### 13. DataStore Preferences
App settings, flags, and onboarding states are saved locally in private DataStore files.

---

### 14. No User Account
Meowoirs does not require registration, usernames, passwords, or authentication. You can use the app immediately without creating an account.

---

### 15. No Login
There is no login system, single sign-on (SSO), or social media authentication in Meowoirs.

---

### 16. No Cloud Synchronization
Meowoirs does not synchronize your journal entries, cat profiles, or photos across multiple devices or to any remote cloud service.

---

### 17. No LIMANEX Cloud Journal Database
LIMANEX does NOT operate, own, or host any cloud database, server, or API that stores your journal entries.

---

### 18. No Remote Journal Storage
Your diary entries, memories, photos, and notes exist only on the physical Android device where they were created.

---

### 19. No Automated Cloud Backup
Meowoirs does not provide an automatic cloud backup facility. Users are solely responsible for maintaining independent backups of any content they consider irreplaceable.

---

### 20. Data Deletion
Users can delete individual memories or cat profiles within the app. Note that deleting a cat profile removes that profile record while preserving associated memories according to database design. Meowoirs does not operate its own cloud backup or synchronization service. Clearing application data or uninstalling the application may remove locally stored Meowoirs data. Android or device-level backup and restoration behavior, where available, is controlled by the operating system and device configuration and is not operated or guaranteed by LIMANEX.

---

### 21. Data Loss
Because Meowoirs stores journal entries locally without a cloud backup, LIMANEX cannot restore or recover lost data resulting from user deletion, app storage clearing, uninstalling, device damage, operating system corruption, or device loss. Users are responsible for independent backups of irreplaceable content.

---

### 22. Device Security
Meowoirs relies on standard Android operating system sandboxing. Data security is dependent upon your physical device security, device lock mechanisms, and the integrity of your operating system.

---

### 23. Android Permissions
Meowoirs uses minimal permissions:
- `INTERNET` and `ACCESS_NETWORK_STATE`: Required solely for third-party SDKs (AdMob, UMP, Crashlytics).
- Meowoirs does NOT request `CAMERA`, `READ_CONTACTS`, `ACCESS_FINE_LOCATION`, `RECORD_AUDIO`, or broad media/storage permissions.

---

### 24. Google Mobile Ads (AdMob)
Meowoirs displays non-intrusive banner and interstitial ads provided by Google Mobile Ads (AdMob) to support ongoing development:
- Application ID: `ca-app-pub-5877011177866406~4355156867`
- Banner Ad Unit: `ca-app-pub-5877011177866406/2930394553`
- Interstitial Ad Unit: `ca-app-pub-5877011177866406/2195897382`
Full-screen interstitial advertisements may occasionally appear at appropriate natural transition points according to the application's configured ad frequency rules. Interstitial advertisements are not intentionally presented while the user is actively filling out a form, typing content, selecting media, or performing a critical save/delete confirmation action. Google may process technical identifiers such as your IP address and Google Advertising ID (GAID) in accordance with Google's privacy policies.

---

### 25. User Messaging Platform (UMP)
Meowoirs integrates Google's UMP SDK to present certified consent forms to users located in jurisdictions requiring consent (such as the EEA and UK) before serving personalized advertising. You can review and adjust your privacy choices at any time via Settings -> Privacy Options ("Gizlilik Tercihleri").

---

### 26. Firebase Crashlytics
Meowoirs integrates Firebase Crashlytics to monitor stability and troubleshoot critical crashes. Crashlytics collects technical diagnostics, including:
- Stack traces and crash logs.
- Device make, model, architecture, and OS version.
- Application version and build number.
- System orientation, free disk space, and crash timestamp.
Meowoirs does NOT intentionally log, attach, or send your cat names, journal entries, notes, mood selections, or photo URIs to Crashlytics.

---

### 27. Technical Diagnostics
Diagnostic information is used solely for technical troubleshooting, bug fixing, and ensuring application stability.

---

### 28. Advertising Identifiers (GAID)
Google Advertising ID is a user-resettable identifier managed by Google Play Services. You can reset or delete your GAID via Android Settings -> Google -> Ads. Meowoirs does not link your local journal entries to your GAID.

---

### 29. Third-Party Services Summary
- **Google AdMob:** Advertising display and mediation.
- **Google UMP:** Consent management.
- **Firebase Crashlytics:** Crash diagnostics.
These services operate under Google LLC's privacy policies: https://policies.google.com/privacy

---

### 30. Data Retention
Local journal data is retained on your device until you delete it, clear app storage, or uninstall Meowoirs. Data processed by third-party SDKs is retained according to Google's independent retention schedules.

---

### 31. User Rights
You have direct control over your local data. You can inspect, modify, and delete your journal records within the app or erase all data via Android system settings.

---

### 32. KVKK (Personal Data Protection Law of Türkiye)
Under Law No. 6698 (KVKK) in the Republic of Türkiye, users hold rights regarding their personal data. Because LIMANEX does not store your journal data on remote servers, your journal data remains entirely within your own custody on your local device. For privacy inquiries or requests regarding telemetry, contact: limanexsoftware@outlook.com.

---

### 33. International Users
Meowoirs does not transfer your local journal records across international borders. Technical metrics processed by Google may be transferred globally in accordance with Google's international data transfer frameworks.

---

### 34. California Privacy Disclosures (CCPA / CPRA)
Meowoirs does not sell personal information. Technical advertising sharing via Google AdMob can be controlled through your Android device settings or the in-app privacy options.

---

### 35. Children's Privacy
Meowoirs is designed for a general audience and does not knowingly collect personal data from children.

---

### 36. Security Disclaimer
While Android isolates application data within a sandboxed environment on non-rooted devices, LIMANEX does not make absolute guarantees of unbreakable security.

---

### 37. Changes to this Privacy Policy
LIMANEX reserves the right to update this policy periodically. Material updates will be reflected in the "Last Updated" date and posted on the public website and app store listings.

---

### 38. Contact Information
For questions or inquiries regarding this Privacy Policy:
- **Developer / Operator:** LIMANEX
- **Country:** Türkiye
- **Email:** limanexsoftware@outlook.com
- **Website:** https://limanexstudio.com

---

## PART II — TERMS OF SERVICE

# MEOWOIRS TERMS OF SERVICE

**Effective Date:** September 7, 2026  
**Last Updated:** September 7, 2026  
**Legal Version:** 1.0

---

### 1. Acceptance of Terms
By downloading, installing, accessing, or using the Meowoirs mobile application ("Application"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree, you must not use and must uninstall the Application.

---

### 2. Eligibility
You represent that you have legal capacity to enter into these Terms under applicable law, or have obtained consent from a parent or legal guardian if a minor.

---

### 3. Description of Service
Meowoirs is an offline-first companion journal for cat guardians, providing cat profiles, journal memories, photo associations via Photo Picker, mood reflections, and milestone tracking. It is supported by digital advertising.

---

### 4. Account-Free Architecture
Meowoirs operates without user accounts, logins, or central user databases. Access is immediate upon installation.

---

### 5. Local Storage
All cat profiles, memories, notes, and mood selections are stored locally on your Android device. LIMANEX does not maintain a remote server or cloud database for your journal entries. Meowoirs does not operate its own cloud backup or synchronization service. Clearing application data or uninstalling the application may remove locally stored Meowoirs data. Android or device-level backup and restoration behavior, where available, is controlled by the operating system and device configuration and is not operated or guaranteed by LIMANEX.

---

### 6. User Responsibility
You are solely responsible for your use of the Application, your device security, and any User Content you enter into the Application.

---

### 7. Data Loss
Because Meowoirs stores journal entries locally without a cloud backup, LIMANEX cannot restore or recover lost data resulting from deletion, clearing app storage, uninstalling, device damage, or system failure.

---

### 8. Backup Responsibility
You are solely responsible for maintaining independent external backups of irreplaceable photos, notes, and memories. LIMANEX has no technical ability to restore or reconstruct lost local data.

---

### 9. Deletion
You may delete memories or cat profiles within the app. Note that deleting a cat profile removes the profile but preserves associated memories in accordance with current database design. Complete deletion is achieved by clearing app data or uninstalling.

---

### 10. User Content
You retain all ownership and intellectual property rights in the text, notes, and photos you associate with Meowoirs.

---

### 11. User Conduct
You agree to use the Application in compliance with all applicable laws and refrain from unlawful, infringing, or harmful conduct.

---

### 12. Prohibited Uses
You may not decompile, reverse-engineer, modify, disrupt advertisements, or exploit the Application for unauthorized commercial purposes.

---

### 13. Intellectual Property
The Application, design, source code, UI, themes, icons, and brand names ("Meowoirs", "LIMANEX") are the exclusive intellectual property of LIMANEX and its licensors.

---

### 14. License to Use the Application
LIMANEX grants you a personal, revocable, non-exclusive, non-transferable, limited license to use Meowoirs on your compatible Android device for personal, non-commercial purposes.

---

### 15. Third-Party Services
Third-party SDKs (Google Mobile Ads, Google UMP, Firebase Crashlytics) are subject to their respective terms and privacy policies.

---

### 16. Advertising
Meowoirs displays banner and interstitial advertisements served by Google Mobile Ads. LIMANEX does not endorse third-party advertised products or services.

---

### 17. Availability
Meowoirs is provided on an "AS IS" and "AS AVAILABLE" basis without guarantee of continuous, uninterrupted, or error-free operation.

---

### 18. Updates
LIMANEX may release updates, patches, or enhancements through Google Play, but is not obligated to provide future feature expansions.

---

### 19. Changes to Service
LIMANEX reserves the right to modify or discontinue the Application at any time.

---

### 20. Disclaimer of Warranties
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THE APPLICATION IS PROVIDED "AS IS" WITHOUT WARRANTIES OF ANY KIND, EXPRESS, IMPLIED, OR STATUTORY.

---

### 21. Absolute Disclaimer: Not Veterinary or Medical Advice
MEOWOIRS IS A PERSONAL LIFESTYLE JOURNAL AND NOT A VETERINARY OR MEDICAL TOOL. It does not provide medical diagnoses, treatment advice, or emergency animal services. Always consult a licensed veterinarian for animal health concerns.

---

### 22. Limitation of Liability
TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, LIMANEX'S TOTAL AGGREGATE LIABILITY ARISING OUT OF OR RELATING TO MEOWOIRS OR THESE TERMS SHALL NOT EXCEED USD 100. THIS LIMITATION DOES NOT APPLY WHERE PROHIBITED BY MANDATORY CONSUMER PROTECTION LAW.

---

### 23. Exclusion of Indirect Damages
TO THE MAXIMUM EXTENT PERMITTED BY LAW, LIMANEX SHALL NOT BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES, OR LOSS OF DATA, REPUTATION, OR GOODWILL.

---

### 24. Indemnification
Where legally enforceable, you agree to indemnify and hold harmless LIMANEX from claims, liabilities, and expenses arising out of your violation of these Terms or misuse of the Application.

---

### 25. Governing Law
These Terms are governed by the laws of the Republic of Türkiye, without regard to conflict of law principles.

---

### 26. Jurisdiction
Competent courts and enforcement offices in Türkiye shall have jurisdiction over disputes arising under these Terms, subject to mandatory statutory jurisdiction rules and non-waivable consumer rights.

---

### 27. Severability
If any provision of these Terms is held invalid or unenforceable, the remaining provisions shall remain in full force and effect.

---

### 28. Contact & Changes to Terms
For inquiries regarding these Terms, contact:
- **Developer / Operator:** LIMANEX
- **Email:** limanexsoftware@outlook.com
- **Website:** https://limanexstudio.com
LIMANEX reserves the right to update these Terms at any time with revised dates posted on the website.

---

## PART III — LEGAL DISCLAIMER NOTICE

> **NOTICE:**  
> This legal documentation is intended to describe the current Meowoirs application and does not constitute individualized legal advice or a guarantee of legal compliance in every jurisdiction. LIMANEX recommends professional legal review where appropriate.
