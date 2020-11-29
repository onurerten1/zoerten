class ZCX_OE_EXC_CLS definition
  public
  inheriting from CX_STATIC_CHECK
  create public .

public section.

  interfaces IF_T100_DYN_MSG .
  interfaces IF_T100_MESSAGE .

  constants:
    begin of ZCX_OE_EXC_CLS,
      msgid type symsgid value 'ZOE_EX',
      msgno type symsgno value '000',
      attr1 type scx_attrname value 'MSGV1',
      attr2 type scx_attrname value 'MSGV2',
      attr3 type scx_attrname value 'MSGV3',
      attr4 type scx_attrname value 'MSGV4',
    end of ZCX_OE_EXC_CLS .
  data MSGV1 type MSGV1 .
  data MSGV2 type MSGV2 .
  data MSGV3 type MSGV3 .
  data MSGV4 type MSGV4 .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !MSGV1 type MSGV1 optional
      !MSGV2 type MSGV2 optional
      !MSGV3 type MSGV3 optional
      !MSGV4 type MSGV4 optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_OE_EXC_CLS IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->MSGV1 = MSGV1 .
me->MSGV2 = MSGV2 .
me->MSGV3 = MSGV3 .
me->MSGV4 = MSGV4 .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = ZCX_OE_EXC_CLS .
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
