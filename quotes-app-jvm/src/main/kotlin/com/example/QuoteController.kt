package com.example

import io.micronaut.http.annotation.*

@Controller("/quotes")
class QuoteController {

    private val quotes = listOf(
        "Talk is cheap. Show me the code.",
        "Programs must be written for people to read.",
        "Simplicity is the soul of efficiency."
    )

    @Get("/")
    fun all(): List<String> = quotes

    @Get("/{index}")
    fun byIndex(index: Int): String = quotes.getOrNull(index) ?: "Quote not found"
}

