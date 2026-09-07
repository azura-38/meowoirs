package com.limanex.meowoirs

import android.app.Application
import com.limanex.meowoirs.data.repository.MeowoirsRepository

class MeowoirsApplication : Application() {

    lateinit var repository: MeowoirsRepository
        private set

    override fun onCreate() {
        super.onCreate()
        instance = this
        repository = MeowoirsRepository.getInstance(this)
        com.limanex.meowoirs.ads.AdManager.initialize(this)
    }

    companion object {
        lateinit var instance: MeowoirsApplication
            private set
    }
}
