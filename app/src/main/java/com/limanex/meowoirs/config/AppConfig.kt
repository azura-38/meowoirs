package com.limanex.meowoirs.config

/**
 * Central configuration constants for Meowoirs.
 * Any missing legal/contact configurations are centralized here rather than
 * scattered across the application.
 */
object AppConfig {

    /**
     * Primary support and reach-us contact email.
     * DEVELOPER INPUT REQUIRED: Replace with official production contact/support email before release.
     */
    const val MEOWOIRS_SUPPORT_EMAIL = "contact@limanex.com"

    /**
     * Hosted public URL for the Privacy Policy.
     * DEVELOPER INPUT REQUIRED: Set to official public hosted URL when available.
     * If blank or unconfigured, the UI presents an informational publication-pending sheet
     * without claiming a non-existent URL.
     */
    const val PRIVACY_POLICY_URL = ""

    /**
     * Hosted public URL for the Terms of Service.
     * DEVELOPER INPUT REQUIRED: Set to official public hosted URL when available.
     * If blank or unconfigured, the UI presents an informational publication-pending sheet
     * without claiming a non-existent URL.
     */
    const val TERMS_OF_SERVICE_URL = ""

    /**
     * Current version of the legal terms and privacy policy.
     * When legal documents are updated in the future, incrementing this version
     * allows requiring re-acceptance without Room database migrations.
     */
    const val CURRENT_LEGAL_VERSION = "1"
}
