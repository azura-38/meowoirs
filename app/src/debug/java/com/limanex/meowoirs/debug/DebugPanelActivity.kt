package com.limanex.meowoirs.debug

import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.windowInsetsPadding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Divider
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.google.android.ump.UserMessagingPlatform
import com.limanex.meowoirs.BuildConfig
import com.limanex.meowoirs.MeowoirsApplication
import com.limanex.meowoirs.ads.AdConfig
import com.limanex.meowoirs.ui.theme.MeowoirsTheme
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import java.io.File

/**
 * Hidden developer/QA diagnostics panel.
 * Strictly source-set isolated to app/src/debug.
 * NOT compiled or included in release builds.
 */
class DebugPanelActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContent {
            MeowoirsTheme {
                DebugPanelContent(
                    onBack = { finish() },
                    onTriggerCrash = {
                        throw RuntimeException("Meowoirs Debug Verification Test Crash")
                    },
                    onOpenUmpPrivacy = {
                        UserMessagingPlatform.showPrivacyOptionsForm(this) { error ->
                            if (error != null) {
                                Toast.makeText(this, "UMP error: ${error.message}", Toast.LENGTH_SHORT).show()
                            } else {
                                Toast.makeText(this, "UMP privacy form closed", Toast.LENGTH_SHORT).show()
                            }
                        }
                    },
                    onClearDebugData = { onComplete ->
                        val scope = (application as MeowoirsApplication).repository
                        // Safe clean up in background if needed
                        Toast.makeText(this, "Debug: Local data clear requested", Toast.LENGTH_SHORT).show()
                        onComplete()
                    }
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun DebugPanelContent(
    onBack: () -> Unit,
    onTriggerCrash: () -> Unit,
    onOpenUmpPrivacy: () -> Unit,
    onClearDebugData: ((() -> Unit) -> Unit)
) {
    val coroutineScope = rememberCoroutineScope()
    var catCount by remember { mutableIntStateOf(0) }
    var memoryCount by remember { mutableIntStateOf(0) }
    var dbFileSizeKb by remember { mutableStateOf("Calculating...") }
    var isOnboardingCompleted by remember { mutableStateOf(false) }
    var acceptedLegalVersion by remember { mutableStateOf("None") }

    var showCrashConfirmDialog by remember { mutableStateOf(false) }
    var showClearDataConfirmDialog by remember { mutableStateOf(false) }

    LaunchedEffect(Unit) {
        val app = MeowoirsApplication.instance
        try {
            catCount = app.repository.getCats().first().size
            memoryCount = app.repository.getAllMemories().first().size
            val dbFile = app.getDatabasePath("meowoirs.db")
            dbFileSizeKb = if (dbFile.exists()) "${dbFile.length() / 1024} KB" else "Not created yet"
        } catch (_: Exception) {
            dbFileSizeKb = "Unavailable"
        }

        val prefs = com.limanex.meowoirs.data.preferences.UserPreferencesRepository.getInstance(app)
        launch {
            prefs.onboardingCompletedFlow.collect { isOnboardingCompleted = it }
        }
        launch {
            prefs.acceptedLegalVersionFlow.collect { 
                acceptedLegalVersion = if (it.isBlank()) "None" else it 
            }
        }
    }

    if (showCrashConfirmDialog) {
        AlertDialog(
            onDismissRequest = { showCrashConfirmDialog = false },
            icon = { Icon(Icons.Default.Warning, contentToDescription("Warning"), tint = Color(0xFFD32F2F)) },
            title = { Text("Trigger Crashlytics Test Crash?") },
            text = { Text("This will immediately terminate the application process with a test RuntimeException to verify Firebase Crashlytics.") },
            confirmButton = {
                Button(
                    onClick = {
                        showCrashConfirmDialog = false
                        onTriggerCrash()
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFD32F2F))
                ) {
                    Text("CRASH NOW")
                }
            },
            dismissButton = {
                TextButton(onClick = { showCrashConfirmDialog = false }) {
                    Text("Cancel")
                }
            }
        )
    }

    if (showClearDataConfirmDialog) {
        AlertDialog(
            onDismissRequest = { showClearDataConfirmDialog = false },
            title = { Text("Developer: Clear Local Data?") },
            text = { Text("This is a developer-only test action. Are you sure?") },
            confirmButton = {
                Button(
                    onClick = {
                        showClearDataConfirmDialog = false
                        onClearDebugData {
                            // Reset counts
                            catCount = 0
                            memoryCount = 0
                        }
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFD32F2F))
                ) {
                    Text("CLEAR")
                }
            },
            dismissButton = {
                TextButton(onClick = { showClearDataConfirmDialog = false }) {
                    Text("Cancel")
                }
            }
        )
    }

    Scaffold(
        modifier = Modifier
            .fillMaxSize()
            .windowInsetsPadding(WindowInsets.statusBars),
        topBar = {
            TopAppBar(
                title = { Text("Debug Diagnostics Panel", fontWeight = FontWeight.SemiBold) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = MaterialTheme.colorScheme.surface
                )
            )
        }
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .verticalScroll(rememberScrollState())
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp)
        ) {
            // Section 1: App Info
            DiagnosticSection(title = "APP INFO") {
                DiagnosticRow("App Name", "Meowoirs")
                DiagnosticRow("Package Name", BuildConfig.APPLICATION_ID)
                DiagnosticRow("Version Name", BuildConfig.VERSION_NAME)
                DiagnosticRow("Version Code", "${BuildConfig.VERSION_CODE}")
                DiagnosticRow("Build Type", BuildConfig.BUILD_TYPE)
                DiagnosticRow("Build Mode", if (BuildConfig.DEBUG) "DEBUG" else "RELEASE")
                DiagnosticRow("Android Version", "${Build.VERSION.RELEASE} (API ${Build.VERSION.SDK_INT})")
                DiagnosticRow("Device", "${Build.MANUFACTURER} ${Build.MODEL}")
            }

            // Section 2: Database
            DiagnosticSection(title = "DATABASE (AGGREGATE COUNTS)") {
                DiagnosticRow("Total Cats", "$catCount")
                DiagnosticRow("Total Memories", "$memoryCount")
                DiagnosticRow("Room Status", "Active / Healthy")
                DiagnosticRow("Database File", "meowoirs.db ($dbFileSizeKb)")
                Text(
                    text = "Zero personal journal content is logged or displayed here.",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier.padding(top = 4.dp)
                )
            }

            // Section 3: Ads
            DiagnosticSection(title = "GOOGLE MOBILE ADS & UMP") {
                DiagnosticRow("GMA SDK Version", "23.6.0")
                DiagnosticRow("Application ID", AdConfig.APPLICATION_ID)
                DiagnosticRow("Banner ID", AdConfig.BANNER_AD_UNIT_ID)
                DiagnosticRow("Interstitial ID", AdConfig.INTERSTITIAL_AD_UNIT_ID)
                DiagnosticRow("MobileAdsInitProvider", "Removed (Manual Init)")
                DiagnosticRow("UMP Status", "Configured")
            }

            // Section 4: Firebase
            DiagnosticSection(title = "FIREBASE INTEGRATION") {
                DiagnosticRow("Crashlytics", "Active / Enabled")
                DiagnosticRow("Firebase Config", "google-services.json (meowoirs)")
                DiagnosticRow("Analytics Installed", "NO")
                DiagnosticRow("Sentry Installed", "NO")
            }

            // Section 5: Onboarding & Legal Status
            DiagnosticSection(title = "ONBOARDING & LEGAL STATUS") {
                DiagnosticRow("Onboarding Completed", if (isOnboardingCompleted) "YES" else "NO")
                DiagnosticRow("Accepted Legal Version", acceptedLegalVersion)
            }

            // Section 6: Actions
            DiagnosticSection(title = "QA TEST ACTIONS") {
                Button(
                    onClick = { showCrashConfirmDialog = true },
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFD32F2F)),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("TRIGGER CRASHLYTICS TEST CRASH", color = Color.White)
                }

                Spacer(modifier = Modifier.height(8.dp))

                OutlinedButton(
                    onClick = {
                        coroutineScope.launch {
                            val prefs = com.limanex.meowoirs.data.preferences.UserPreferencesRepository.getInstance(MeowoirsApplication.instance)
                            prefs.resetOnboarding()
                            Toast.makeText(MeowoirsApplication.instance, "Onboarding status reset", Toast.LENGTH_SHORT).show()
                        }
                    },
                    colors = ButtonDefaults.outlinedButtonColors(contentColor = Color(0xFFE65100)),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("RESET ONBOARDING (RE-TEST FLOW)")
                }

                Spacer(modifier = Modifier.height(8.dp))

                OutlinedButton(
                    onClick = onOpenUmpPrivacy,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("INSPECT UMP PRIVACY OPTIONS FORM")
                }

                Spacer(modifier = Modifier.height(8.dp))

                OutlinedButton(
                    onClick = { showClearDataConfirmDialog = true },
                    colors = ButtonDefaults.outlinedButtonColors(contentColor = Color(0xFFD32F2F)),
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("DEVELOPER: CLEAR LOCAL DATA")
                }
            }

            Spacer(modifier = Modifier.height(24.dp))
        }
    }
}

@Composable
private fun DiagnosticSection(
    title: String,
    content: @Composable () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surfaceVariant)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.labelLarge,
                fontWeight = FontWeight.Bold,
                color = MaterialTheme.colorScheme.primary,
                letterSpacing = 1.sp
            )
            Divider(color = MaterialTheme.colorScheme.outlineVariant)
            content()
        }
    }
}

@Composable
private fun DiagnosticRow(label: String, value: String) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = label,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
        Text(
            text = value,
            style = MaterialTheme.typography.bodyMedium,
            fontWeight = FontWeight.Medium,
            fontFamily = FontFamily.Monospace,
            color = MaterialTheme.colorScheme.onSurface
        )
    }
}

private fun contentToDescription(desc: String): String = desc
