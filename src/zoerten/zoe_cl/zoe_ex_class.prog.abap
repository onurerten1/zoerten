*&---------------------------------------------------------------------*
*& Report zoe_ex_class
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_ex_class.

DATA: ex_ref       TYPE REF TO cx_root,
      message_text TYPE string.

TRY.
    RAISE EXCEPTION TYPE zcx_oe_exc_cls
      EXPORTING
        msgv1 = 'For'
        msgv2 = 'Handling'
        msgv3 = 'Exceptions'
        msgv4 = 'In Program'.
  CATCH zcx_oe_exc_cls INTO ex_ref.
    message_text = ex_ref->get_text(  ).
    WRITE message_text.
ENDTRY.
