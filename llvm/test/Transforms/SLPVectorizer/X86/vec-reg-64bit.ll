; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -slp-vectorizer -mcpu=btver2 -S | FileCheck %s --check-prefix=VECT
; RUN: opt < %s -basicaa -slp-vectorizer -mcpu=btver2 -slp-min-reg-size=128 -S | FileCheck %s --check-prefix=NOVECT

; Check SLPVectorizer works for packed horizontal 128-bit instrs.
; See llvm.org/PR32433

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @add_pairs_128(<4 x float>, float* nocapture) #0 {
; VECT-LABEL: @add_pairs_128(
; VECT-NEXT:    [[TMP3:%.*]] = extractelement <4 x float> [[TMP0:%.*]], i32 0
; VECT-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[TMP0]], i32 1
; VECT-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP0]], i32 2
; VECT-NEXT:    [[TMP6:%.*]] = extractelement <4 x float> [[TMP0]], i32 3
; VECT-NEXT:    [[TMP7:%.*]] = insertelement <2 x float> undef, float [[TMP3]], i32 0
; VECT-NEXT:    [[TMP8:%.*]] = insertelement <2 x float> [[TMP7]], float [[TMP5]], i32 1
; VECT-NEXT:    [[TMP9:%.*]] = insertelement <2 x float> undef, float [[TMP4]], i32 0
; VECT-NEXT:    [[TMP10:%.*]] = insertelement <2 x float> [[TMP9]], float [[TMP6]], i32 1
; VECT-NEXT:    [[TMP11:%.*]] = fadd <2 x float> [[TMP8]], [[TMP10]]
; VECT-NEXT:    [[TMP12:%.*]] = getelementptr inbounds float, float* [[TMP1:%.*]], i64 1
; VECT-NEXT:    [[TMP13:%.*]] = bitcast float* [[TMP1]] to <2 x float>*
; VECT-NEXT:    store <2 x float> [[TMP11]], <2 x float>* [[TMP13]], align 4
; VECT-NEXT:    ret void
;
; NOVECT-LABEL: @add_pairs_128(
; NOVECT-NEXT:    [[TMP3:%.*]] = extractelement <4 x float> [[TMP0:%.*]], i32 0
; NOVECT-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[TMP0]], i32 1
; NOVECT-NEXT:    [[TMP5:%.*]] = fadd float [[TMP3]], [[TMP4]]
; NOVECT-NEXT:    store float [[TMP5]], float* [[TMP1:%.*]], align 4
; NOVECT-NEXT:    [[TMP6:%.*]] = extractelement <4 x float> [[TMP0]], i32 2
; NOVECT-NEXT:    [[TMP7:%.*]] = extractelement <4 x float> [[TMP0]], i32 3
; NOVECT-NEXT:    [[TMP8:%.*]] = fadd float [[TMP6]], [[TMP7]]
; NOVECT-NEXT:    [[TMP9:%.*]] = getelementptr inbounds float, float* [[TMP1]], i64 1
; NOVECT-NEXT:    store float [[TMP8]], float* [[TMP9]], align 4
; NOVECT-NEXT:    ret void
;
  %3 = extractelement <4 x float> %0, i32 0
  %4 = extractelement <4 x float> %0, i32 1
  %5 = fadd float %3, %4
  store float %5, float* %1, align 4
  %6 = extractelement <4 x float> %0, i32 2
  %7 = extractelement <4 x float> %0, i32 3
  %8 = fadd float %6, %7
  %9 = getelementptr inbounds float, float* %1, i64 1
  store float %8, float* %9, align 4
  ret void
}

attributes #0 = { nounwind }
