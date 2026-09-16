import '../../core/config/app_config.dart';
import '../../core/localization/app_localizations.dart';

/// Enumeration of available in-app legal documents, their bundled asset paths,
/// and corresponding public authoritative web URLs.
/// Direct parity with LegalDocument.kt.
enum LegalDocument {
  privacyPolicy(
    title: 'Gizlilik Politikası',
    assetPath: 'assets/legal/PRIVACY_POLICY.txt',
    webUrl: AppConfig.privacyPolicyUrl,
  ),
  termsOfService(
    title: 'Kullanım Koşulları',
    assetPath: 'assets/legal/TERMS_OF_SERVICE.txt',
    webUrl: AppConfig.termsOfServiceUrl,
  ),
  dataDeletion(
    title: 'Veri Silme Politikası',
    assetPath: 'assets/legal/DATA_DELETION_POLICY.txt',
    webUrl: AppConfig.privacyPolicyUrl,
  ),
  thirdPartyServices(
    title: 'Üçüncü Taraf Hizmetleri',
    assetPath: 'assets/legal/THIRD_PARTY_SERVICES.txt',
    webUrl: AppConfig.privacyPolicyUrl,
  ),
  advertisingAndConsent(
    title: 'Reklam ve İzin Politikası',
    assetPath: 'assets/legal/ADVERTISING_AND_CONSENT.txt',
    webUrl: AppConfig.privacyPolicyUrl,
  ),
  legalDisclaimer(
    title: 'Yasal Uyarı',
    assetPath: 'assets/legal/LEGAL_DISCLAIMER.txt',
    webUrl: AppConfig.termsOfServiceUrl,
  );

  const LegalDocument({
    required this.title,
    required this.assetPath,
    required this.webUrl,
  });

  final String title;
  final String assetPath;
  final String webUrl;

  String localizedTitle(AppLocalizations l10n) {
    switch (this) {
      case LegalDocument.privacyPolicy:
        return l10n.legalTitlePrivacyPolicy;
      case LegalDocument.termsOfService:
        return l10n.legalTitleTermsOfService;
      case LegalDocument.dataDeletion:
        return l10n.legalTitleDataDeletion;
      case LegalDocument.thirdPartyServices:
        return l10n.legalTitleThirdPartyServices;
      case LegalDocument.advertisingAndConsent:
        return l10n.legalTitleAdvertisingAndConsent;
      case LegalDocument.legalDisclaimer:
        return l10n.legalTitleLegalDisclaimer;
    }
  }
}
