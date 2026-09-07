package com.limanex.meowoirs.ui.screens.profile

import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import com.limanex.meowoirs.R

data class AvatarItem(
    val id: String,
    @DrawableRes val drawableRes: Int,
    @StringRes val descriptionRes: Int
)

object ProfileAvatars {

    val all: List<AvatarItem> = listOf(
        AvatarItem("avatar_warm_cat", R.drawable.avatar_warm_cat, R.string.avatar_desc_warm_cat),
        AvatarItem("avatar_sage_cat", R.drawable.avatar_sage_cat, R.string.avatar_desc_sage_cat),
        AvatarItem("avatar_lavender_cat", R.drawable.avatar_lavender_cat, R.string.avatar_desc_lavender_cat),
        AvatarItem("avatar_curious_cat", R.drawable.avatar_curious_cat, R.string.avatar_desc_curious_cat),
        AvatarItem("avatar_cozy_cat", R.drawable.avatar_cozy_cat, R.string.avatar_desc_cozy_cat),
        AvatarItem("avatar_gentle_paw", R.drawable.avatar_gentle_paw, R.string.avatar_desc_gentle_paw),
        AvatarItem("avatar_star_gazer", R.drawable.avatar_star_gazer, R.string.avatar_desc_star_gazer),
        AvatarItem("avatar_book_cat", R.drawable.avatar_book_cat, R.string.avatar_desc_book_cat),
        AvatarItem("avatar_sunlit_cat", R.drawable.avatar_sunlit_cat, R.string.avatar_desc_sunlit_cat),
        AvatarItem("avatar_whisker_heart", R.drawable.avatar_whisker_heart, R.string.avatar_desc_whisker_heart)
    )

    fun getById(id: String): AvatarItem {
        return all.firstOrNull { it.id == id } ?: all.first()
    }
}
