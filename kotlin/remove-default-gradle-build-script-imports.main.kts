#!/usr/bin/env kotlin

@file:DependsOn("com.github.ajalt.clikt:clikt-jvm:4.2.2")

import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.core.context
import com.github.ajalt.clikt.output.MordantHelpFormatter
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.options.default
import com.github.ajalt.clikt.parameters.options.option
import com.github.ajalt.clikt.parameters.options.split
import com.github.ajalt.clikt.parameters.types.file
import com.github.ajalt.mordant.rendering.Theme

// See https://docs.gradle.org/current/userguide/writing_build_scripts.html#script-default-imports.
private val defaultImports = setOf(
    "import org.gradle.*",
    "import org.gradle.api.*",
    "import org.gradle.api.artifacts.*",
    "import org.gradle.api.artifacts.component.*",
    "import org.gradle.api.artifacts.dsl.*",
    "import org.gradle.api.artifacts.ivy.*",
    "import org.gradle.api.artifacts.maven.*",
    "import org.gradle.api.artifacts.query.*",
    "import org.gradle.api.artifacts.repositories.*",
    "import org.gradle.api.artifacts.result.*",
    "import org.gradle.api.artifacts.transform.*",
    "import org.gradle.api.artifacts.type.*",
    "import org.gradle.api.artifacts.verification.*",
    "import org.gradle.api.attributes.*",
    "import org.gradle.api.attributes.java.*",
    "import org.gradle.api.attributes.plugin.*",
    "import org.gradle.api.cache.*",
    "import org.gradle.api.capabilities.*",
    "import org.gradle.api.component.*",
    "import org.gradle.api.configuration.*",
    "import org.gradle.api.credentials.*",
    "import org.gradle.api.distribution.*",
    "import org.gradle.api.distribution.plugins.*",
    "import org.gradle.api.execution.*",
    "import org.gradle.api.file.*",
    "import org.gradle.api.flow.*",
    "import org.gradle.api.initialization.*",
    "import org.gradle.api.initialization.definition.*",
    "import org.gradle.api.initialization.dsl.*",
    "import org.gradle.api.initialization.resolve.*",
    "import org.gradle.api.invocation.*",
    "import org.gradle.api.java.archives.*",
    "import org.gradle.api.jvm.*",
    "import org.gradle.api.launcher.cli.*",
    "import org.gradle.api.logging.*",
    "import org.gradle.api.logging.configuration.*",
    "import org.gradle.api.model.*",
    "import org.gradle.api.plugins.*",
    "import org.gradle.api.plugins.antlr.*",
    "import org.gradle.api.plugins.catalog.*",
    "import org.gradle.api.plugins.jvm.*",
    "import org.gradle.api.plugins.quality.*",
    "import org.gradle.api.plugins.scala.*",
    "import org.gradle.api.problems.*",
    "import org.gradle.api.provider.*",
    "import org.gradle.api.publish.*",
    "import org.gradle.api.publish.ivy.*",
    "import org.gradle.api.publish.ivy.plugins.*",
    "import org.gradle.api.publish.ivy.tasks.*",
    "import org.gradle.api.publish.maven.*",
    "import org.gradle.api.publish.maven.plugins.*",
    "import org.gradle.api.publish.maven.tasks.*",
    "import org.gradle.api.publish.plugins.*",
    "import org.gradle.api.publish.tasks.*",
    "import org.gradle.api.reflect.*",
    "import org.gradle.api.reporting.*",
    "import org.gradle.api.reporting.components.*",
    "import org.gradle.api.reporting.dependencies.*",
    "import org.gradle.api.reporting.dependents.*",
    "import org.gradle.api.reporting.model.*",
    "import org.gradle.api.reporting.plugins.*",
    "import org.gradle.api.resources.*",
    "import org.gradle.api.services.*",
    "import org.gradle.api.specs.*",
    "import org.gradle.api.tasks.*",
    "import org.gradle.api.tasks.ant.*",
    "import org.gradle.api.tasks.application.*",
    "import org.gradle.api.tasks.bundling.*",
    "import org.gradle.api.tasks.compile.*",
    "import org.gradle.api.tasks.diagnostics.*",
    "import org.gradle.api.tasks.diagnostics.configurations.*",
    "import org.gradle.api.tasks.incremental.*",
    "import org.gradle.api.tasks.javadoc.*",
    "import org.gradle.api.tasks.options.*",
    "import org.gradle.api.tasks.scala.*",
    "import org.gradle.api.tasks.testing.*",
    "import org.gradle.api.tasks.testing.junit.*",
    "import org.gradle.api.tasks.testing.junitplatform.*",
    "import org.gradle.api.tasks.testing.testng.*",
    "import org.gradle.api.tasks.util.*",
    "import org.gradle.api.tasks.wrapper.*",
    "import org.gradle.api.toolchain.management.*",
    "import org.gradle.authentication.*",
    "import org.gradle.authentication.aws.*",
    "import org.gradle.authentication.http.*",
    "import org.gradle.build.event.*",
    "import org.gradle.buildinit.*",
    "import org.gradle.buildinit.plugins.*",
    "import org.gradle.buildinit.tasks.*",
    "import org.gradle.caching.*",
    "import org.gradle.caching.configuration.*",
    "import org.gradle.caching.http.*",
    "import org.gradle.caching.local.*",
    "import org.gradle.concurrent.*",
    "import org.gradle.external.javadoc.*",
    "import org.gradle.ide.visualstudio.*",
    "import org.gradle.ide.visualstudio.plugins.*",
    "import org.gradle.ide.visualstudio.tasks.*",
    "import org.gradle.ide.xcode.*",
    "import org.gradle.ide.xcode.plugins.*",
    "import org.gradle.ide.xcode.tasks.*",
    "import org.gradle.ivy.*",
    "import org.gradle.jvm.*",
    "import org.gradle.jvm.application.scripts.*",
    "import org.gradle.jvm.application.tasks.*",
    "import org.gradle.jvm.tasks.*",
    "import org.gradle.jvm.toolchain.*",
    "import org.gradle.language.*",
    "import org.gradle.language.assembler.*",
    "import org.gradle.language.assembler.plugins.*",
    "import org.gradle.language.assembler.tasks.*",
    "import org.gradle.language.base.*",
    "import org.gradle.language.base.artifact.*",
    "import org.gradle.language.base.compile.*",
    "import org.gradle.language.base.plugins.*",
    "import org.gradle.language.base.sources.*",
    "import org.gradle.language.c.*",
    "import org.gradle.language.c.plugins.*",
    "import org.gradle.language.c.tasks.*",
    "import org.gradle.language.cpp.*",
    "import org.gradle.language.cpp.plugins.*",
    "import org.gradle.language.cpp.tasks.*",
    "import org.gradle.language.java.artifact.*",
    "import org.gradle.language.jvm.tasks.*",
    "import org.gradle.language.nativeplatform.*",
    "import org.gradle.language.nativeplatform.tasks.*",
    "import org.gradle.language.objectivec.*",
    "import org.gradle.language.objectivec.plugins.*",
    "import org.gradle.language.objectivec.tasks.*",
    "import org.gradle.language.objectivecpp.*",
    "import org.gradle.language.objectivecpp.plugins.*",
    "import org.gradle.language.objectivecpp.tasks.*",
    "import org.gradle.language.plugins.*",
    "import org.gradle.language.rc.*",
    "import org.gradle.language.rc.plugins.*",
    "import org.gradle.language.rc.tasks.*",
    "import org.gradle.language.scala.tasks.*",
    "import org.gradle.language.swift.*",
    "import org.gradle.language.swift.plugins.*",
    "import org.gradle.language.swift.tasks.*",
    "import org.gradle.maven.*",
    "import org.gradle.model.*",
    "import org.gradle.nativeplatform.*",
    "import org.gradle.nativeplatform.platform.*",
    "import org.gradle.nativeplatform.plugins.*",
    "import org.gradle.nativeplatform.tasks.*",
    "import org.gradle.nativeplatform.test.*",
    "import org.gradle.nativeplatform.test.cpp.*",
    "import org.gradle.nativeplatform.test.cpp.plugins.*",
    "import org.gradle.nativeplatform.test.cunit.*",
    "import org.gradle.nativeplatform.test.cunit.plugins.*",
    "import org.gradle.nativeplatform.test.cunit.tasks.*",
    "import org.gradle.nativeplatform.test.googletest.*",
    "import org.gradle.nativeplatform.test.googletest.plugins.*",
    "import org.gradle.nativeplatform.test.plugins.*",
    "import org.gradle.nativeplatform.test.tasks.*",
    "import org.gradle.nativeplatform.test.xctest.*",
    "import org.gradle.nativeplatform.test.xctest.plugins.*",
    "import org.gradle.nativeplatform.test.xctest.tasks.*",
    "import org.gradle.nativeplatform.toolchain.*",
    "import org.gradle.nativeplatform.toolchain.plugins.*",
    "import org.gradle.normalization.*",
    "import org.gradle.platform.*",
    "import org.gradle.platform.base.*",
    "import org.gradle.platform.base.binary.*",
    "import org.gradle.platform.base.component.*",
    "import org.gradle.platform.base.plugins.*",
    "import org.gradle.plugin.devel.*",
    "import org.gradle.plugin.devel.plugins.*",
    "import org.gradle.plugin.devel.tasks.*",
    "import org.gradle.plugin.management.*",
    "import org.gradle.plugin.use.*",
    "import org.gradle.plugins.ear.*",
    "import org.gradle.plugins.ear.descriptor.*",
    "import org.gradle.plugins.ide.*",
    "import org.gradle.plugins.ide.api.*",
    "import org.gradle.plugins.ide.eclipse.*",
    "import org.gradle.plugins.ide.idea.*",
    "import org.gradle.plugins.signing.*",
    "import org.gradle.plugins.signing.signatory.*",
    "import org.gradle.plugins.signing.signatory.pgp.*",
    "import org.gradle.plugins.signing.type.*",
    "import org.gradle.plugins.signing.type.pgp.*",
    "import org.gradle.process.*",
    "import org.gradle.swiftpm.*",
    "import org.gradle.swiftpm.plugins.*",
    "import org.gradle.swiftpm.tasks.*",
    "import org.gradle.testing.base.*",
    "import org.gradle.testing.base.plugins.*",
    "import org.gradle.testing.jacoco.plugins.*",
    "import org.gradle.testing.jacoco.tasks.*",
    "import org.gradle.testing.jacoco.tasks.rules.*",
    "import org.gradle.testkit.runner.*",
    "import org.gradle.util.*",
    "import org.gradle.vcs.*",
    "import org.gradle.vcs.git.*",
    "import org.gradle.work.*",
    "import org.gradle.workers.*"
).mapTo(mutableSetOf()) { it.removeSuffix("*") }

object : CliktCommand(name = __FILE__.name) {
    val projectRootDir by argument()
        .file(mustExist = true, canBeFile = false, canBeDir = true, mustBeWritable = true, mustBeReadable = true, canBeSymlink = true)

    val ignoredDirs by option()
        .split(",")
        .default(listOf("assets", "build", "funTest", "generated", "test"))

    init {
        context {
            helpFormatter = { MordantHelpFormatter(context = it, "*", showDefaultValues = true) }
        }
    }

    override fun run() {
        val ktsFiles = projectRootDir.walk()
            .onEnter { it.name !in ignoredDirs }
            .filterTo(mutableListOf()) { it.isFile && (it.name.endsWith(".gradle") || it.name.endsWith(".gradle.kts")) }

        val lineSeparator = System.getProperty("line.separator")

        ktsFiles.forEachIndexed { index, file ->
            echo(Theme.Default.muted("[${index + 1} / ${ktsFiles.size}]: ") + Theme.Default.info(file.relativeTo(projectRootDir).path))

            val lines = file.readLines()
            val cleanedLines = lines.mapNotNull { line ->
                line.takeUnless { defaultImports.any { line.startsWith(it) && "." !in line.substringAfter(it) } }
            }

            if (cleanedLines != lines) file.writeText(cleanedLines.joinToString(lineSeparator, postfix = lineSeparator))
        }
    }
}.main(args)
