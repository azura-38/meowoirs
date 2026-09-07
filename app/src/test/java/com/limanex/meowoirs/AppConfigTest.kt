package com.limanex.meowoirs

import com.limanex.meowoirs.config.AppConfig
import org.junit.Assert.assertNotNull
import org.junit.Test

class AppConfigTest {

    @Test
    fun testCentralizedConfigConstantsExist() {
        assertNotNull(AppConfig.MEOWOIRS_SUPPORT_EMAIL)
        assertNotNull(AppConfig.PRIVACY_POLICY_URL)
        assertNotNull(AppConfig.TERMS_OF_SERVICE_URL)
    }
}
