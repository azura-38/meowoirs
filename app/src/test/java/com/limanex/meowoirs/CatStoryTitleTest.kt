package com.limanex.meowoirs

import com.limanex.meowoirs.viewmodel.getCatStoryTitle
import org.junit.Assert.assertEquals
import org.junit.Test

/**
 * Unit tests for Turkish vowel harmony and story title suffix generator.
 */
class CatStoryTitleTest {

    @Test
    fun testVowelHarmonySuffixes() {
        // Consonant ending, 'o' / 'u' -> 'un
        assertEquals("Minnoş'un Hikâyesi", getCatStoryTitle("Minnoş"))
        assertEquals("Pamuk'un Hikâyesi", getCatStoryTitle("Pamuk"))

        // Consonant ending, 'e' / 'i' -> 'in
        assertEquals("Tekir'in Hikâyesi", getCatStoryTitle("Tekir"))
        assertEquals("Zeytin'in Hikâyesi", getCatStoryTitle("Zeytin"))

        // Consonant ending, 'a' / 'ı' -> 'ın
        assertEquals("Duman'ın Hikâyesi", getCatStoryTitle("Duman"))
        assertEquals("Çıtır'ın Hikâyesi", getCatStoryTitle("Çıtır"))

        // Consonant ending, 'ö' / 'ü' -> 'ün
        assertEquals("Kömür'ün Hikâyesi", getCatStoryTitle("Kömür"))

        // Vowel ending, 'a' / 'ı' -> 'nın
        assertEquals("Maya'nın Hikâyesi", getCatStoryTitle("Maya"))

        // Vowel ending, 'e' / 'i' -> 'nin
        assertEquals("Gölge'nin Hikâyesi", getCatStoryTitle("Gölge"))
        assertEquals("Bobi'nin Hikâyesi", getCatStoryTitle("Bobi"))

        // Blank input fallback
        assertEquals("Kedinin Hikâyesi", getCatStoryTitle(""))
        assertEquals("Kedinin Hikâyesi", getCatStoryTitle("   "))
    }
}
