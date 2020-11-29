class ZCL_OE_TSERV definition
  public
  create public .

public section.

  methods HANDLE_TRANSACTION .
protected section.
private section.

  class-methods FETCH_PERSISTENT .
ENDCLASS.



CLASS ZCL_OE_TSERV IMPLEMENTATION.


METHOD fetch_persistent.
ENDMETHOD.


  METHOD handle_transaction.
    DATA: tx         TYPE REF TO if_os_transaction,
          tx_manager TYPE REF TO if_os_transaction_manager.
    tx_manager = cl_os_system=>get_transaction_manager( ).
    tx = tx_manager->create_transaction( ).

    TRY.
        tx->start( ).
        fetch_persistent( ).
        tx->end( ).
      CATCH cx_os_error.
        tx->undo( ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
