class ZCL_OE_TEST_HANDLER definition
  public
  create public .

public section.

  class-methods CALL_DIALOG
    for event TRANSACTION_FINISHED of CL_SYSTEM_TRANSACTION_STATE
    importing
      !KIND .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_TEST_HANDLER IMPLEMENTATION.


  METHOD call_dialog.

    IF kind = cl_system_transaction_state=>commit_work.
      MESSAGE 'Called successfully after commit!' TYPE 'I'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
