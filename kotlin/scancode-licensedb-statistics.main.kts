#!/bin/sh

///bin/true <<EOC
/*
EOC
kotlinc -script -Xplugin="$(dirname $(realpath $(which kotlinc)))/../lib/kotlinx-serialization-compiler-plugin.jar" "$0" "$@"
exit $?
*/

// The above is a work-around for https://youtrack.jetbrains.com/issue/KT-47384.

@file:DependsOn("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.3")

import java.net.URL

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonNamingStrategy

val SCANCODE_DB_INDEX_JSON_URL = "https://scancode-licensedb.aboutcode.org/index.json"

val json = Json {
    namingStrategy = JsonNamingStrategy.SnakeCase
}

@Serializable
data class License(
    val licenseKey: String,
    val category: String,
    val spdxLicenseKey: String? = null,
    val otherSpdxLicenseKeys: List<String> = emptyList(),
    val isException: Boolean,
    val isDeprecated: Boolean,
    val json: String,
    val yaml: String,
    val html: String,
    val license: String
)

val jsonString = URL(SCANCODE_DB_INDEX_JSON_URL).readText()

val licenses = json.decodeFromString<List<License>>(jsonString)

val expections = licenses.filter { it.isException }

val (exceptionsWithSpdxIds, exceptionsWithoutSpdxIds) = expections.partition { it.spdxLicenseKey != null }

if (exceptionsWithoutSpdxIds.isNotEmpty()) {
    println("The following exception(s) have no valid SPDX ID:")

    exceptionsWithoutSpdxIds.forEach { println(it.licenseKey) }

    println()
}

val (licenseRefExceptions, spdxExceptions, ) = exceptionsWithSpdxIds.partition { it.spdxLicenseKey?.startsWith("LicenseRef-") == true }

if (licenseRefExceptions.isNotEmpty()) {
    // If it is a "LicenseRef-" exception, it must also contain the "scancode-" namespace.
    check(licenseRefExceptions.all { it.spdxLicenseKey?.startsWith("LicenseRef-scancode-") == true })

    println("Count of exception terms:")

    val exceptionTerms = licenseRefExceptions
        .mapNotNull { it.spdxLicenseKey }
        .flatMap { it.removePrefix("LicenseRef-scancode-").split('-') }

    val termsStats = exceptionTerms.groupingBy { it }.eachCount().toList().sortedByDescending { it.second }

    termsStats.forEach { (term, count) ->
        println("$term: $count")
    }

    println()
}
