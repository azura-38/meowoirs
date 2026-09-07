package com.limanex.meowoirs

import com.limanex.meowoirs.ui.screens.profile.ProfileAvatars
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Test

class ProfileAvatarsTest {

    @Test
    fun testCuratedAvatarsCount() {
        assertEquals(10, ProfileAvatars.all.size)
    }

    @Test
    fun testGetAvatarByIdKnown() {
        val avatar = ProfileAvatars.getById("avatar_sage_cat")
        assertNotNull(avatar)
        assertEquals("avatar_sage_cat", avatar.id)
    }

    @Test
    fun testGetAvatarByIdFallback() {
        val fallback = ProfileAvatars.getById("non_existent_avatar")
        assertNotNull(fallback)
        assertEquals("avatar_warm_cat", fallback.id)
    }
}
