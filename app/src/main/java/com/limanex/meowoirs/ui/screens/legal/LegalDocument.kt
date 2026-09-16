package com.limanex.meowoirs.ui.screens.legal

import androidx.annotation.StringRes
import com.limanex.meowoirs.R
import com.limanex.meowoirs.config.AppConfig

/**
 * Enumeration of available in-app legal documents, their bundled asset paths,
 * and corresponding public authoritative web URLs.
 */
enum class LegalDocument(
    @StringRes val titleRes: Int,
    val assetFileName: String,
    val webUrl: String
) {
    PRIVACY_POLICY(
        titleRes = R.string.settings_privacy_policy,
        assetFileName = "legal/PRIVACY_POLICY.txt",
        webUrl = AppConfig.PRIVACY_POLICY_URL
    ),
    TERMS_OF_SERVICE(
        titleRes = R.string.settings_terms_of_service,
        assetFileName = "legal/TERMS_OF_SERVICE.txt",
        webUrl = AppConfig.TERMS_OF_SERVICE_URL
    ),
    DATA_DELETION(
        titleRes = R.string.legal_data_deletion_policy,
        assetFileName = "legal/DATA_DELETION_POLICY.txt",
        webUrl = AppConfig.PRIVACY_POLICY_URL
    ),
    THIRD_PARTY_SERVICES(
        titleRes = R.string.legal_third_party_services,
        assetFileName = "legal/THIRD_PARTY_SERVICES.txt",
        webUrl = AppConfig.PRIVACY_POLICY_URL
    ),
    ADVERTISING_AND_CONSENT(
        titleRes = R.string.legal_advertising_consent,
        assetFileName = "legal/ADVERTISING_AND_CONSENT.txt",
        webUrl = AppConfig.PRIVACY_POLICY_URL
    ),
    LEGAL_DISCLAIMER(
        titleRes = R.string.legal_disclaimer,
        assetFileName = "legal/LEGAL_DISCLAIMER.txt",
        webUrl = AppConfig.TERMS_OF_SERVICE_URL
    )
}
