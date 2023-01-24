package com.example.kmmsandbox

import io.ktor.client.HttpClient
import io.ktor.client.call.body
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.request.get
import io.ktor.serialization.kotlinx.json.json
import kotlinx.serialization.json.Json

class Greeting {
    private val platform: Platform = getPlatform()

    fun greet(): String {
        return "There are only ${daysUntilNewYear()} days left until New Year!"
    }

    @Throws(Exception::class)
    suspend fun greeting(): String {
        val rockets: List<RocketLaunch> =
            httpClient.get("https://api.spacexdata.com/v4/launches").body()
        val lastSuccessLaunch = rockets.last { it.launchSuccess == true }
        return "The last successful launch was ${lastSuccessLaunch.launchDateUTC} 🚀"
    }

    private val httpClient = HttpClient {
        install(ContentNegotiation) {
            json(Json {
//                prettyPrint = true
//                isLenient = true
                ignoreUnknownKeys = true
            })
        }
    }
}
