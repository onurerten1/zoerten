*&---------------------------------------------------------------------*
*& Report ZOE_TABF_DENEME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_tabf_deneme.

PARAMETERS: p_carrid TYPE s_carr_id.

SELECT *
  FROM zoe_cds_tabf( carrid = @p_carrid )
  INTO TABLE @DATA(lt_tabf).

CALL METHOD cl_salv_table=>factory
  IMPORTING
    r_salv_table = DATA(lcl_alv)
  CHANGING
    t_table      = lt_tabf.

lcl_alv->display( ).
