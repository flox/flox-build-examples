plugins {
    id("io.micronaut.application") version "4.2.0"
    id("org.jetbrains.kotlin.jvm") version "1.9.22"
    id("org.jetbrains.kotlin.kapt") version "1.9.22"
    id("com.github.johnrengelman.shadow") version "8.1.1"

}

tasks {
    build {
        dependsOn(shadowJar)
    }
}

micronaut {
    version("4.2.0")
    runtime("netty")
    testRuntime("junit5")
    processing {
        incremental(true)
        annotations("com.example.*")
    }
}

application {
    mainClass.set("com.example.Application")
}

java {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
}

repositories {
    mavenCentral()
}

dependencies {
    // Micronaut core
    implementation("io.micronaut:micronaut-runtime")
    implementation("io.micronaut.kotlin:micronaut-kotlin-runtime")
    implementation("io.micronaut:micronaut-http-server-netty")
    implementation("io.micronaut:micronaut-inject-java") // <-- required even in Kotlin
		implementation("io.micronaut:micronaut-jackson-databind")
		implementation("com.fasterxml.jackson.module:jackson-module-kotlin")


    // Annotations
    implementation("jakarta.annotation:jakarta.annotation-api")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    // Logging
    runtimeOnly("ch.qos.logback:logback-classic")

    // Test support
    testImplementation("io.micronaut.test:micronaut-test-junit5")
    testImplementation("io.micronaut:micronaut-http-client")
    testImplementation("org.junit.jupiter:junit-jupiter-api")
    testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine")
}

