package com.example.kmmsandbox.android

import android.app.Application
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.kmmsandbox.shared.entity.RocketLaunch
import com.example.kmmsandbox.shared.SpaceXSDK
import com.example.kmmsandbox.shared.cache.DatabaseDriverFactory
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class MainViewModel(application: Application) : ViewModel() {
    var rocketLaunches: MutableStateFlow<MutableList<RocketLaunch>> =
        MutableStateFlow(mutableListOf())

    private val sdk = SpaceXSDK(DatabaseDriverFactory(application.applicationContext))

    init {
        viewModelScope.launch {
            getAll()
        }
    }

    private suspend fun getAll() {
        val data = sdk.getLaunches(false)
        rocketLaunches.update { data.toMutableList() }
    }
}
