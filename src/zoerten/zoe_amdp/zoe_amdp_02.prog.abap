*&---------------------------------------------------------------------*
*& Report ZOE_AMDP_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_amdp_02.

TABLES: mara, t001w, t001l.

DATA: gcl_amdp_mard TYPE REF TO zcl_oe_amdp02,
      BEGIN OF gs_data,
        matnr LIKE mard-matnr,
        maktx LIKE makt-maktx,
        werks LIKE mard-werks,
        lgort LIKE mard-lgort,
        labst LIKE mard-labst,
      END OF gs_data,
      gt_data LIKE TABLE OF gs_data.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.
SELECT-OPTIONS: so_matnr FOR mara-matnr,
                so_werks FOR t001w-werks,
                so_lgort FOR t001l-lgort.
SELECTION-SCREEN END OF BLOCK b1.

DATA(lv_where) = cl_shdb_seltab=>combine_seltabs(
                  it_named_seltabs = VALUE #(
                  ( name = 'MATNR' dref = REF #( so_matnr[] ) )
                  ( name = 'WERKS' dref = REF #( so_werks[] ) )
                  ( name = 'LGORT' dref = REF #( so_lgort[] ) ) )
                    iv_client_field = 'MANDT' ).

CREATE OBJECT gcl_amdp_mard.

gcl_amdp_mard->get_mard_data( EXPORTING
                                iv_filter = lv_where
                              IMPORTING
                                et_data = gt_data ).


TRY .
    cl_salv_table=>factory( IMPORTING
                              r_salv_table = DATA(lcl_alv)
                            CHANGING
                              t_table = gt_data ).
  CATCH cx_salv_msg.

ENDTRY.

IF gt_data[] IS NOT INITIAL.
  lcl_alv->display( ).
ELSE.
  MESSAGE 'Veri Bulunamadı' TYPE 'I'.
  LEAVE LIST-PROCESSING.
ENDIF.
