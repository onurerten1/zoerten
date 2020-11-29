*&---------------------------------------------------------------------*
*& Report ZOE_FS_DEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_fs_demo.

*----------------------------------------------------------------------*
*---------------------------------------------------------------------*
* POOLS                                                              *
*---------------------------------------------------------------------*
TYPE-POOLS: slis.
*---------------------------------------------------------------------*
* TABLES                                                              *
*---------------------------------------------------------------------*
TABLES: mara.
*---------------------------------------------------------------------*
* TYPES
*---------------------------------------------------------------------*
TYPES: BEGIN OF x_data,
         matnr TYPE matnr,
         werks TYPE werks_d,
       END OF x_data.
*---------------------------------------------------------------------*
*  DATA                                                               *
*---------------------------------------------------------------------*
DATA:
* Internal tables
  i_data          TYPE STANDARD TABLE OF x_data,
  i_data_temp     TYPE STANDARD TABLE OF x_data,
  i_fcat          TYPE lvc_t_fcat,
  i_dynamic_table TYPE REF TO data,
  i_plant         TYPE STANDARD TABLE OF x_plant,
  i_fieldcat      TYPE slis_t_fieldcat_alv,

* Work ara
  wa_fcat         TYPE lvc_s_fcat,
  wa_dyn_line     TYPE REF TO data,
  wa_plant        TYPE x_plant,
  wa_data         TYPE x_data,

* Variable
  v_field_name    TYPE fieldname,
  v_tabix         TYPE sytabix,
  v_fieldname     TYPE fieldname,
  v_seltext       TYPE scrtext_l.
*---------------------------------------------------------------------*
*  Field Symbols                                                      *
*---------------------------------------------------------------------*
FIELD-SYMBOLS:
  <i_dyn_table>   TYPE STANDARD TABLE,
  <i_final_table> TYPE STANDARD TABLE,
  <wa_dyn>        TYPE any,
  <wa_final>      TYPE any.
*---------------------------------------------------------------------*
* SELECTION SCREEN                                                    *
*---------------------------------------------------------------------*
SELECT-OPTIONS: s_matnr FOR mara-matnr.
*---------------------------------------------------------------------*
* INITIALIZATION                                                      *
*---------------------------------------------------------------------*
INITIALIZATION.
* Select data
*---------------------------------------------------------------------*
* START-OF-SELECTION.                                                 *
*---------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM sub_slect_data.

*---------------------------------------------------------------------*
* END-OF-SELECTION.                                                   *
*---------------------------------------------------------------------*
END-OF-SELECTION.
* Populate the dynamic columns needed for each run
  PERFORM sub_populate_catlog.

* Build the dynamic internal table
  PERFORM sub_build_int_table.

* Build ALF Field Catalog information
  PERFORM sub_alv_field_cat.

* Display data
  PERFORM sub_display_data.

*---------------------------------------------------------------------*
* SUB ROUTINES                                                        *
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SUB_SLECT_DATA
*&---------------------------------------------------------------------*
FORM sub_slect_data .

  SELECT matnr werks
    INTO TABLE i_data
    FROM marc
    WHERE matnr IN s_matnr.
  IF sy-subrc EQ 0.
    SORT i_data BY matnr.

    i_data_temp[] = i_data[].
    SORT i_data_temp BY werks.
    DELETE ADJACENT DUPLICATES FROM i_data_temp
    COMPARING werks.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_POPULATE_CATLOG
*&---------------------------------------------------------------------*
FORM sub_populate_catlog .
  v_field_name = 'MATNR'.
* There is one Material column
  PERFORM sub_pop_field_catlog USING v_field_name.

  v_field_name = 'WERKS'.
* There would be 'N' number of dynamic Plant columns
* depending on the material and plants combination
  LOOP AT i_data_temp INTO wa_data.
    PERFORM sub_pop_field_catlog USING v_field_name.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_POP_FIELD_CATLOG
*&---------------------------------------------------------------------*
FORM sub_pop_field_catlog  USING    p_l_field_name TYPE fieldname.

  DATA: l_i_dfies  TYPE STANDARD TABLE OF dfies,
        l_wa_dfies TYPE dfies.

* Call FM
  CALL FUNCTION 'DDIF_FIELDINFO_GET'
    EXPORTING
      tabname        = 'MARC'
      fieldname      = p_l_field_name
    TABLES
      dfies_tab      = l_i_dfies
    EXCEPTIONS
      not_found      = 1
      internal_error = 2
      OTHERS         = 3.
  IF sy-subrc EQ 0.

    CLEAR l_wa_dfies.
    READ TABLE l_i_dfies INTO l_wa_dfies INDEX 1.
    CLEAR wa_fcat.
* Since we want the Plant number to be the header text
* Replacing the field name with actual plant value
    IF v_field_name = 'WERKS'.
      l_wa_dfies-fieldname = wa_data-werks.
    ENDIF.

    MOVE-CORRESPONDING l_wa_dfies TO wa_fcat.
    clear wa_fcat-intlen.
    APPEND wa_fcat TO i_fcat.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_BUILD_INT_TABLE
*&---------------------------------------------------------------------*
FORM sub_build_int_table .

* Prepare the dynamic internal table with required columns of each run
  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog           = i_fcat
    IMPORTING
      ep_table                  = i_dynamic_table
    EXCEPTIONS
      generate_subpool_dir_full = 1
      OTHERS                    = 2.
* Assign the structure of dynamic table to field symbol
  ASSIGN i_dynamic_table->* TO <i_dyn_table>.

* Create the dynamic work area
  CREATE DATA wa_dyn_line LIKE LINE OF <i_dyn_table>.
  ASSIGN wa_dyn_line->* TO <wa_dyn>.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_ALV_FIELD_CAT
*&---------------------------------------------------------------------*
FORM sub_alv_field_cat .

* Build field catalog for Material
  PERFORM sub_fill_alv_field_cat USING
        'MATNR' '<I_DYN_TABLE>' 'L' 'Material Number' 40.

* Number of Plant columns would be dynamic for Plants
  LOOP AT i_data_temp INTO wa_data.

    v_fieldname = wa_data-werks.
    v_seltext =   wa_data-werks.

    PERFORM sub_fill_alv_field_cat USING
              v_fieldname '<I_DYN_TABLE>' 'L' v_seltext 4.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SUB_FILL_ALV_FIELD_CAT
*&---------------------------------------------------------------------*
FORM sub_fill_alv_field_cat  USING
                             p_fldnam    TYPE fieldname
                             p_tabnam    TYPE tabname
                             p_justif    TYPE char1
                             p_seltext   TYPE dd03p-scrtext_l
                             p_outlen    TYPE i.

  DATA l_lfl_fcat TYPE slis_fieldcat_alv.

  l_lfl_fcat-fieldname  = p_fldnam.
  l_lfl_fcat-tabname    = p_tabnam.
  l_lfl_fcat-just       = p_justif.
  l_lfl_fcat-seltext_l  = p_seltext.
  l_lfl_fcat-outputlen  = p_outlen.

  APPEND l_lfl_fcat TO i_fieldcat.

  CLEAR l_lfl_fcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  SUB_DISPLAY_DATA
*&---------------------------------------------------------------------*
FORM sub_display_data .

  DATA: l_count     TYPE i,
        l_factor    TYPE i,
        l_wa_layout TYPE slis_layout_alv.

  LOOP AT i_data INTO wa_data.

    CLEAR: l_factor, l_count.

    READ TABLE i_data_temp WITH KEY werks = wa_data-werks
    TRANSPORTING NO FIELDS
    BINARY SEARCH.
    IF sy-subrc EQ 0.

      <wa_dyn>+0(40) = wa_data-matnr.
      l_factor = sy-tabix - 1.
      l_count = 40 + ( 4 * l_factor ).

      <wa_dyn>+l_count(4) = 'X'.

      AT END OF matnr.
        APPEND <wa_dyn> TO <i_dyn_table>.
        CLEAR <wa_dyn>.
      ENDAT.
    ENDIF.

  ENDLOOP.

  l_wa_layout-colwidth_optimize = 'X'.
  l_wa_layout-zebra = 'X'.

* Funtion module for displaying the ALV report
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      is_layout          = l_wa_layout
      it_fieldcat        = i_fieldcat
    TABLES
      t_outtab           = <i_dyn_table>
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.


ENDFORM.
