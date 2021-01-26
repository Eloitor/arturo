######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2020 Yanis Zafirópulos
#
# @file: vm/vm.nim
######################################################

#=======================================
# Libraries
#=======================================

import base64, json, md5, os, random, sequtils
import std/sha1, strformat, strutils, sugar
import tables, times

import extras/bignum, extras/miniz, extras/parsetoml

import helpers/arrays       as arraysHelper   
import helpers/csv          as csvHelper
import helpers/database     as databaseHelper
import helpers/datasource   as datasourceHelper
import helpers/html         as htmlHelper
import helpers/json         as jsonHelper
import helpers/markdown     as markdownHelper
import helpers/math         as mathHelper
import helpers/path         as pathHelper
import helpers/strings      as stringsHelper
import helpers/toml         as tomlHelper
import helpers/unisort      as unisortHelper
import helpers/url          as urlHelper
import helpers/webview      as webviewHelper
import helpers/xml          as xmlHelper

import translator/eval, translator/parse
import vm/env, vm/exec, vm/globals, vm/stack, vm/value

import version

#=======================================
# Types
#=======================================


#=======================================
# Globals
#=======================================


#=======================================
# Constants
#=======================================

const
    NoArgs*      = static {"" : {Nothing}}
    NoAttrs*     = static {"" : ({Nothing},"")}

#=======================================
# Templates
#=======================================

template requireArgs*(name: string, spec: untyped, nopop: bool = false): untyped =
    if SP<(static spec.len):
        panic "cannot perform '" & (static name) & "'; not enough parameters: " & $(static spec.len) & " required"

    when (static spec.len)>=1 and spec!=NoArgs:
        when not (ANY in static spec[0][1]):
            if not (Stack[SP-1].kind in (static spec[0][1])):
                let acceptStr = toSeq((spec[0][1]).items).map(proc(x:ValueKind):string = ":" & ($(x)).toLowerAscii()).join(" ")
                panic "cannot perform '" & (static name) & "' -> :" & ($(Stack[SP-1].kind)).toLowerAscii() & " ...; incorrect argument type for 1st parameter; accepts " & acceptStr

        when (static spec.len)>=2:
            when not (ANY in static spec[1][1]):
                if not (Stack[SP-2].kind in (static spec[1][1])):
                    let acceptStr = toSeq((spec[1][1]).items).map(proc(x:ValueKind):string = ":" & ($(x)).toLowerAscii()).join(" ")
                    panic "cannot perform '" & (static name) & "' -> :" & ($(Stack[SP-1].kind)).toLowerAscii() & " :" & ($(Stack[SP-2].kind)).toLowerAscii() & " ...; incorrect argument type for 2nd parameter; accepts " & acceptStr

            when (static spec.len)>=3:
                when not (ANY in static spec[2][1]):
                    if not (Stack[SP-3].kind in (static spec[2][1])):
                        let acceptStr = toSeq((spec[2][1]).items).map(proc(x:ValueKind):string = ":" & ($(x)).toLowerAscii()).join(" ")
                        panic "cannot perform '" & (static name) & "' -> :" & ($(Stack[SP-1].kind)).toLowerAscii() & " :" & ($(Stack[SP-2].kind)).toLowerAscii() & " :" & ($(Stack[SP-3].kind)).toLowerAscii() & " ...; incorrect argument type for third parameter; accepts " & acceptStr

    when not nopop:
        when (static spec.len)>=1 and spec!=NoArgs:
            var x {.inject.} = stack.pop()
            when (static spec.len)>=2:
                var y {.inject.} = stack.pop()
                when (static spec.len)>=3:
                    var z {.inject.} = stack.pop()

template builtin*(n: string, alias: SymbolKind, description: string, args: untyped, attrs: untyped, returns: ValueSpec, example: string, act: untyped):untyped =
    syms[n] = newBuiltin(n, alias, static (instantiationInfo().filename).replace(".nim"), description, static args.len, args.toOrderedTable, attrs.toOrderedTable, returns, example, proc ()=
        requireArgs(n, args)
        act
    )
    Funcs[n] = static args.len

#=======================================
# Helpers
#=======================================


#=======================================
# Methods
#=======================================

proc run*(code: var string, args: ValueArray, isFile: bool) =
    initEnv(
        arguments = args, 
        version = Version,
        build = Build
    )

    if isFile: env.addPath(code)
    else: env.addPath(getCurrentDir())

    syms = getEnvDictionary()

    include library/Binary
    include library/Crypto
    include library/Dates
    include library/Files

    initVM()
    let parsed = doParse(move code, isFile)
    let evaled = parsed.doEval()
    discard doExec(evaled)
    showVMErrors()