import org.jetbrains.kotlin.gradle.tasks.KotlinCompile



plugins {
    kotlin("jvm") version "1.7.20"
    id("com.github.johnrengelman.shadow") version "7.1.2"
}

group = "no.item"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

dependencies {
    implementation("com.amazonaws:aws-lambda-java-core:1.2.1")
    implementation("com.amazonaws:aws-lambda-java-events:3.11.0")
    implementation("com.slack.api:slack-api-client:1.27.2")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.13.4")
    // https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-sns
    implementation("com.amazonaws:aws-java-sdk-sns:1.12.389")
    implementation("com.google.code.gson:gson:2.9.0")

    testImplementation(kotlin("test"))
}

tasks.test {
    useJUnitPlatform()
}

tasks.withType<KotlinCompile> {
    kotlinOptions.jvmTarget = "1.8"
}
