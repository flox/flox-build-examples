package com.example

import io.micronaut.http.client.HttpClient
import io.micronaut.runtime.server.EmbeddedServer
import io.micronaut.test.extensions.junit5.annotation.MicronautTest
import jakarta.inject.Inject
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test

@MicronautTest
class QuoteControllerTest {

    @Inject
    lateinit var server: EmbeddedServer

    @Test
    fun testQuoteList() {
        val client = HttpClient.create(server.url)
        val response: List<*> = client.toBlocking().retrieve("/quotes", List::class.java)
        assertTrue(response.isNotEmpty())
        client.close()
    }

    @Test
    fun testSingleQuote() {
        val client = HttpClient.create(server.url)
        val response = client.toBlocking().retrieve("/quotes/1")
        assertEquals("Programs must be written for people to read.", response)
        client.close()
    }

    @Test
    fun contextLoads() {
        assertTrue(true)
    }
}

