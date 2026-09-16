package com.limanex.meowoirs.config

/**
 * Central configuration constants for Meowoirs.
 * Any missing legal/contact configurations are centralized here rather than
 * scattered across the application.
 */
object AppConfig {

    /**
     * Primary support and privacy contact email.
     */
    const val MEOWOIRS_SUPPORT_EMAIL = "limanexsoftware@outlook.com"

    /**
     * Hosted public URL for the Privacy Policy.
     */
    const val PRIVACY_POLICY_URL = "https://limanexstudio.com/privacy/meowoirs"

    /**
     * Hosted public URL for the Terms of Service.
     */
    const val TERMS_OF_SERVICE_URL = "https://limanexstudio.com/terms/meowoirs"

    /**
     * Current version of the legal terms and privacy policy.
     * When legal documents are updated in the future, incrementing this version
     * allows requiring re-acceptance without Room database migrations.
     */
    const val CURRENT_LEGAL_VERSION = "1"
}
