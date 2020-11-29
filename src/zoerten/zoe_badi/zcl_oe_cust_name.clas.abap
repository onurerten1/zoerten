class ZCL_OE_CUST_NAME definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces ZOE_IF_CUST_NAME .
protected section.
private section.
ENDCLASS.



CLASS ZCL_OE_CUST_NAME IMPLEMENTATION.


  METHOD zoe_if_cust_name~get_cust_name.

    IF i_kunnr IS NOT INITIAL.
      SELECT SINGLE *
        FROM kna1
        INTO CORRESPONDING FIELDS OF @c_kna1
        WHERE kunnr = @i_kunnr.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
