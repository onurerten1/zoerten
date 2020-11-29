*&---------------------------------------------------------------------*
*& Report ZOE_SD_FATURA_RAP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
* Program           :
* Development ID    :
* Module            :
* Module Consultant :
* ABAP Consultant   :
* Date              :
*-----------------------------------------------------------------------
*-*
REPORT zoe_sd_fatura_rap.
*----------------------------------------------------------------------*
INCLUDE zoe_sd_fatura_rap_top.
INCLUDE zoe_sd_fatura_rap_cls.

*----------------------------------------------------------------------*
*  INITIALIZATION.
*----------------------------------------------------------------------*
INITIALIZATION.
  DATA(lo_alv) = NEW lcl_salv_ida( ).

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.

*----------------------------------------------------------------------*
*  AT SELECTION-SCREEN OUTPUT.
*----------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

*----------------------------------------------------------------------*
*  START-OF-SELECTION.
*----------------------------------------------------------------------*
START-OF-SELECTION.
  lo_alv->create_table( iv_cds_table = 'ZOE_SD_CDS_FAT_RAP' ).

  lo_alv->add_sel_cond( it_vkorg = s_vkorg[]
                        it_vtweg = s_vtweg[]
                        it_vstel = s_vstel[]
                        it_fkart = s_fkart[]
                        it_fkdat = s_fkdat[]
                        it_vbeln = s_vbeln[]
                        it_xblnr = s_xblnr[]
                        it_kunrg = s_kunrg[]
                        it_matnr = s_matnr[]
                        it_ernam = s_ernam[]
                        it_erdat = s_erdat[] ).

*----------------------------------------------------------------------*
*  END-OF-SELECTION.
*----------------------------------------------------------------------*
END-OF-SELECTION.
  lo_alv->change_toolbar( ).
  lo_alv->selection_mode( ).
  lo_alv->text_search( ).
  lo_alv->hotspot_activate( ).
  lo_alv->alv_title( ).
  lo_alv->pattern( ).
  lo_alv->display( ).
