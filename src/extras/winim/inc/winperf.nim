#====================================================================
#
#               Winim - Nim's Windows API Module
#                 (c) Copyright 2016-2021 Ward
#
#====================================================================

import winimbase
import windef
import winbase
#include <winperf.h>
type
  PERF_DATA_BLOCK* {.pure.} = object
    Signature*: array[4, WCHAR]
    LittleEndian*: DWORD
    Version*: DWORD
    Revision*: DWORD
    TotalByteLength*: DWORD
    HeaderLength*: DWORD
    NumObjectTypes*: DWORD
    DefaultObject*: LONG
    SystemTime*: SYSTEMTIME
    padding*: array[4, byte]
    PerfTime*: LARGE_INTEGER
    PerfFreq*: LARGE_INTEGER
    PerfTime100nSec*: LARGE_INTEGER
    SystemNameLength*: DWORD
    SystemNameOffset*: DWORD
  PPERF_DATA_BLOCK* = ptr PERF_DATA_BLOCK
when winimCpu64:
  type
    PERF_OBJECT_TYPE* {.pure.} = object
      TotalByteLength*: DWORD
      DefinitionLength*: DWORD
      HeaderLength*: DWORD
      ObjectNameTitleIndex*: DWORD
      ObjectNameTitle*: DWORD
      ObjectHelpTitleIndex*: DWORD
      ObjectHelpTitle*: DWORD
      DetailLevel*: DWORD
      NumCounters*: DWORD
      DefaultCounter*: LONG
      NumInstances*: LONG
      CodePage*: DWORD
      PerfTime*: LARGE_INTEGER
      PerfFreq*: LARGE_INTEGER
when winimCpu32:
  type
    PERF_OBJECT_TYPE* {.pure.} = object
      TotalByteLength*: DWORD
      DefinitionLength*: DWORD
      HeaderLength*: DWORD
      ObjectNameTitleIndex*: DWORD
      ObjectNameTitle*: LPWSTR
      ObjectHelpTitleIndex*: DWORD
      ObjectHelpTitle*: LPWSTR
      DetailLevel*: DWORD
      NumCounters*: DWORD
      DefaultCounter*: LONG
      NumInstances*: LONG
      CodePage*: DWORD
      PerfTime*: LARGE_INTEGER
      PerfFreq*: LARGE_INTEGER
type
  PPERF_OBJECT_TYPE* = ptr PERF_OBJECT_TYPE
when winimCpu64:
  type
    PERF_COUNTER_DEFINITION* {.pure.} = object
      ByteLength*: DWORD
      CounterNameTitleIndex*: DWORD
      CounterNameTitle*: DWORD
      CounterHelpTitleIndex*: DWORD
      CounterHelpTitle*: DWORD
      DefaultScale*: LONG
      DetailLevel*: DWORD
      CounterType*: DWORD
      CounterSize*: DWORD
      CounterOffset*: DWORD
when winimCpu32:
  type
    PERF_COUNTER_DEFINITION* {.pure.} = object
      ByteLength*: DWORD
      CounterNameTitleIndex*: DWORD
      CounterNameTitle*: LPWSTR
      CounterHelpTitleIndex*: DWORD
      CounterHelpTitle*: LPWSTR
      DefaultScale*: LONG
      DetailLevel*: DWORD
      CounterType*: DWORD
      CounterSize*: DWORD
      CounterOffset*: DWORD
type
  PPERF_COUNTER_DEFINITION* = ptr PERF_COUNTER_DEFINITION
  PERF_INSTANCE_DEFINITION* {.pure.} = object
    ByteLength*: DWORD
    ParentObjectTitleIndex*: DWORD
    ParentObjectInstance*: DWORD
    UniqueID*: LONG
    NameOffset*: DWORD
    NameLength*: DWORD
  PPERF_INSTANCE_DEFINITION* = ptr PERF_INSTANCE_DEFINITION
  PERF_COUNTER_BLOCK* {.pure.} = object
    ByteLength*: DWORD
  PPERF_COUNTER_BLOCK* = ptr PERF_COUNTER_BLOCK
const
  PERF_DATA_VERSION* = 1
  PERF_DATA_REVISION* = 1
  PERF_NO_INSTANCES* = -1
  PERF_SIZE_DWORD* = 0x00000000
  PERF_SIZE_LARGE* = 0x00000100
  PERF_SIZE_ZERO* = 0x00000200
  PERF_SIZE_VARIABLE_LEN* = 0x00000300
  PERF_TYPE_NUMBER* = 0x00000000
  PERF_TYPE_COUNTER* = 0x00000400
  PERF_TYPE_TEXT* = 0x00000800
  PERF_TYPE_ZERO* = 0x00000C00
  PERF_NUMBER_HEX* = 0x00000000
  PERF_NUMBER_DECIMAL* = 0x00010000
  PERF_NUMBER_DEC_1000* = 0x00020000
  PERF_COUNTER_VALUE* = 0x00000000
  PERF_COUNTER_RATE* = 0x00010000
  PERF_COUNTER_FRACTION* = 0x00020000
  PERF_COUNTER_BASE* = 0x00030000
  PERF_COUNTER_ELAPSED* = 0x00040000
  PERF_COUNTER_QUEUELEN* = 0x00050000
  PERF_COUNTER_HISTOGRAM* = 0x00060000
  PERF_COUNTER_PRECISION* = 0x00070000
  PERF_TEXT_UNICODE* = 0x00000000
  PERF_TEXT_ASCII* = 0x00010000
  PERF_TIMER_TICK* = 0x00000000
  PERF_TIMER_100NS* = 0x00100000
  PERF_OBJECT_TIMER* = 0x00200000
  PERF_DELTA_COUNTER* = 0x00400000
  PERF_DELTA_BASE* = 0x00800000
  PERF_INVERSE_COUNTER* = 0x01000000
  PERF_MULTI_COUNTER* = 0x02000000
  PERF_DISPLAY_NO_SUFFIX* = 0x00000000
  PERF_DISPLAY_PER_SEC* = 0x10000000
  PERF_DISPLAY_PERCENT* = 0x20000000
  PERF_DISPLAY_SECONDS* = 0x30000000
  PERF_DISPLAY_NOSHOW* = 0x40000000
  PERF_COUNTER_COUNTER* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_PER_SEC
  PERF_COUNTER_TIMER* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_PERCENT
  PERF_COUNTER_QUEUELEN_TYPE* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_QUEUELEN or PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_LARGE_QUEUELEN_TYPE* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_QUEUELEN or PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_100NS_QUEUELEN_TYPE* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_QUEUELEN or PERF_TIMER_100NS or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_OBJ_TIME_QUEUELEN_TYPE* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_QUEUELEN or PERF_OBJECT_TIMER or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_BULK_COUNT* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_PER_SEC
  PERF_COUNTER_TEXT* = PERF_SIZE_VARIABLE_LEN or PERF_TYPE_TEXT or PERF_TEXT_UNICODE or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_RAWCOUNT* = PERF_SIZE_DWORD or PERF_TYPE_NUMBER or PERF_NUMBER_DECIMAL or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_LARGE_RAWCOUNT* = PERF_SIZE_LARGE or PERF_TYPE_NUMBER or PERF_NUMBER_DECIMAL or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_RAWCOUNT_HEX* = PERF_SIZE_DWORD or PERF_TYPE_NUMBER or PERF_NUMBER_HEX or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_LARGE_RAWCOUNT_HEX* = PERF_SIZE_LARGE or PERF_TYPE_NUMBER or PERF_NUMBER_HEX or PERF_DISPLAY_NO_SUFFIX
  PERF_SAMPLE_FRACTION* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_FRACTION or PERF_DELTA_COUNTER or PERF_DELTA_BASE or PERF_DISPLAY_PERCENT
  PERF_SAMPLE_COUNTER* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_NODATA* = PERF_SIZE_ZERO or PERF_DISPLAY_NOSHOW
  PERF_COUNTER_TIMER_INV* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_INVERSE_COUNTER or PERF_DISPLAY_PERCENT
  PERF_SAMPLE_BASE* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_BASE or PERF_DISPLAY_NOSHOW or 0x00000001
  PERF_AVERAGE_TIMER* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_FRACTION or PERF_DISPLAY_SECONDS
  PERF_AVERAGE_BASE* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_BASE or PERF_DISPLAY_NOSHOW or 0x00000002
  PERF_AVERAGE_BULK* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_FRACTION or PERF_DISPLAY_NOSHOW
  PERF_OBJ_TIME_TIMER* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_OBJECT_TIMER or PERF_DELTA_COUNTER or PERF_DISPLAY_PERCENT
  PERF_100NSEC_TIMER* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_TIMER_100NS or PERF_DELTA_COUNTER or PERF_DISPLAY_PERCENT
  PERF_100NSEC_TIMER_INV* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_TIMER_100NS or PERF_DELTA_COUNTER or PERF_INVERSE_COUNTER or PERF_DISPLAY_PERCENT
  PERF_COUNTER_MULTI_TIMER* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_DELTA_COUNTER or PERF_TIMER_TICK or PERF_MULTI_COUNTER or PERF_DISPLAY_PERCENT
  PERF_COUNTER_MULTI_TIMER_INV* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_RATE or PERF_DELTA_COUNTER or PERF_MULTI_COUNTER or PERF_TIMER_TICK or PERF_INVERSE_COUNTER or PERF_DISPLAY_PERCENT
  PERF_COUNTER_MULTI_BASE* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_BASE or PERF_MULTI_COUNTER or PERF_DISPLAY_NOSHOW
  PERF_100NSEC_MULTI_TIMER* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_DELTA_COUNTER or PERF_COUNTER_RATE or PERF_TIMER_100NS or PERF_MULTI_COUNTER or PERF_DISPLAY_PERCENT
  PERF_100NSEC_MULTI_TIMER_INV* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_DELTA_COUNTER or PERF_COUNTER_RATE or PERF_TIMER_100NS or PERF_MULTI_COUNTER or PERF_INVERSE_COUNTER or PERF_DISPLAY_PERCENT
  PERF_RAW_FRACTION* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_FRACTION or PERF_DISPLAY_PERCENT
  PERF_LARGE_RAW_FRACTION* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_FRACTION or PERF_DISPLAY_PERCENT
  PERF_RAW_BASE* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_BASE or PERF_DISPLAY_NOSHOW or 0x00000003
  PERF_LARGE_RAW_BASE* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_BASE or PERF_DISPLAY_NOSHOW
  PERF_ELAPSED_TIME* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_ELAPSED or PERF_OBJECT_TIMER or PERF_DISPLAY_SECONDS
  PERF_COUNTER_HISTOGRAM_TYPE* = 0x80000000'i32
  PERF_COUNTER_DELTA* = PERF_SIZE_DWORD or PERF_TYPE_COUNTER or PERF_COUNTER_VALUE or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX
  PERF_COUNTER_LARGE_DELTA* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_VALUE or PERF_DELTA_COUNTER or PERF_DISPLAY_NO_SUFFIX
  PERF_PRECISION_SYSTEM_TIMER* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_PRECISION or PERF_TIMER_TICK or PERF_DELTA_COUNTER or PERF_DISPLAY_PERCENT
  PERF_PRECISION_100NS_TIMER* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_PRECISION or PERF_TIMER_100NS or PERF_DELTA_COUNTER or PERF_DISPLAY_PERCENT
  PERF_PRECISION_OBJECT_TIMER* = PERF_SIZE_LARGE or PERF_TYPE_COUNTER or PERF_COUNTER_PRECISION or PERF_OBJECT_TIMER or PERF_DELTA_COUNTER or PERF_DISPLAY_PERCENT
  PERF_PRECISION_TIMESTAMP* = PERF_LARGE_RAW_BASE
  PERF_DETAIL_NOVICE* = 100
  PERF_DETAIL_ADVANCED* = 200
  PERF_DETAIL_EXPERT* = 300
  PERF_DETAIL_WIZARD* = 400
  PERF_NO_UNIQUE_ID* = -1
  PERF_QUERY_OBJECTS* = LONG 0x80000000'i32
  PERF_QUERY_GLOBAL* = LONG 0x80000001'i32
  PERF_QUERY_COSTLY* = LONG 0x80000002'i32
  MAX_PERF_OBJECTS_IN_QUERY_FUNCTION* = 64
  WINPERF_LOG_NONE* = 0
  WINPERF_LOG_USER* = 1
  WINPERF_LOG_DEBUG* = 2
  WINPERF_LOG_VERBOSE* = 3
type
  PM_OPEN_PROC* = proc (P1: LPWSTR): DWORD {.stdcall.}
  PM_COLLECT_PROC* = proc (P1: LPWSTR, P2: ptr LPVOID, P3: LPDWORD, P4: LPDWORD): DWORD {.stdcall.}
  PM_CLOSE_PROC* = proc (): DWORD {.stdcall.}
  PM_QUERY_PROC* = proc (P1: LPDWORD, P2: ptr LPVOID, P3: LPDWORD, P4: LPDWORD): DWORD {.stdcall.}
