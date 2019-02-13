!ifndef STRING_EXTENSIONS_NSH
!define STRING_EXTENSIONS_NSH

!macro STRING_EXTENSIONS _un_

!ifndef STRING_EXTENSIONS_MACRO
!define STRING_EXTENSIONS_MACRO

/*#==============================#::
 SPLIT STRING
 Used to split a string using a seperator e.g. ';', '*' etc. 
 param: String to split
 param: Seperator character to split string on
 out: Substring from first character until first found seperator
 out: Remaining string
#==============================#*/
!define SplitString '!insertmacro SplitStringCall "${_un_}"'

/*#==============================#::
 STRING CASE
 Used to change casing for a string
 param: String to changge case
 param: What case to change to ("U" == upper, "L" == lower)
 out: New string with changed case
#==============================#*/
!define StrCase '!insertmacro StrCaseCall "${_un_}"'

Function _${_un_}SplitString
  Exch $0 ; Seperator
  Exch 
  Exch $1 ; String to split
  Push $2
  Push $3
  StrCpy $2 0
loop:
  StrCpy $3 $1 1 $2
  IntOp $2 $2 + 1
  StrCmp $3 "" +3
  StrCmp $3 $0 0 loop
  IntOp $2 $2 - 1
  StrCpy $0 $1 $2
  IntOp $2 $2 + 1
  StrCpy $1 $1 "" $2
  Pop $3
  Pop $2
  Exch $1 ; Remaining string
  Exch
  Exch $0 ; Substring
FunctionEnd

Function _${_un_}StrCase
/*After this point:
  ------------------------------------------
  $0 = String (input)
  $1 = Case (input)
  $2 = StrLength (temp)
  $3 = StartChar (temp)
  $4 = EndChar (temp)
  $5 = ResultStr (temp)
  $6 = CurrentChar (temp)
  $7 = LastChar (temp)
  $8 = Temp (temp)*/
 
  ;Get input from user
  Exch $1
  Exch
  Exch $0
  Exch
  Push $2
  Push $3
  Push $4
  Push $5
  Push $6
  Push $7
  Push $8
 
  ;Initialize variables
  StrCpy $2 ""
  StrCpy $3 ""
  StrCpy $4 ""
  StrCpy $5 ""
  StrCpy $6 ""
  StrCpy $7 ""
  StrCpy $8 ""
 
  ;Upper and lower cases are simple to use
  ${If} $1 == "U"
 
    ;Upper Case:
    ;-----------
    ;Convert all characters to upper case.
 
    System::Call "User32::CharUpper(t r0 r5)i"
    Goto StrCase_End
  ${ElseIf} $1 == "L"
 
    ;Lower Case:
    ;-----------
    ;Convert all characters to lower case.
 
    System::Call "User32::CharLower(t r0 r5)i"
    Goto StrCase_End
  ${EndIf}
 
  ;For the rest of cases:
  ;Get "String" length
  StrLen $2 $0
 
  ;Make a loop until the end of "String"
  ${For} $3 0 $2
    ;Add 1 to "EndChar" counter also
    IntOp $4 $3 + 1
 
    # Step 1: Detect one character at a time
 
    ;Remove characters before "StartChar" except when
    ;"StartChar" is the first character of "String"
    ${If} $3 <> 0
      StrCpy $6 $0 `` $3
    ${EndIf}
 
    ;Remove characters after "EndChar" except when
    ;"EndChar" is the last character of "String"
    ${If} $4 <> $2
      ${If} $3 = 0
        StrCpy $6 $0 1
      ${Else}
        StrCpy $6 $6 1
      ${EndIf}
    ${EndIf}
 
    # Step 2: Convert to the advanced case user chose:
 
    ${If} $1 == "T"
 
      ;Title Case:
      ;------------------
      ; Convert all characters after a non-alphabetic character to upper case.
      ; Else convert to lower case.
 
      ;Use "IsCharAlpha" for the job
      System::Call "*(&t1 r7) i .r8"
      System::Call "*$8(&i1 .r7)"
      System::Free $8
      System::Call "user32::IsCharAlpha(i r7) i .r8"
 
      ;Verify "IsCharAlpha" result and convert the character
      ${If} $8 = 0
        System::Call "User32::CharUpper(t r6 r6)i"
      ${Else}
        System::Call "User32::CharLower(t r6 r6)i"
      ${EndIf}
    ${ElseIf} $1 == "S"
 
      ;Sentence Case:
      ;------------------
      ; Convert all characters after a ".", "!" or "?" character to upper case.
      ; Else convert to lower case. Spaces or tabs after these marks are ignored.
 
      ;Detect current characters and ignore if necessary
      ${If} $6 == " "
      ${OrIf} $6 == "$\t"
        Goto IgnoreLetter
      ${EndIf}
 
      ;Detect last characters and convert
      ${If} $7 == "."
      ${OrIf} $7 == "!"
      ${OrIf} $7 == "?"
      ${OrIf} $7 == ""
        System::Call "User32::CharUpper(t r6 r6)i"
      ${Else}
        System::Call "User32::CharLower(t r6 r6)i"
      ${EndIf}
    ${ElseIf} $1 == "<>"
 
      ;Switch Case:
      ;------------------
      ; Switch all characters cases to their inverse case.
 
      ;Use "IsCharUpper" for the job
      System::Call "*(&t1 r6) i .r8"
      System::Call "*$8(&i1 .r7)"
      System::Free $8
      System::Call "user32::IsCharUpper(i r7) i .r8"
 
      ;Verify "IsCharUpper" result and convert the character
      ${If} $8 = 0
        System::Call "User32::CharUpper(t r6 r6)i"
      ${Else}
        System::Call "User32::CharLower(t r6 r6)i"
      ${EndIf}
    ${EndIf}
 
    ;Write the character to "LastChar"
    StrCpy $7 $6
 
    IgnoreLetter:
    ;Add this character to "ResultStr"
    StrCpy $5 `$5$6`
  ${Next}
 
  StrCase_End:
 
  /* After this point:
    ------------------------------------------
    $0 = ResultVar (output) */
 
  ; Copy "ResultStr" to "ResultVar"
  StrCpy $0 $5
 
  ;Return output to user
  Pop $8
  Pop $7
  Pop $6
  Pop $5
  Pop $4
  Pop $3
  Pop $2
  Pop $1
  Exch $0
FunctionEnd

!endif ; macro
!macroend

!macro SplitStringCall _un _list _seperator _itemVar _listVar
  Push `${_list}`
  Push `${_seperator}`
  Call _${_un}SplitString
  Pop `${_itemVar}`
  Pop `${_listVar}`
!macroend

!macro StrCaseCall _un _string _case _resultvar
  Push "${_string}"
  Push "${_case}"
  Call _${_un}StrCase
  Pop "${_resultvar}"
!macroend

!endif ;file