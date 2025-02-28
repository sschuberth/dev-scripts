#!/usr/bin/env kotlin

@file:DependsOn("com.github.ajalt.clikt:clikt-jvm:5.0.3")
@file:DependsOn("org.openapitools:openapi-generator:7.12.0")

import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.core.Context
import com.github.ajalt.clikt.core.context
import com.github.ajalt.clikt.core.main
import com.github.ajalt.clikt.output.MordantHelpFormatter
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.options.default
import com.github.ajalt.clikt.parameters.options.option
import com.github.ajalt.clikt.parameters.types.file
import com.github.ajalt.mordant.rendering.Theme

import java.io.File

import org.openapitools.codegen.DefaultGenerator
import org.openapitools.codegen.config.CodegenConfigurator

object : CliktCommand(name = __FILE__.name) {
    val schema by argument()

    val outputDirectory by option()
        .file(mustExist = false, canBeFile = false, canBeDir = true, mustBeWritable = true, mustBeReadable = false, canBeSymlink = true)
        .default(File("."))

    init {
        context {
            helpFormatter = { MordantHelpFormatter(context = it, "*", showDefaultValues = true) }
        }
    }

    override fun help(context: Context): String =
        "This command takes a JSON schema (either a URI or a file) as the input and produces matching code for Kotlin data classes as the output."

    override fun run() {
        val config = CodegenConfigurator().apply {
            setInputSpec(schema)
            setOutputDir(outputDirectory.absolutePath)
            setGeneratorName("kotlin")
            setLibrary("jvm-retrofit2")
            addAdditionalProperty("useCoroutines", "true")
            addAdditionalProperty("serializationLibrary", "kotlinx_serialization")
        }

        val generator = DefaultGenerator().apply {
            opts(config.toClientOptInput())
        }

        runCatching {
            generator.generate()
        }.onFailure {
            echo(Theme.Default.danger(it.message.orEmpty()))
        }
    }
}.main(args)
