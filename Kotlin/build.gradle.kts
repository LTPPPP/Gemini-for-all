plugins {
    kotlin("jvm") version "1.9.0"
    application
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.15.2")
    implementation("io.github.cdimascio:dotenv-kotlin:6.4.1")
}

application {
    mainClass.set("com.example.GeminiChatKt")
}
