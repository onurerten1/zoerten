class ZCL_OE_CLASS03 definition
  public
  final
  create public

  global friends ZCL_OE_CLASS01 .

public section.

  interfaces ZOE_INTERFACE .

  data NAME type CHAR20 .
  class-data TEXT1 type CHAR20 .
  constants TEXT2 type CHAR20 value 'MBIS' ##NO_TEXT.
  data NUMBER type I .

  methods CONSTRUCTOR .
  methods METHOD1
    exporting
      !TEXTM type CHAR20
    changing
      !TEXT_OUT type CHAR30
      !NUMBER type I
      !TEXT2 type CHAR20 default 'Method Attribute' .
  methods METHOD2 .
protected section.
private section.

  data NAME1 type STRING .

  methods FRIEND
    importing
      !IV_NAME type STRING .
ENDCLASS.



CLASS ZCL_OE_CLASS03 IMPLEMENTATION.


  METHOD constructor.
    WRITE:/'Constructor Triggered'.
  ENDMETHOD.


  method FRIEND.
  endmethod.


    METHOD method1.


      number = number * number.

      CONCATENATE textm sy-datum sy-uzeit INTO text_out SEPARATED BY space.
      WRITE:/ me->text2,
            / text2.

    ENDMETHOD.


  method METHOD2.
  endmethod.


  method ZOE_INTERFACE~MESSAGE.
    CALL FUNCTION 'RPTRA_POPUP_TO_INFORM'
      EXPORTING
        titel         = 'Interface'
        txt1          = 'Interface'
        txt2          = 'Method'
*       TXT3          = ' '
*       TXT4          = ' '
              .

  endmethod.
ENDCLASS.
