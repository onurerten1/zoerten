*&---------------------------------------------------------------------*
*& Report zoe_amdp03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_amdp03.
TABLES: mara, afru, aufk, crhd, matdoc.
**Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-s01.
SELECT-OPTIONS : s_matnr FOR mara-matnr,
                 s_werks FOR afru-werks OBLIGATORY,
                 s_budat FOR afru-budat OBLIGATORY,
                 s_arbpl FOR crhd-arbpl,
                 s_prctr FOR aufk-prctr,
                 s_bwart FOR matdoc-bwart OBLIGATORY MATCHCODE OBJECT h_t156.

SELECTION-SCREEN END OF BLOCK b1.

TRY.
    DATA(gv_afru) = cl_shdb_seltab=>combine_seltabs( it_named_seltabs = VALUE #( ( name = 'WERKS'   dref  = REF #( s_werks[] ) )
                                                       ( name = 'BUDAT'    dref    = REF #( s_budat[] ) ) )
      iv_client_field = 'MANDT' ).

    DATA(gv_bwart) = cl_shdb_seltab=>combine_seltabs( it_named_seltabs = VALUE #( ( name  = 'BWART'      dref            = REF #( s_bwart[] ) ) )
       iv_client_field = 'MANDT' ).

    DATA(gv_matnr) = cl_shdb_seltab=>combine_seltabs( it_named_seltabs = VALUE #( ( name  = 'MATNR'      dref            = REF #( s_matnr[] ) ) )
        iv_client_field = 'MANDT' ).

    DATA(gv_aufk)  = cl_shdb_seltab=>combine_seltabs( it_named_seltabs = VALUE #( ( name  = 'PRCTR'        dref            = REF #( s_prctr[] ) ) )
       iv_client_field = 'MANDT' ).

    DATA(gv_arbpl) = cl_shdb_seltab=>combine_seltabs( it_named_seltabs = VALUE #( ( name   = 'ARBPL'       dref            = REF #( s_arbpl[] ) ) )
        iv_client_field = 'MANDT' ).

  CATCH cx_shdb_exception INTO DATA(gx_shdb_exception). "exceptions of HANA DB object
    DATA(gv_message) = gx_shdb_exception->get_text( ).
    MESSAGE gv_message TYPE 'I'.
ENDTRY.
DATA(lo_amdp) = NEW zoe_amdp03( ).
lo_amdp->fetch_prod_scrap(            " Fetching all data
    EXPORTING
      iv_client = sy-mandt
      iv_langu  = CONV #( sy-langu )  "Converts directly to string
      iv_matnr  = gv_matnr
      iv_aufk   = gv_aufk
      iv_afru   = gv_afru
      iv_arbpl  = gv_arbpl
      iv_bwart  = gv_bwart
    IMPORTING
      et_scrap  = DATA(gt_scrap) ).

IF gt_scrap IS NOT INITIAL.
  lo_amdp->display(        "Processing of data and display
       CHANGING
         it_scrap = gt_scrap ).
ELSE.
  MESSAGE 'No Records Exist.' TYPE 'S' DISPLAY LIKE 'E'.
  LEAVE LIST-PROCESSING.
ENDIF.
