#!/usr/bin/env kotlin

@file:DependsOn("com.github.ajalt.clikt:clikt-jvm:5.0.3")
@file:DependsOn("net.pwall.json:json-kotlin-schema-codegen:0.116")

import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.core.context
import com.github.ajalt.clikt.core.main
import com.github.ajalt.clikt.output.MordantHelpFormatter
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.options.default
import com.github.ajalt.clikt.parameters.options.option
import com.github.ajalt.clikt.parameters.types.file
import com.github.ajalt.mordant.rendering.Theme

import java.io.File
import java.net.URI

import net.pwall.json.schema.codegen.CodeGenerator

object : CliktCommand(name = __FILE__.name) {
    val schema by argument()

    val packageName by option()
        .default("com.example")

    val outputDirectory by option()
        .file(mustExist = false, canBeFile = false, canBeDir = true, mustBeWritable = true, mustBeReadable = false, canBeSymlink = true)
        .default(File("."))

    init {
        context {
            helpFormatter = { MordantHelpFormatter(context = it, "*", showDefaultValues = true) }
        }
    }

    override fun run() {
        val schemaUri = URI.create(schema).takeIf { it.isAbsolute } ?: File(schema).toURI()

        val codeGenerator = CodeGenerator().apply {
            basePackageName = packageName
            baseDirectoryName = outputDirectory.path
        }

        runCatching {
            codeGenerator.generate(schemaUri)
        }.onFailure {
            echo(Theme.Default.danger(it.message.orEmpty()))
        }
    }
}.main(args)
