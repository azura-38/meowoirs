package com.limanex.meowoirs.data.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import com.limanex.meowoirs.data.local.dao.CatDao
import com.limanex.meowoirs.data.local.dao.MemoryDao
import com.limanex.meowoirs.data.local.entity.CatEntity
import com.limanex.meowoirs.data.local.entity.MemoryEntity

@Database(
    entities = [CatEntity::class, MemoryEntity::class],
    version = 1,
    exportSchema = false
)
abstract class MeowoirsDatabase : RoomDatabase() {
    abstract fun catDao(): CatDao
    abstract fun memoryDao(): MemoryDao

    companion object {
        @Volatile
        private var INSTANCE: MeowoirsDatabase? = null

        fun getInstance(context: Context): MeowoirsDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    MeowoirsDatabase::class.java,
                    "meowoirs_database"
                )
                    .fallbackToDestructiveMigration()
                    .build()
                INSTANCE = instance
                instance
            }
        }
    }
}
