package com.example.kmmsandbox

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform