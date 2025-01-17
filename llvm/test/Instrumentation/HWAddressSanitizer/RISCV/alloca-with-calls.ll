; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 2
; Test alloca instrumentation when tags are generated by HWASan function.
;
; RUN: opt < %s -passes=hwasan -hwasan-generate-tags-with-calls -S | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "riscv64-unknown-linux"

declare void @use32(ptr)

define void @test_alloca() sanitize_hwaddress {
; CHECK-LABEL: define void @test_alloca
; CHECK-SAME: () #[[ATTR0:[0-9]+]] personality ptr @__hwasan_personality_thunk {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i64, ptr @__hwasan_tls, align 8
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[TMP0]], 72057594037927935
; CHECK-NEXT:    [[TMP2:%.*]] = ashr i64 [[TMP0]], 3
; CHECK-NEXT:    [[TMP3:%.*]] = call ptr @llvm.frameaddress.p0(i32 0)
; CHECK-NEXT:    [[TMP4:%.*]] = ptrtoint ptr [[TMP3]] to i64
; CHECK-NEXT:    [[TMP5:%.*]] = shl i64 [[TMP4]], 44
; CHECK-NEXT:    [[TMP6:%.*]] = or i64 ptrtoint (ptr @test_alloca to i64), [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = inttoptr i64 [[TMP1]] to ptr
; CHECK-NEXT:    store i64 [[TMP6]], ptr [[TMP7]], align 8
; CHECK-NEXT:    [[TMP8:%.*]] = ashr i64 [[TMP0]], 56
; CHECK-NEXT:    [[TMP9:%.*]] = shl nuw nsw i64 [[TMP8]], 12
; CHECK-NEXT:    [[TMP10:%.*]] = xor i64 [[TMP9]], -1
; CHECK-NEXT:    [[TMP11:%.*]] = add i64 [[TMP0]], 8
; CHECK-NEXT:    [[TMP12:%.*]] = and i64 [[TMP11]], [[TMP10]]
; CHECK-NEXT:    store i64 [[TMP12]], ptr @__hwasan_tls, align 8
; CHECK-NEXT:    [[TMP13:%.*]] = or i64 [[TMP1]], 4294967295
; CHECK-NEXT:    [[HWASAN_SHADOW:%.*]] = add i64 [[TMP13]], 1
; CHECK-NEXT:    [[TMP14:%.*]] = inttoptr i64 [[HWASAN_SHADOW]] to ptr
; CHECK-NEXT:    [[X:%.*]] = alloca { i32, [12 x i8] }, align 16
; CHECK-NEXT:    [[TMP15:%.*]] = call i8 @__hwasan_generate_tag()
; CHECK-NEXT:    [[TMP16:%.*]] = zext i8 [[TMP15]] to i64
; CHECK-NEXT:    [[TMP17:%.*]] = ptrtoint ptr [[X]] to i64
; CHECK-NEXT:    [[TMP18:%.*]] = shl i64 [[TMP16]], 56
; CHECK-NEXT:    [[TMP19:%.*]] = or i64 [[TMP17]], [[TMP18]]
; CHECK-NEXT:    [[X_HWASAN:%.*]] = inttoptr i64 [[TMP19]] to ptr
; CHECK-NEXT:    [[TMP20:%.*]] = trunc i64 [[TMP16]] to i8
; CHECK-NEXT:    [[TMP21:%.*]] = ptrtoint ptr [[X]] to i64
; CHECK-NEXT:    [[TMP22:%.*]] = lshr i64 [[TMP21]], 4
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr i8, ptr [[TMP14]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr i8, ptr [[TMP23]], i32 0
; CHECK-NEXT:    store i8 4, ptr [[TMP24]], align 1
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr i8, ptr [[X]], i32 15
; CHECK-NEXT:    store i8 [[TMP20]], ptr [[TMP25]], align 1
; CHECK-NEXT:    call void @use32(ptr nonnull [[X_HWASAN]])
; CHECK-NEXT:    [[TMP26:%.*]] = ptrtoint ptr [[X]] to i64
; CHECK-NEXT:    [[TMP27:%.*]] = lshr i64 [[TMP26]], 4
; CHECK-NEXT:    [[TMP28:%.*]] = getelementptr i8, ptr [[TMP14]], i64 [[TMP27]]
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 1 [[TMP28]], i8 0, i64 1, i1 false)
; CHECK-NEXT:    ret void
;

entry:
  %x = alloca i32, align 4
  call void @use32(ptr nonnull %x)
  ret void
}
