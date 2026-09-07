# MEOWOIRS — FINAL PRIVACY POLICY & TERMS OF SERVICE

> **IMPORTANT NOTICE:**  
> This document package constitutes a factual, architecture-aligned legal drafting package prepared specifically for the Meowoirs Version 1.0.0 application. It does not constitute formal legal certification or legal advice. The developer should have the final documents reviewed by qualified legal counsel in the relevant operating jurisdictions prior to public distribution.

---

## PART I — FINAL PRIVACY POLICY

# MEOWOIRS PRIVACY POLICY

**Effective Date:** March 2026  
**Last Updated:** March 2026

---

### 1. Introduction

Welcome to **Meowoirs** (the "Application").

This Privacy Policy describes how information is handled in connection with your download, installation, and use of the Meowoirs mobile application on Android devices. Meowoirs is a personal, offline-first cat memory journal designed to help individuals record thoughts, stories, and daily interactions with home companion cats and neighborhood/community street cats.

This Privacy Policy explains:
- The categories of information you may enter into the Application and where that information is stored.
- The absence of proprietary application backend servers, remote account systems, or central journal databases operated by Meowoirs.
- How integrated third-party advertising and consent technologies (specifically, Google Mobile Ads / AdMob and the Google User Messaging Platform) may process technical device information.
- Your options, rights, and responsibilities regarding data entered into the Application.

The Application is published and operated under the publisher moniker **Limanex**.
- **Legal Operator Identity:** [DEVELOPER INPUT REQUIRED: Legal Entity Name or Registered Developer Name]
- **Operator Physical / Business Address:** [DEVELOPER INPUT REQUIRED: Physical Business Address or Contact Mailing Address]
- **Privacy Contact Email:** [DEVELOPER INPUT REQUIRED: Monitored Privacy Email Address]
- **Public Policy URL:** [DEVELOPER INPUT REQUIRED: Public Web URL where this policy is hosted]

Please review this Privacy Policy carefully. By downloading, installing, or using the Application, you acknowledge the practices described in this Privacy Policy. If you do not agree with these practices, please do not use the Application and remove it from your device.

---

### 2. Definitions

For the purposes of this Privacy Policy:
- **"Application"** or **"Meowoirs"** refers to the Meowoirs mobile software application for Android, package identifier `com.limanex.meowoirs`, Version 1.0.0.
- **"User"**, **"you"**, or **"your"** refers to any individual accessing or using the Application.
- **"Device"** refers to the compatible Android smartphone, tablet, or portable hardware on which the Application is installed.
- **"Personal Data"** (or "Personal Information") means any information that identifies, relates to, describes, or is reasonably capable of being associated with an identified or identifiable natural person.
- **"User Content"** refers to all text, journal notes, cat profile entries, mood reflections, and photo references created or selected by the User within the Application.
- **"Cat Profile"** refers to an individual record created by the User within the Application representing either a domestic indoor cat ("Home Cat") or an outdoor/community animal ("Street Cat").
- **"Memory"** refers to an individual journal entry created within the Application consisting of an associated cat identifier, a timestamp, an optional text note, optional mood reflections, and an optional local photo reference.
- **"Third-Party Service"** refers to third-party technologies or SDKs embedded within the Application, specifically Google Mobile Ads (AdMob) and the Google User Messaging Platform (UMP).
- **"Advertising ID"** refers to the Google Advertising ID (GAID), a unique, user-resettable identifier provided by Google Play services for advertising and analytics purposes.

---

### 3. Information We Collect

Meowoirs maintains a strict technical separation between **data you enter directly** and **data processed by third-party advertising services**.

#### A. Data Entered Directly by the User
Meowoirs allows you to record personal memories and profiles for your cats. The Application supports the following user-entered data fields:
1. **Cat Profiles:**
   - Cat name (text string).
   - Cat classification (categorized strictly as either "HOME" or "STREET").
   - Cat profile photo reference (local Content URI selected via the Android Photo Picker).
   - Cat profile note (optional text string).
   - Creation timestamp (recorded in Unix epoch milliseconds).
2. **Memories (Journal Entries):**
   - Associated Cat identifier and Cat name.
   - Journal note (text string describing your memory or observation).
   - Memory photo reference (local Content URI selected via the Android Photo Picker).
   - Cat mood reflection (optional selection from: "Mutlu" / Happy, "Meraklı" / Curious, "Uykulu" / Sleepy, "Oyuncu" / Playful, "Sakin" / Calm, "Sevecen" / Affectionate).
   - User emotional reflection (optional selection from: "Mutlu" / Happy, "Huzurlu" / Peaceful, "Özlemli" / Nostalgic, "Neşeli" / Joyful, "Sakin" / Calm, "Duygusal" / Touched).
   - Creation timestamp (recorded in Unix epoch milliseconds).

**Local Storage Verification:** All data fields listed above are stored **locally on your physical Device** within an embedded SQLite database managed via AndroidX Room. Limanex **does not** transmit, copy, synchronize, or back up any of these records to any proprietary server or cloud infrastructure.

---

### 4. Information We Do NOT Collect Directly

Meowoirs itself operates without collecting or requesting personal identifying credentials. The Application itself **does not collect, require, store, or process**:
- Real names, physical home addresses, or postal codes.
- Email addresses or telephone numbers.
- User accounts, logins, usernames, or passwords.
- Social media authentication, Google Account logins, or third-party sign-ins.
- Contacts or address book data stored on your Device.
- Audio recordings, microphone sensor data, or voice inputs.
- Precise GPS coordinates or fine location hardware data.
- SMS logs, telephony records, or call histories.
- Camera hardware sensor access or live camera streams.
- Medical, veterinary, diagnostic, clinical, or biological health records.
- Payment details, bank account numbers, or financial billing information.

*(Note: Third-party advertising and consent services integrated into the Application may process certain network and device-level technical identifiers as described in Section 7 and Section 11).*

---

### 5. Local Storage Architecture

- **Embedded Database:** Meowoirs stores all Cat Profiles, memories, notes, and mood selections in a local SQLite database utilizing the AndroidX Room persistence library located within the Application's private internal storage sandbox on your Device.
- **No Proprietary Cloud Backend:** Limanex does not operate, host, or connect the Application to any proprietary cloud database, remote API, or central synchronization server.
- **No Cloud Synchronization:** Your journal entries exist only on the Device where they were entered. They cannot be accessed remotely, synchronized across multiple devices, or recovered by Limanex.
- **Local Media References:** Photos associated with profiles or memories are stored on your Device's local filesystem or storage provider; the Application stores only the local Content URI string.
- **Data Removal Behavior:**
  - Clearing the Application's storage/data through Android system settings may permanently remove locally stored Meowoirs data.
  - Uninstalling the Application from your Device will permanently remove the local SQLite database and its contents.
  - Device damage, hardware failure, factory resets, or operating system reinstalls will result in the permanent loss of locally stored Application data.
  - **Limanex has no technical means to recover, restore, or reconstruct lost local data.**

---

### 6. Photos and Media

Meowoirs manages media associations with strict respect for user privacy:
- **Android Photo Picker:** The Application uses the modern Android Photo Picker (`ActivityResultContracts.PickVisualMedia` with `ImageOnly`).
- **No Broad Storage Permission:** Meowoirs does not request or require broad storage permissions (such as `READ_EXTERNAL_STORAGE` or `READ_MEDIA_IMAGES`). The Photo Picker allows you to select individual images without granting the Application access to the rest of your photo gallery.
- **No Uploads to Limanex:** Photos selected by the User are **never uploaded** to any server operated by Limanex.
- **URI Lifecycles & Persistence:** The Application retains only the Content URI reference string pointing to the image on your Device. If the original image is moved, deleted, renamed, or if permission grants expire under Android operating system rules, the image may no longer render within the Application.
- **Security Context:** While Android isolates application files within its standard application sandbox on non-rooted devices, local database files and URI references are not protected by custom proprietary encryption layers.

---

### 7. Advertising (Google Mobile Ads / AdMob)

To support the Application as a free download, Meowoirs integrates the **Google Mobile Ads SDK (AdMob)**.

#### Advertising Implementation Details:
- **Formats Displayed:** The Application displays banner advertisements (situated on designated screens) and occasional interstitial advertisements (full-screen ads shown during major navigation transitions, subject to pacing rules and launch thresholds).
- **Third-Party Provider:** Advertisements are delivered independently by Google and its certified advertising partners.
- **Data That May Be Processed by Google:** Depending on applicable device settings, user consent, geographic region, and SDK behavior, Google may collect and process technical information, including:
  - IP address (used to infer general non-precise location and detect invalid traffic/fraud).
  - Google Advertising ID (GAID), subject to device settings.
  - Technical device characteristics (device model, operating system version, screen size, carrier, connection type).
  - Diagnostic and performance data (ad loading latency, crash logs, rendering performance).
  - Ad interaction data (impressions, clicks, viewability metrics).
- **Personalized vs. Non-Personalized Advertising:** In regions where privacy regulations or consent frameworks apply (such as the EEA, UK, or California), advertisements may be non-personalized or personalized based on user consent choices and device configuration. Non-personalized ads do not use mobile advertising identifiers for user profiling but may still use contextual signals and non-precise location derived from IP addresses.

**Independence of Advertising Services:** Limanex **does not control** Google's independent data processing, algorithms, or third-party ad networks participating in Google’s ad exchange. For further information regarding Google’s advertising practices, please consult Google’s official Privacy Policy.

---

### 8. User Messaging Platform (UMP) & Consent

In compliance with regional privacy laws—including European Economic Area (EEA) and United Kingdom GDPR requirements, as well as Google's EU User Consent Policy—Meowoirs integrates the **Google User Messaging Platform (UMP) SDK**.

- **Consent Presentation:** Where legally required based on your geographic location, the Application presents a standardized UMP consent dialog upon launch.
- **User Options:** Users may grant, deny, or customize consent regarding the use of advertising identifiers, personalized advertising, and partner data processing.
- **Application Ad Request Handling:** The Application checks the consent status reported by the UMP SDK before requesting ads. If consent is withheld or restricted, the SDK adapts ad requests in accordance with applicable platform standards.
- **Changing Preferences:** You can modify your consent choices at any time by clearing the Application's storage/data in Android system settings (which resets the stored UMP consent status and re-presents the consent dialog upon next launch) or by managing your Google Advertising ID in Android settings.

---

### 9. Advertising Identifiers (Google Advertising ID)

- **Android Advertising ID (GAID):** A unique, user-resettable identifier supplied by Google Play services on Android devices. It enables advertising networks to deliver relevant ads, measure campaign efficacy, and combat ad fraud.
- **Strict Separation:** Meowoirs does not access, inspect, or store your GAID within its local journaling code. Meowoirs does not associate your cat profiles, notes, or memories with your GAID, nor does it construct user profiles combining journal content with advertising identifiers.
- **Operating System Controls:** You retain full control over your Advertising ID. On compatible Android versions, you can reset or delete your Advertising ID at any time via:  
  `Settings > Google > Ads` or `Settings > Privacy > Ads`.

---

### 10. Network Communications

- **Core Journaling Functionality:** Core journaling functionality—including creating cat profiles, writing memories, selecting moods, and browsing the "My Story" timeline—is designed to operate locally on the device without requiring network connectivity.
- **Network-Dependent Services:** The Application requires an active internet connection solely to communicate with third-party advertising and consent endpoints operated by Google (specifically, to fetch UMP consent forms, evaluate regional requirements, and request/render advertisements).
- **Accurate Scope:** Core journaling functionality is designed to operate locally on the device. Advertising and consent services may require network connectivity. If the Device is offline, core journal functionality remains accessible, but advertisements will not load.

---

### 11. Third-Party Services Evaluation

The following table details all third-party software development kits (SDKs) integrated into Meowoirs:

| Service | Provider | Purpose in Meowoirs | Potential Data Processed | Privacy Reference |
| :--- | :--- | :--- | :--- | :--- |
| **Google Mobile Ads (AdMob)** | Google LLC / Google Ireland Limited | Delivering banner and interstitial advertisements | IP address, Advertising ID (GAID), device technical specs, ad interaction metrics, diagnostics | [OFFICIAL URL VERIFICATION REQUIRED: https://policies.google.com/privacy] |
| **Google User Messaging Platform (UMP)** | Google LLC / Google Ireland Limited | Managing regional user consent for advertising and privacy | Device characteristics, general region, consent choice strings, timestamp | [OFFICIAL URL VERIFICATION REQUIRED: https://policies.google.com/technologies/partner-sites] |

*No other third-party SDKs (such as social logins, external analytics trackers, or payment processors) are present in the Application.*

---

### 12. Analytics & Crash Reporting

To ensure full factual transparency:
- **Firebase Analytics:** **NOT PRESENT.** The Application does not integrate or initialize Firebase Analytics.
- **Firebase Crashlytics:** **NOT PRESENT.** The Application does not integrate or initialize Firebase Crashlytics.
- **Third-Party Behavioral Analytics:** **NOT PRESENT.** The Application does not include Mixpanel, Amplitude, AppsFlyer, Adjust, or any equivalent behavioral tracking software.
- **Aggregated Platform Diagnostics:** If you download Meowoirs from the Google Play Store and have opted into sharing system diagnostics with Google, Google Play may provide aggregated, non-personally identifiable crash stack traces and Application Not Responding (ANR) summaries to Limanex via the Google Play Developer Console.

---

### 13. Data Sharing & Disclosure

- **No Sale of Journal Data:** Limanex does not sell, rent, commercialize, or trade your journal notes, cat profiles, photos, or personal memories.
- **No Server-Side Transfer:** Because Limanex does not operate a remote server for Meowoirs, your written memories and photos are never uploaded to, received by, or in the possession of Limanex.
- **Third-Party Processing:** Integrated third-party advertising and consent SDKs (Google Mobile Ads and Google UMP) may process technical device data as described in Section 7 and Section 11, subject to your device configuration and consent.
- **Compelled Legal Disclosures:** In the event that Limanex receives a formal legal request or subpoena seeking user journal entries, Limanex would be technically incapable of providing such content, as Limanex does not possess, transmit, or store your local journal database.

---

### 14. Data Retention

#### A. Local Application Data
All Cat Profiles, memories, written notes, mood reflections, and photo URI references are retained on your physical Device for as long as the Application remains installed with its local storage intact. Local data is retained until:
- You clear the Application's storage/data through Android system settings.
- You uninstall the Application from your Device.
- Android operating system processes or storage management tools remove it.

*(Note: Version 1.0.0 does not include in-app UI for deleting individual Cat Profiles or individual Memories. Complete data removal is accomplished via Android system settings or uninstallation).*

#### B. Third-Party Advertising & Consent Data
Data collected by Google Mobile Ads and Google UMP is retained in accordance with Google's independent data retention policies. Limanex does not determine, store, or manage Google’s internal data retention schedules.

---

### 15. Data Deletion & User Rights

- **No Remote Account Deletion System:** Because Meowoirs does not utilize user accounts, email logins, or central server databases, Limanex does not maintain an online account deletion portal or remote database deletion API.
- **How to Remove Your Local Data:** You maintain direct and complete control over your local data. You may remove all locally stored Meowoirs application data at any time by:
  1. Opening your Device's **Settings > Apps > Meowoirs > Storage**.
  2. Tapping **Clear Data** (or **Clear Storage**).
  3. Alternatively, uninstalling the Application from your Device will immediately remove the local SQLite database.

---

### 16. Children's Privacy

Meowoirs is designed as a general-audience personal journaling application. It is not specifically targeted, marketed, or directed to children under the age of 13 (or under the applicable age threshold in your jurisdiction, such as 16 in certain European member states).

- **No Child Account Data:** Because the Application operates without user registration or cloud accounts, it does not knowingly collect or solicit personal information from children.
- **Advertising Safeguards:** Advertising displayed in the Application is subject to Google Play Families Policy requirements and general mobile advertising age-appropriate standards. If a parent or guardian believes that technical identifiers have been processed contrary to applicable law, please contact Limanex at [DEVELOPER INPUT REQUIRED: Privacy Contact Email].

---

### 17. International Data Processing

Meowoirs itself does not transfer your journal records across international borders because all journal records remain stored locally on your Device.

However, third-party services integrated into the Application—specifically Google Mobile Ads and Google UMP—operate globally distributed infrastructure. Consequently, technical device identifiers, advertising metrics, and IP addresses processed by Google may be transferred to, stored, and processed in the United States or other countries where Google and its partners operate. Such transfers are governed by Google's own data transfer frameworks and privacy commitments.

---

### 18. Rights Under GDPR / UK GDPR

If you are located in the European Economic Area (EEA) or the United Kingdom (UK), you hold statutory rights under the General Data Protection Regulation (GDPR) and UK Data Protection Act 2018, including:
- **Right of Access:** You can inspect all data you have entered directly within the Application UI on your Device.
- **Right to Erasure ("Right to be Forgotten"):** You can remove all locally stored Meowoirs data at any time by clearing the application's storage/data through Android system settings or by uninstalling the application.
- **Right to Restrict or Object to Processing:** You may object to or restrict processing of advertising data by denying or customizing consent in the UMP consent dialog or by opting out of personalized advertising in your Android system settings.
- **Right to Withdraw Consent:** You can withdraw consent for advertising identifiers at any time by clearing Application storage/data in Android system settings (which re-triggers the UMP consent dialog on next launch) or by adjusting your Google Ads settings.

**Practical Limitation Notice:** Because Limanex does not collect or store your journal records on remote servers and possesses no personal identifiers linking your physical identity to your local Device, Limanex cannot fulfill remote requests to "search, export, or delete" your local journal database. You must exercise these actions directly on your physical Device.

- **Data Protection Inquiries:** For privacy-related inquiries regarding Meowoirs:  
  [DEVELOPER INPUT REQUIRED: Privacy Contact Email / Designated Representative if applicable]
- **Right to Lodge a Complaint:** You have the right to lodge a complaint with your local Data Protection Supervisory Authority if you believe that data processing has violated applicable regulations.

---

### 19. California Privacy Disclosures (CCPA / CPRA)

*To the extent applicable under the California Consumer Privacy Act (CCPA) as amended by the California Privacy Rights Act (CPRA):*

- **Collection of Personal Information:** In the preceding twelve (12) months, Meowoirs has not collected personal information into any centralized server database. Integrated third-party advertising partners may have processed identifiers (such as IP addresses and Advertising IDs) and internet network activity (such as ad interactions).
- **No Sale of Journal Data:** Meowoirs does not sell your personal journal entries, cat profiles, or photos.
- **Cross-Context Behavioral Advertising:** Third-party advertising networks operating via Google Mobile Ads may process data that constitutes "sharing" under California law for cross-context behavioral advertising, subject to your device settings and consent signals.
- **Exercising Consumer Rights:** California residents may limit advertising-related processing by utilizing the "Delete Advertising ID" or "Opt out of Ads Personalization" controls provided natively within Android system settings.

---

### 20. Security

Limanex adopts a privacy-by-design approach by keeping your data local:
- **Minimization of Central Risk:** By storing all User Content locally on your Device rather than transmitting it to a central cloud server, Meowoirs eliminates the risk of centralized server data breaches affecting your personal journal.
- **Operating System Sandboxing:** Android isolates application databases within application-specific storage sandboxes, preventing other standard applications from reading Meowoirs records on non-rooted devices.
- **Realistic Security Perspective:** Limanex does not make claims of "military-grade" or "impenetrable" security. The security of data stored on your Device depends on the physical security of your Device, your lock screen protections (PIN, biometrics), and whether the operating system has been modified or rooted.

---

### 21. User Responsibilities

As a user of an offline-first mobile application, you acknowledge that:
- You are responsible for safeguarding physical and digital access to your Device.
- You are responsible for maintaining independent backups of irreplaceable photos, stories, and notes (e.g., keeping original photos in your primary gallery or preferred backup storage).
- Clearing the application's storage/data through Android system settings or uninstalling the application may permanently remove locally stored Meowoirs data.
- Limanex does not provide an automated cloud recovery service.

---

### 22. Changes to this Privacy Policy

Limanex reserves the right to update this Privacy Policy periodically to reflect changes in legal requirements, third-party advertising implementations, or Application functionality:
- When updates occur, the **"Last Updated"** date at the top of this document will be revised.
- For material changes, updated documentation will be provided via the official Google Play Store listing and within any applicable legal documentation links associated with the Application.
- Your continued use of the Application following the publication of an updated Privacy Policy indicates your acknowledgment of the updated terms.

---

### 23. Contact Information

If you have questions, feedback, or inquiries regarding this Privacy Policy, please contact:

- **Publisher / Operator:** Limanex
- **Privacy Contact Email:** [DEVELOPER INPUT REQUIRED: contact@limanex.com or designated developer email]
- **Developer Website / Legal Portal:** [DEVELOPER INPUT REQUIRED: Public URL]

---

## PART II — FINAL TERMS OF SERVICE

# MEOWOIRS TERMS OF SERVICE

**Effective Date:** [DEVELOPER INPUT REQUIRED]  
**Last Updated:** [DEVELOPER INPUT REQUIRED]

---

### 1. Acceptance of Terms

These Terms of Service ("Terms") constitute a legally binding agreement between you ("User", "you", or "your") and Limanex ("Limanex", "we", "us", or "our") concerning your access to and use of the **Meowoirs** mobile software application on Android (the "Application").

By downloading, installing, accessing, or using the Application, you agree to be bound by these Terms where legally permitted. If you do not agree with all of these Terms, you are expressly prohibited from using the Application and must immediately uninstall and discontinue use.

---

### 2. Eligibility

Meowoirs is intended for general-audience users. By using the Application, you represent and warrant that:
- You are legally capable of entering into these Terms under applicable law in your jurisdiction.
- If you are considered a minor under the laws of your jurisdiction, you have obtained the consent of your parent or legal guardian prior to downloading and using the Application.
- Your use of the Application does not violate any applicable local, national, or international law or regulation.

---

### 3. Description of Service

Meowoirs Version 1.0.0 is an offline-first cat memory journaling application designed for personal, non-commercial use. The Application provides the following verified capabilities:
- Creation and viewing of individual **Cat Profiles** categorized as domestic pets ("Home Cats") or outdoor animals ("Street Cats").
- Recording of **Memories**, including custom text notes, photo references selected via the Android Photo Picker, and dual mood reflections (the cat's mood and the user's emotional reflection).
- Browsing chronological memory timelines, filtering entries by specific cats, and reviewing narrative milestones via the **"My Story"** interface.
- Localized data storage utilizing on-device SQLite databases managed via AndroidX Room.
- Presentation of mobile advertisements served by Google Mobile Ads and consent management powered by the Google User Messaging Platform.

*Meowoirs does not provide cloud synchronization, remote backups, veterinary diagnostics, automated pet tracking, social networking, or e-commerce features.*

---

### 4. No Account Required

Meowoirs does not require registration, login, username creation, password setup, or third-party account authentication. Your access to the Application begins immediately upon installation. Because there is no account infrastructure, Limanex does not maintain user account records on any remote server.

---

### 5. Local Data Responsibility & Risk of Data Loss

**PLEASE REVIEW THIS SECTION CAREFULLY:**

- **Local Storage Architecture:** All Cat Profiles, written memories, mood reflections, and photo references are saved exclusively to the local file storage of your specific Device.
- **No Cloud Backup:** Meowoirs **does not** maintain a remote backup, cloud sync server, or data redundancy facility.
- **Permanent Loss Risk:** You acknowledge that your data may become permanently inaccessible or irretrievably lost in the event of:
  - Clearing the application's storage/data through Android system settings.
  - Uninstalling the Application from your Device.
  - Device damage, hardware failure, theft, or physical loss.
  - Operating system upgrades, file corruption, or device factory resets.
  - Revocation of media URI permissions by the underlying Android operating system.
- **User Sole Responsibility:** You bear sole responsibility for safeguarding your Device and independently preserving copies of important photos, writings, or memories. **Limanex has no technical ability and no legal obligation to restore, recover, or reconstruct lost local data.**

---

### 6. User Content

"User Content" includes all text, journal notes, names, descriptions, mood selections, and photo references inputted, imported, or recorded by you within the Application. You are solely responsible for all User Content you input into Meowoirs.

---

### 7. Ownership of User Content

- **You Retain Your Rights:** Limanex claims **no ownership rights** over your User Content. You retain complete copyright and any proprietary interests in the text notes and personal photos you associate with your Meowoirs journal.
- **No Transfer to Limanex:** Because Meowoirs operates locally and does not upload your journal data to proprietary servers, your User Content remains strictly in your possession on your personal Device.

---

### 8. Limited License to the Application

Subject to your continuous compliance with these Terms, Limanex grants you a personal, revocable, non-exclusive, non-transferable, non-sublicensable, limited license to download, install, and use Meowoirs on compatible Android devices owned or controlled by you, solely for your personal, non-commercial reflection and entertainment.

Because Version 1.0.0 does not upload journal content to Limanex servers, no broad content license is granted by you to Limanex beyond what is technically required to execute the Application locally on your Device.

---

### 9. Acceptable Use & User Restrictions

You agree that you will not, and will not permit any third party to:
1. Decompile, reverse engineer, disassemble, decrypt, or attempt to derive the source code of the Application, except to the extent permitted by applicable mandatory law.
2. Modify, adapt, translate, or create derivative works from the Application.
3. Circumvent, disable, or interfere with security features or advertising display components of the Application.
4. Use the Application to store, process, or document content that is unlawful, defamatory, libelous, harassing, hateful, or that infringes upon the intellectual property or privacy rights of any individual.
5. Exploit, automate, click-fraud, or manipulate the advertisements displayed within the Application.
6. Use the Application for commercial advertising, resale, service bureau operations, or commercial multi-user distribution.
7. Use the Application in any manner that violates applicable export control laws or sanctions.

---

### 10. Intellectual Property Rights

- **Limanex Ownership:** The Application—including its source code, architecture, user interface design, graphic themes, layout, button styles, typography selections, logos, audio assets, and original text—is the exclusive intellectual property of Limanex and its licensors, protected by copyright, trademark, and other applicable intellectual property laws.
- **Brand Protection:** The name **"Meowoirs"**, the tagline **"Every cat has a story"**, and associated brand assets may not be used, copied, or imitated without prior written authorization from Limanex.

---

### 11. Advertising

- **Supported by Ads:** The Application displays advertisements served by Google Mobile Ads (AdMob), which may include banner advertisements and interstitial advertisements.
- **Third-Party Content:** Advertisements may promote third-party products, services, or websites. Limanex does not endorse, sponsor, warrant, or assume responsibility for any third-party products, services, content, or practices advertised through Google Mobile Ads.
- **Interactions at Your Own Risk:** Any interaction, purchase, or engagement with an advertiser is solely between you and the third-party advertiser.
- **Ad Availability:** Core journaling functionality is designed to operate locally on the device. Advertising and consent services may require network connectivity. Ad availability may vary based on geographic location, device capabilities, inventory availability, and user consent parameters.

---

### 12. Third-Party Services

The Application integrates third-party software libraries, specifically the Google Mobile Ads SDK and Google User Messaging Platform. Your interaction with features reliant on these services is subject to the terms, conditions, and privacy policies of the respective third-party providers. Limanex is not responsible for the availability, uptime, or technical performance of third-party networks.

---

### 13. Absolute Disclaimer: No Medical or Veterinary Advice

**IMPORTANT NOTICE REGARDING FELINE HEALTH:**

- **Not Veterinary Software:** Meowoirs is strictly a personal memory journal and reflective companion. **The Application is NOT a veterinary, medical, diagnostic, clinical, treatment, emergency, or health-monitoring tool.**
- **No Professional Guidance:** Nothing contained in the Application—including mood selections, journal prompts, narrative summaries, or sample texts—constitutes or should ever be relied upon as veterinary advice, medical diagnosis, behavioral diagnosis, or emergency guidance.
- **Seek Professional Care:** Always consult a licensed, qualified veterinary medical professional regarding the health, diet, behavioral abnormalities, medical symptoms, or emergency care of any cat. Never disregard professional veterinary advice or delay seeking care because of something recorded in or omitted by this Application.

---

### 14. No Guarantee of Data Preservation or Application Continuity

- **No Preservation Warranty:** Limanex does not warrant or guarantee that your data will never be lost, corrupted, or removed. You agree that Limanex shall have no liability whatsoever for any loss of data, loss of photos, or emotional distress resulting from the loss of journal entries.
- **Service Changes:** Limanex reserves the right to modify, suspend, or discontinue the Application, or any portion thereof, at any time, with or without notice.

---

### 15. Availability & Compatibility

- **System Requirements:** Meowoirs requires a compatible Android device running an operating system version equal to or greater than Android 8.0 (API Level 26 / minSdk 26).
- **No Uninterrupted Operation Guarantee:** Limanex does not guarantee that the Application will function without interruption, errors, bugs, or delays, or that the Application will remain compatible with all future hardware, firmware, or Android operating system updates.

---

### 16. Disclaimer of Warranties

TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THE APPLICATION IS PROVIDED ON AN **"AS IS"** AND **"AS AVAILABLE"** BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS, IMPLIED, STATUTORY, OR OTHERWISE.

LIMANEX EXPRESSLY DISCLAIMS ALL WARRANTIES OF ANY KIND, INCLUDING BUT NOT LIMITED TO:
- IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND NON-INFRINGEMENT.
- WARRANTIES THAT THE APPLICATION WILL MEET YOUR REQUIREMENTS, ACHIEVE ANY INTENDED RESULTS, BE UNINTERRUPTED, ACCURATE, COMPLETE, FREE OF HARMFUL CODE, OR ERROR-FREE.
- WARRANTIES REGARDING THE PRESERVATION, SECURITY, OR AVAILABILITY OF LOCAL DATA.

*Nothing in this section excludes or limits warranties that cannot be excluded or limited under mandatory applicable consumer protection law.*

---

### 17. Limitation of Liability

TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW:
1. **CONSEQUENTIAL DAMAGES:** IN NO EVENT SHALL LIMANEX, ITS AFFILIATES, DIRECTORS, EMPLOYEES, AGENTS, OR LICENSORS BE LIABLE FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, PUNITIVE, OR EXEMPLARY DAMAGES WHATSOEVER, INCLUDING WITHOUT LIMITATION DAMAGES FOR LOSS OF DATA, LOSS OF GOODWILL, EMOTIONAL DISTRESS, DEVICE MALFUNCTION, OR BUSINESS INTERRUPTION, ARISING OUT OF OR IN CONNECTION WITH YOUR USE OF OR INABILITY TO USE THE APPLICATION.
2. **GENERAL LIABILITY LIMITATION:** TO THE EXTENT PERMITTED BY APPLICABLE LAW, THE TOTAL AGGREGATE LIABILITY OF LIMANEX ARISING FROM OR RELATED TO THE APPLICATION OR THESE TERMS SHALL BE LIMITED TO THE GREATEST EXTENT PERMITTED BY THE LAW OF THE APPLICABLE JURISDICTION.
3. **MANDATORY CONSUMER RIGHTS:** NOTHING IN THESE TERMS SHALL OPERATE TO EXCLUDE OR LIMIT ANY LIABILITY WHICH CANNOT BE LAWFULLY EXCLUDED OR LIMITED UNDER APPLICABLE MANDATORY CONSUMER PROTECTION LAWS.

---

### 18. Indemnification

You agree to defend, indemnify, and hold harmless Limanex, its contractors, licensors, and affiliates from and against any claims, liabilities, damages, losses, costs, and expenses (including reasonable legal and attorney fees) arising out of or in any way connected with:
- Your access to or use of the Application.
- Your violation of these Terms or applicable law.
- Any User Content you create or input that infringes upon third-party intellectual property or privacy rights.

---

### 19. Termination

- **User Termination:** You may terminate your legal relationship under these Terms at any time by uninstalling the Application and deleting all local application data from your Device.
- **Limanex Termination:** Limanex may terminate or suspend your license to use the Application at any time, without prior notice, if you violate any material provision of these Terms or if Limanex discontinues the Application.
- **Surviving Clauses:** Upon termination, all provisions of these Terms which by their nature should survive will survive, including ownership provisions, warranty disclaimers, indemnity, and limitations of liability.

---

### 20. Changes to the Application

Limanex reserves the right to modify, update, enhance, alter, or remove features of Meowoirs at any time through application updates distributed via Google Play. Limanex makes no commitment to provide future feature updates, cloud sync capabilities, or technical enhancements.

---

### 21. Changes to these Terms

Limanex reserves the right to amend or replace these Terms at any time. If a revision is material, we will provide reasonable notice by updating the "Last Updated" date at the top of these Terms and publishing the updated Terms on the public store listing or official documentation URL. Your continued access to or use of the Application after revisions become effective signifies your agreement to the revised Terms.

---

### 22. Governing Law & Dispute Resolution

**Governing Law:** [DEVELOPER INPUT REQUIRED: Specify Jurisdiction, e.g., Laws of the Republic of Turkey / State of California / Country of Incorporation].

Any dispute, claim, or controversy arising out of or relating to these Terms, or the breach, termination, enforcement, interpretation, or validity thereof, shall be subject to the exclusive jurisdiction of the competent courts located in [DEVELOPER INPUT REQUIRED: City, Jurisdiction].

*Recommendation: Qualified local legal counsel should review this clause prior to commercial launch.*

---

### 23. Severability

If any provision of these Terms is found to be unlawful, void, or for any reason unenforceable by a court of competent jurisdiction, that provision shall be deemed severable from these Terms and shall not affect the validity and enforceability of any remaining provisions.

---

### 24. Entire Agreement

These Terms, together with the Meowoirs Privacy Policy, constitute the entire legal agreement between you and Limanex regarding the use of the Application, superseding all prior oral or written agreements, representations, or understandings between the parties.

---

### 25. Contact & Support

If you have any questions, concerns, or notices regarding these Terms, please contact:

- **Publisher / Operator:** Limanex
- **Support / Legal Contact Email:** [DEVELOPER INPUT REQUIRED: legal@limanex.com or designated developer email]
- **Developer Portal:** [DEVELOPER INPUT REQUIRED: Official developer URL]

---

## PART III — LEGAL CONSISTENCY AUDIT

The following table compares every technical and factual claim in the Privacy Policy and Terms of Service against the actual Meowoirs V0 codebase (`com.limanex.meowoirs`):

| Area / Feature | Codebase Source / Evidence | Verified Status | Privacy Policy Alignment | Terms of Service Alignment | Factual Evaluation |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **Local SQLite / Room** | `androidx.room` in `build.gradle.kts`, `MeowoirsDatabase.kt`, `CatDao.kt`, `MemoryDao.kt` | **VERIFIED** | Stored locally in SQLite via Room; no server upload. (Sec. 3 & 5) | Stored locally on Device; no cloud backup. (Sec. 3 & 5) | Consistent with verified application behavior. |
| **No Backend / No Cloud Sync** | Absence of networking libraries (Retrofit, Ktor, OkHttp client) in `build.gradle.kts` | **VERIFIED** | No proprietary cloud database or remote API. (Sec. 1, 3, 5) | No cloud synchronization or remote backup. (Sec. 3 & 5) | Consistent with verified application behavior. |
| **No User Authentication** | Absence of auth components, login screens, or account data in codebase | **VERIFIED** | No accounts, usernames, emails, or passwords required. (Sec. 4 & 15) | "No Account Required" section. (Sec. 4) | Consistent with verified application behavior. |
| **Android Photo Picker** | `ActivityResultContracts.PickVisualMedia` in `AddCatScreen.kt` & `AddMemoryScreen.kt` | **VERIFIED** | Photo Picker used; no broad storage permissions requested. (Sec. 6) | Explains Photo Picker usage and URI persistence. (Sec. 5 & 6) | Consistent with verified application behavior. |
| **No Broad Storage Permissions** | `AndroidManifest.xml` (No `READ_EXTERNAL_STORAGE` or `READ_MEDIA_IMAGES`) | **VERIFIED** | Confirms absence of broad storage permissions. (Sec. 6) | Consistent with Photo Picker architecture. (Sec. 5) | Consistent with verified application behavior. |
| **Advertising (AdMob)** | `playServicesAds` 23.6.0 in `libs.versions.toml`, `AdManager.kt`, `MeowoirsBannerAd.kt` | **VERIFIED** | Discloses banner and interstitial ads powered by Google. (Sec. 7) | Discloses advertising display and third-party provider. (Sec. 11) | Consistent with verified application behavior. |
| **User Consent (UMP)** | `UserMessagingPlatform` in `AdManager.kt` (`requestConsentAndInitialize`) | **VERIFIED** | Explains UMP consent flow for regional privacy laws. (Sec. 8) | Notes consent requirements for ad display. (Sec. 11 & 12) | Consistent with verified application behavior. |
| **Advertising ID (GAID)** | Merged Google Mobile Ads SDK behavior | **VERIFIED** | Explains GAID processing by Google; distinguishes journal data from GAID. (Sec. 9) | Distinguishes local journal content from ad metrics. (Sec. 11) | Consistent with verified application behavior. |
| **No Firebase Analytics** | `build.gradle.kts` (No Firebase Analytics dependency) | **VERIFIED** | Explicitly confirms Firebase Analytics is NOT PRESENT. (Sec. 12) | No telemetry or tracking claims. (Sec. 3) | Consistent with verified application behavior. |
| **No Firebase Crashlytics** | `build.gradle.kts` (No Firebase Crashlytics dependency) | **VERIFIED** | Explicitly confirms Firebase Crashlytics is NOT PRESENT. (Sec. 12) | No third-party crash reporting claims. (Sec. 15) | Consistent with verified application behavior. |
| **No Location Permissions** | `AndroidManifest.xml` (No `ACCESS_FINE_LOCATION` or `ACCESS_COARSE_LOCATION`) | **VERIFIED** | Confirms no GPS or hardware location data collected. (Sec. 4) | Core functionality operates without location. (Sec. 3) | Consistent with verified application behavior. |
| **No Contacts Permission** | `AndroidManifest.xml` (No `READ_CONTACTS`) | **VERIFIED** | Confirms contacts are not collected or accessed. (Sec. 4) | No address book features. (Sec. 3) | Consistent with verified application behavior. |
| **No Microphone Permission** | `AndroidManifest.xml` (No `RECORD_AUDIO`) | **VERIFIED** | Confirms microphone audio is not collected or accessed. (Sec. 4) | No audio recording features. (Sec. 3) | Consistent with verified application behavior. |
| **No Camera Permission** | `AndroidManifest.xml` (No `CAMERA` permission) | **VERIFIED** | Confirms camera sensor is not directly accessed; Photo Picker used. (Sec. 4 & 6) | Photo selection via system picker. (Sec. 3) | Consistent with verified application behavior. |
| **No Medical / Vet Claims** | `strings.xml`, `DualMoodSelector.kt`, `MyStoryScreen.kt` | **VERIFIED** | Clarifies mood selections are user reflections, not health data. (Sec. 4) | Comprehensive "No Veterinary or Medical Advice" disclaimer. (Sec. 13) | Consistent with verified application behavior. |
| **No Social Network Features** | Codebase review (no feeds, sharing APIs, friends, likes) | **VERIFIED** | Clarifies absence of social network features. (Sec. 1 & 4) | Strictly personal reflection diary. (Sec. 3) | Consistent with verified application behavior. |
| **No In-App Individual Cat Deletion UI** | `CatsScreen.kt`, `CatDetailScreen.kt` (No delete button or DAO delete trigger) | **VERIFIED** | Corrected: Version 1.0.0 does NOT provide individual cat deletion UI. (Sec. 14) | Explains deletion is achieved via app storage clear or uninstall. (Sec. 5 & 19) | Consistent with verified application behavior. |
| **No In-App Individual Memory Deletion UI** | `MemoriesScreen.kt`, `MyStoryScreen.kt` (No delete button or DAO delete trigger) | **VERIFIED** | Corrected: Version 1.0.0 does NOT provide individual memory deletion UI. (Sec. 14) | Explains deletion is achieved via app storage clear or uninstall. (Sec. 5 & 19) | Consistent with verified application behavior. |
| **Local Data Deletion via Android** | Android OS standard storage management behavior | **VERIFIED** | Explains clearing app storage or uninstalling removes data. (Sec. 5, 14, 15, 18) | Explains clearing app storage or uninstalling removes data. (Sec. 5 & 19) | Consistent with verified application behavior. |
| **Developer Contact & Legal Entity** | Placeholders in document | **DEVELOPER INPUT REQUIRED** | Marked as `[DEVELOPER INPUT REQUIRED]`. (Sec. 1 & 23) | Marked as `[DEVELOPER INPUT REQUIRED]`. (Sec. 22 & 25) | Developer must supply real business details prior to publication. |

---

## PART IV — DEVELOPER INPUT CHECKLIST

The developer must provide the following verified information before publishing these documents to the web or linking them in the Google Play Console:

1. **Legal Operator Identity:**
   - [ ] Replace `[DEVELOPER INPUT REQUIRED: Legal Entity Name or Registered Developer Name]` with the exact legal entity name or individual developer legal name associated with the Google Play Console developer account.
2. **Operator Physical / Mailing Address:**
   - [ ] Replace `[DEVELOPER INPUT REQUIRED: Physical Business Address or Contact Mailing Address]` with a legitimate business address or contact address as required by consumer and privacy regulations.
3. **Privacy Contact Email:**
   - [ ] Replace `[DEVELOPER INPUT REQUIRED: Monitored Privacy Email Address]` with a dedicated, monitored inbox (e.g., `privacy@limanex.com`).
4. **Support & Legal Email:**
   - [ ] Replace `[DEVELOPER INPUT REQUIRED: Support / Legal Contact]` with an active support address (e.g., `support@limanex.com`).
5. **Effective Date & Last Updated Date:**
   - [ ] Replace `[DEVELOPER INPUT REQUIRED]` with the publication date (e.g., `March 2026`).
6. **Governing Law & Jurisdiction:**
   - [ ] Specify the applicable governing law (e.g., *Laws of the Republic of Turkey* or *State of Delaware*) and the designated competent courts in Section 22 of the Terms of Service.
7. **Public Hosting URLs:**
   - [ ] Replace `[DEVELOPER INPUT REQUIRED: Public Web URL where this policy is hosted]` with the live HTTPS URL where the policy will be hosted.
8. **Third-Party Policy URL Verification:**
   - [ ] Confirm the official Google privacy documentation link:  
     `https://policies.google.com/privacy`  
     `https://policies.google.com/technologies/partner-sites`

---

## PART V — PUBLICATION CHECKLIST

Complete these steps immediately prior to releasing the application to production:

- [ ] **1. Legal Operator Identity**: Confirmed and entered in both documents.
- [ ] **2. Privacy Email**: Configured, active, and receiving test emails.
- [ ] **3. Support Email**: Configured, active, and receiving test emails.
- [ ] **4. Business / Contact Address**: Entered in Privacy Policy Section 1.
- [ ] **5. Effective Date**: Replaced with the release date.
- [ ] **6. Last Updated Date**: Replaced with the release date.
- [ ] **7. Governing Law**: Approved and entered in Terms of Service Section 22.
- [ ] **8. Jurisdiction**: Approved and entered in Terms of Service Section 22.
- [ ] **9. Public Privacy Policy URL**: Hosted on a live HTTPS web page.
- [ ] **10. Public Terms of Service URL**: Hosted on a live HTTPS web page.
- [ ] **11. Verified Official Google Policy URLs**: Verified as active links.
- [ ] **12. Google Play Console Linking**: Public Privacy Policy URL pasted into Google Play Console under **Policy and programs > Privacy Policy**.
- [ ] **13. Legal Counsel Review**: Qualified legal counsel reviewed the final customized text where appropriate.
