!ifndef VAR_LOGIC_NSH
!define VAR_LOGIC_NSH

!define IncrementVar '!insertmacro IncrementVarCall'
!define DecrementVar '!insertmacro DecrementVarCall'

/*#==============================#::
 INCREMENT VAR
 param: Value to increase
#==============================#*/
!macro IncrementVarCall _var
  IntOp ${_var} ${_var} + 1
!macroend

/*#==============================#::
 DECREMENT VAR
 param: Value to decrement
#==============================#*/
!macro DecrementVarCall _var
  IntOp ${_var} ${_var} - 1
!macroend

!endif ;file