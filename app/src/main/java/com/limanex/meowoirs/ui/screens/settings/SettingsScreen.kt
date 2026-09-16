package com.limanex.meowoirs.ui.screens.settings

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.widget.Toast
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Check
import androidx.compose.material.icons.outlined.ChevronRight
import androidx.compose.material.icons.outlined.ColorLens
import androidx.compose.material.icons.outlined.Email
import androidx.compose.material.icons.outlined.Info
import androidx.compose.material.icons.outlined.Language
import androidx.compose.material.icons.outlined.Mail
import androidx.compose.material.icons.outlined.Policy
import androidx.compose.material.icons.outlined.PrivacyTip
import androidx.compose.material.icons.outlined.Security
import androidx.compose.material.icons.outlined.Shield
import com.limanex.meowoirs.ui.screens.legal.LegalDocument
import com.limanex.meowoirs.ui.screens.legal.LegalDocumentViewerDialog
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Divider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.heading
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.limanex.meowoirs.BuildConfig
import com.limanex.meowoirs.R
import com.limanex.meowoirs.ads.AdManager
import com.limanex.meowoirs.config.AppConfig
import com.limanex.meowoirs.data.preferences.ThemeMode
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import com.limanex.meowoirs.viewmodel.SettingsViewModel

data class SupportedLanguage(
    val code: String,
    val displayName: String
)

val SupportedLanguages = listOf(
    SupportedLanguage("tr", "Türkçe"),
    SupportedLanguage("en", "English"),
    SupportedLanguage("de", "Deutsch"),
    SupportedLanguage("fr", "Français"),
    SupportedLanguage("es", "Español"),
    SupportedLanguage("it", "Italiano"),
    SupportedLanguage("pt", "Português"),
    SupportedLanguage("nl", "Nederlands"),
    SupportedLanguage("pl", "Polski"),
    SupportedLanguage("ja", "日本語")
)

@Composable
fun SettingsScreen(
    onBack: () -> Unit,
    modifier: Modifier = Modifier,
    viewModel: SettingsViewModel = viewModel(factory = SettingsViewModel.Factory)
) {
    val context = LocalContext.current
    val activity = remember(context) { context.findActivity() }
    val currentTheme by viewModel.themeMode.collectAsState()
    val currentLanguageCode by viewModel.languageCode.collectAsState()

    var showThemeDialog by remember { mutableStateOf(false) }
    var showLanguageDialog by remember { mutableStateOf(false) }
    var showReachUsDialog by remember { mutableStateOf(false) }
    var showPendingLegalDialog by remember { mutableStateOf<String?>(null) }
    var activeLegalDocument by remember { mutableStateOf<LegalDocument?>(null) }

    // 10-tap unlock detector for Hidden Debug Panel (isolated to DEBUG builds)
    val tapDetector = remember { DebugTapDetector(requiredTaps = 10, windowMillis = 4000L) }

    val handleVersionTap = {
        if (BuildConfig.DEBUG) {
            val isUnlocked = tapDetector.onUserTap()
            if (isUnlocked) {
                Toast.makeText(
                    context,
                    context.getString(R.string.debug_panel_unlocked),
                    Toast.LENGTH_SHORT
                ).show()

                try {
                    val intent = Intent().apply {
                        setClassName(context.packageName, "com.limanex.meowoirs.debug.DebugPanelActivity")
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
                    val hostActivity = context.findActivity() ?: activity
                    if (hostActivity != null) {
                        hostActivity.startActivity(intent)
                    } else {
                        context.startActivity(intent)
                    }
                } catch (e: Exception) {
                    android.util.Log.e("SettingsScreen", "Failed to launch DebugPanelActivity", e)
                    Toast.makeText(context, "Debug panel unavailable", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

    // Theme Picker Dialog
    if (showThemeDialog) {
        AlertDialog(
            onDismissRequest = { showThemeDialog = false },
            title = { Text(stringResource(R.string.settings_theme)) },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf(
                        ThemeMode.SYSTEM to stringResource(R.string.theme_system),
                        ThemeMode.LIGHT to stringResource(R.string.theme_light),
                        ThemeMode.DARK to stringResource(R.string.theme_dark)
                    ).forEach { (mode, label) ->
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(48.dp)
                                .clickable(role = Role.RadioButton) {
                                    viewModel.setThemeMode(mode)
                                    showThemeDialog = false
                                },
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            RadioButton(
                                selected = currentTheme == mode,
                                onClick = {
                                    viewModel.setThemeMode(mode)
                                    showThemeDialog = false
                                }
                            )
                            Spacer(modifier = Modifier.width(12.dp))
                            Text(text = label, style = MaterialTheme.typography.bodyLarge)
                        }
                    }
                }
            },
            confirmButton = {},
            dismissButton = {
                TextButton(onClick = { showThemeDialog = false }) {
                    Text(stringResource(R.string.profile_cancel))
                }
            }
        )
    }

    // Language Picker Dialog
    if (showLanguageDialog) {
        AlertDialog(
            onDismissRequest = { showLanguageDialog = false },
            title = { Text(stringResource(R.string.settings_language)) },
            text = {
                Column(
                    modifier = Modifier.verticalScroll(rememberScrollState()),
                    verticalArrangement = Arrangement.spacedBy(4.dp)
                ) {
                    SupportedLanguages.forEach { lang ->
                        val isSelected = currentLanguageCode == lang.code || (currentLanguageCode.isEmpty() && lang.code == "tr")
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(48.dp)
                                .clickable(role = Role.RadioButton) {
                                    viewModel.setLanguageCode(lang.code)
                                    showLanguageDialog = false
                                },
                            verticalAlignment = Alignment.CenterVertically,
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(
                                text = lang.displayName,
                                style = MaterialTheme.typography.bodyLarge,
                                fontWeight = if (isSelected) FontWeight.SemiBold else FontWeight.Normal,
                                color = if (isSelected) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.onSurface
                            )
                            if (isSelected) {
                                Icon(
                                    Icons.Outlined.Check,
                                    contentDescription = null,
                                    tint = MaterialTheme.colorScheme.primary,
                                    modifier = Modifier.size(20.dp)
                                )
                            }
                        }
                    }
                }
            },
            confirmButton = {},
            dismissButton = {
                TextButton(onClick = { showLanguageDialog = false }) {
                    Text(stringResource(R.string.profile_cancel))
                }
            }
        )
    }

    // Reach Us Modal Dialog
    if (showReachUsDialog) {
        AlertDialog(
            onDismissRequest = { showReachUsDialog = false },
            icon = { Icon(Icons.Outlined.Mail, contentDescription = null, tint = MaterialTheme.colorScheme.primary) },
            title = {
                Text(
                    text = stringResource(R.string.reach_us_thank_you_title),
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold
                )
            },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                    Text(
                        text = stringResource(R.string.reach_us_thank_you_desc),
                        style = MaterialTheme.typography.bodyMedium,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )

                    Button(
                        onClick = {
                            showReachUsDialog = false
                            sendEmail(context, AppConfig.MEOWOIRS_SUPPORT_EMAIL, "Meowoirs Suggestion", "")
                        },
                        modifier = Modifier.fillMaxWidth().height(48.dp)
                    ) {
                        Text(stringResource(R.string.reach_us_action_suggestion))
                    }

                    OutlinedButton(
                        onClick = {
                            showReachUsDialog = false
                            val bugBody = "App Version: ${BuildConfig.VERSION_NAME} (${BuildConfig.VERSION_CODE})\nDevice: ${Build.MANUFACTURER} ${Build.MODEL}\nAndroid: ${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})\n\nDescription of issue:\n"
                            sendEmail(context, AppConfig.MEOWOIRS_SUPPORT_EMAIL, "Meowoirs Bug Report", bugBody)
                        },
                        modifier = Modifier.fillMaxWidth().height(48.dp)
                    ) {
                        Text(stringResource(R.string.reach_us_action_bug))
                    }

                    TextButton(
                        onClick = {
                            showReachUsDialog = false
                            sendEmail(context, AppConfig.MEOWOIRS_SUPPORT_EMAIL, "Meowoirs Contact", "")
                        },
                        modifier = Modifier.fillMaxWidth().height(48.dp)
                    ) {
                        Text(stringResource(R.string.reach_us_action_contact))
                    }
                }
            },
            confirmButton = {},
            dismissButton = {
                TextButton(onClick = { showReachUsDialog = false }) {
                    Text(stringResource(R.string.profile_cancel))
                }
            }
        )
    }

    // In-App Legal Document Viewer Dialog
    if (activeLegalDocument != null) {
        LegalDocumentViewerDialog(
            document = activeLegalDocument!!,
            onDismiss = { activeLegalDocument = null }
        )
    }

    // Pending Legal Document Information Sheet
    if (showPendingLegalDialog != null) {
        AlertDialog(
            onDismissRequest = { showPendingLegalDialog = null },
            icon = { Icon(Icons.Outlined.Info, contentDescription = null, tint = MaterialTheme.colorScheme.primary) },
            title = { Text(showPendingLegalDialog ?: "") },
            text = { Text(stringResource(R.string.privacy_pending_desc)) },
            confirmButton = {
                Button(onClick = { showPendingLegalDialog = null }) {
                    Text("Tamam")
                }
            }
        )
    }

    Surface(
        modifier = modifier.fillMaxSize(),
        color = MeowoirsTheme.colors.cream
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(20.dp)
        ) {
            // 1. Görünüm (Appearance)
            SettingsGroupCard(title = stringResource(R.string.settings_section_appearance)) {
                SettingsActionRow(
                    icon = Icons.Outlined.ColorLens,
                    label = stringResource(R.string.settings_theme),
                    value = when (currentTheme) {
                        ThemeMode.LIGHT -> stringResource(R.string.theme_light)
                        ThemeMode.DARK -> stringResource(R.string.theme_dark)
                        ThemeMode.SYSTEM -> stringResource(R.string.theme_system)
                    },
                    onClick = { showThemeDialog = true }
                )
            }

            // 2. Gizlilik ve Yasal (Privacy & Legal / Privacy Center)
            SettingsGroupCard(title = stringResource(R.string.settings_section_privacy_legal)) {
                SettingsActionRow(
                    icon = Icons.Outlined.PrivacyTip,
                    label = stringResource(R.string.settings_privacy_policy),
                    onClick = {
                        activeLegalDocument = LegalDocument.PRIVACY_POLICY
                    }
                )

                Divider(color = MaterialTheme.colorScheme.outlineVariant)

                SettingsActionRow(
                    icon = Icons.Outlined.Policy,
                    label = stringResource(R.string.settings_terms_of_service),
                    onClick = {
                        activeLegalDocument = LegalDocument.TERMS_OF_SERVICE
                    }
                )

                Divider(color = MaterialTheme.colorScheme.outlineVariant)

                SettingsActionRow(
                    icon = Icons.Outlined.Info,
                    label = stringResource(R.string.legal_data_deletion_policy),
                    onClick = {
                        activeLegalDocument = LegalDocument.DATA_DELETION
                    }
                )

                Divider(color = MaterialTheme.colorScheme.outlineVariant)

                SettingsActionRow(
                    icon = Icons.Outlined.Shield,
                    label = stringResource(R.string.legal_third_party_services),
                    onClick = {
                        activeLegalDocument = LegalDocument.THIRD_PARTY_SERVICES
                    }
                )

                Divider(color = MaterialTheme.colorScheme.outlineVariant)

                SettingsActionRow(
                    icon = Icons.Outlined.Policy,
                    label = stringResource(R.string.legal_advertising_consent),
                    onClick = {
                        activeLegalDocument = LegalDocument.ADVERTISING_AND_CONSENT
                    }
                )

                Divider(color = MaterialTheme.colorScheme.outlineVariant)

                SettingsActionRow(
                    icon = Icons.Outlined.Info,
                    label = stringResource(R.string.legal_disclaimer),
                    onClick = {
                        activeLegalDocument = LegalDocument.LEGAL_DISCLAIMER
                    }
                )

                Divider(color = MaterialTheme.colorScheme.outlineVariant)

                SettingsActionRow(
                    icon = Icons.Outlined.Security,
                    label = stringResource(R.string.settings_ad_privacy),
                    onClick = {
                        if (activity != null) {
                            AdManager.showPrivacyOptions(activity) { isAvailable, _ ->
                                if (!isAvailable) {
                                    Toast.makeText(context, context.getString(R.string.ump_not_required), Toast.LENGTH_SHORT).show()
                                }
                            }
                        }
                    }
                )
            }

            // 3. Dil (Language)
            SettingsGroupCard(title = stringResource(R.string.settings_section_language)) {
                val currentLangName = SupportedLanguages.firstOrNull { it.code == currentLanguageCode }?.displayName
                    ?: SupportedLanguages.first().displayName
                SettingsActionRow(
                    icon = Icons.Outlined.Language,
                    label = stringResource(R.string.settings_language),
                    value = currentLangName,
                    onClick = { showLanguageDialog = true }
                )
            }

            // 4. Bize Ulaşın (Reach Us)
            SettingsGroupCard(title = stringResource(R.string.settings_section_reach_us)) {
                SettingsActionRow(
                    icon = Icons.Outlined.Email,
                    label = stringResource(R.string.settings_reach_us),
                    onClick = { showReachUsDialog = true }
                )
            }

            // 5. Uygulama (Application Info & 10-tap debug unlock)
            SettingsGroupCard(title = stringResource(R.string.settings_section_app)) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .heightIn(min = 56.dp)
                        .clickable(
                            interactionSource = remember { MutableInteractionSource() },
                            indication = null,
                            onClick = handleVersionTap
                        )
                        .padding(horizontal = 16.dp, vertical = 8.dp),
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalArrangement = Arrangement.spacedBy(14.dp)
                ) {
                    Image(
                        painter = painterResource(R.drawable.ic_meowoirs_logo),
                        contentDescription = "Meowoirs Logo",
                        modifier = Modifier
                            .size(44.dp)
                            .clip(RoundedCornerShape(10.dp))
                    )
                    Column {
                        Text(
                            text = "Meowoirs",
                            style = MaterialTheme.typography.bodyLarge,
                            fontWeight = FontWeight.Medium
                        )
                        Text(
                            text = stringResource(R.string.version_build_format, BuildConfig.VERSION_NAME, BuildConfig.VERSION_CODE),
                            style = MaterialTheme.typography.bodySmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
private fun SettingsGroupCard(
    title: String,
    content: @Composable () -> Unit
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(
            text = title,
            style = MaterialTheme.typography.labelLarge,
            fontWeight = FontWeight.Bold,
            color = MaterialTheme.colorScheme.primary,
            modifier = Modifier
                .padding(horizontal = 4.dp)
                .semantics { heading() }
        )

        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(16.dp),
            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
            elevation = CardDefaults.cardElevation(defaultElevation = 1.dp)
        ) {
            Column {
                content()
            }
        }
    }
}

@Composable
private fun SettingsActionRow(
    icon: ImageVector,
    label: String,
    value: String? = null,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
            .clickable(onClick = onClick)
            .padding(horizontal = 16.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
                modifier = Modifier.size(22.dp)
            )
            Spacer(modifier = Modifier.width(14.dp))
            Text(
                text = label,
                style = MaterialTheme.typography.bodyLarge,
                color = MaterialTheme.colorScheme.onSurface
            )
        }

        Row(verticalAlignment = Alignment.CenterVertically) {
            if (value != null) {
                Text(
                    text = value,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant
                )
                Spacer(modifier = Modifier.width(6.dp))
            }
            Icon(
                imageVector = Icons.Outlined.ChevronRight,
                contentDescription = null,
                tint = MaterialTheme.colorScheme.outline,
                modifier = Modifier.size(20.dp)
            )
        }
    }
}

private fun sendEmail(context: Context, to: String, subject: String, body: String) {
    val intent = Intent(Intent.ACTION_SENDTO).apply {
        data = Uri.parse("mailto:")
        putExtra(Intent.EXTRA_EMAIL, arrayOf(to))
        putExtra(Intent.EXTRA_SUBJECT, subject)
        if (body.isNotBlank()) {
            putExtra(Intent.EXTRA_TEXT, body)
        }
    }
    try {
        context.startActivity(intent)
    } catch (_: ActivityNotFoundException) {
        Toast.makeText(context, context.getString(R.string.reach_us_no_email_app), Toast.LENGTH_SHORT).show()
    }
}

private fun openUrl(context: Context, url: String) {
    try {
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
        context.startActivity(intent)
    } catch (_: Exception) {
        Toast.makeText(context, "Tarayıcı açılamadı", Toast.LENGTH_SHORT).show()
    }
}

private tailrec fun Context.findActivity(): Activity? = when (this) {
    is Activity -> this
    is ContextWrapper -> baseContext?.findActivity()
    else -> null
}

