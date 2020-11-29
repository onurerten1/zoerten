class ZCL_OE_CLASS01 definition
  public
  final
  create public

  global friends ZCL_OE_CLASS03 .

public section.

  data TEXT1 type CHAR50 value 'OERTEN' ##NO_TEXT.
  data TEXT2 type NUMC04 value 2019 ##NO_TEXT.
  class-data TEXT3 type CHAR10 .

  methods CONSTRUCTOR .
  class-methods CLASS_CONSTRUCTOR .
  methods GET_TEXT
    importing
      !MOD type I
    exporting
      !TEXT3 type CHAR10
      !MOD_RESULT type I
    exceptions
      ZERO_ENTER .
  methods FRIEND
    importing
      !IV_NAME type STRING .
  PROTECTED SECTION.
private section.

  data NAME type STRING .
ENDCLASS.



CLASS ZCL_OE_CLASS01 IMPLEMENTATION.


  method CLASS_CONSTRUCTOR.
  endmethod.


  method CONSTRUCTOR.
  endmethod.


  METHOD friend.

  ENDMETHOD.


  METHOD get_text.
    text3 = sy-uname.
    DATA: lv_mod TYPE i.
    IF mod EQ 0.
      RAISE zero_enter.
    ENDIF.

    DO mod TIMES.
      IF sy-index = mod.
        EXIT.
      ENDIF.
      IF mod_result IS INITIAL.
        mod_result = mod * ( mod - 1 ).
        lv_mod = mod - 1.
      ELSE.
        mod_result = mod_result * ( lv_mod - 1 ).
        lv_mod = lv_mod - 1.
      ENDIF.
    ENDDO.

  ENDMETHOD.
ENDCLASS.
