*&---------------------------------------------------------------------*
*& Report ZOE_TEST_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_test_test.

*DATA(lv_ads_con) = cl_fp=>get_ads_connection( ).
*
*WRITE: / lv_ads_con.

*TRY.
*    cl_reca_date=>check_date( CONV d( '01.01.1999' ) ).
*
*  CATCH cx_root INTO DATA(e1).
*    WRITE: / e1->get_text( ).
*ENDTRY.
*
*TRY.
*    cl_reca_date=>check_date( CONV d( '19990101' ) ).
*
*  CATCH cx_root INTO DATA(e2).
*    WRITE: / e2->get_text( ).
*ENDTRY.
*
*TRY.
*    cl_reca_date=>check_date( CONV d( '1234' ) ).
*
*  CATCH cx_root INTO DATA(e3).
*    WRITE: / e3->get_text( ).
*ENDTRY.

*PARAMETERS: p_times1 TYPE i DEFAULT 15.
*
*DO p_times1 TIMES.
*  cl_progress_indicator=>progress_indicate( i_text               = |{ sy-index } / { p_times1 }|
*                                            i_processed          = sy-index
*                                            i_total              = p_times1
*                                            i_output_immediately = abap_true ).
*
*  WAIT UP TO 1 SECONDS.
*ENDDO.

*PARAMETERS: p_prog TYPE trdir-name DEFAULT 'SAPLSD_ENTRY'. " (SE11)
*
*START-OF-SELECTION.
*
** Code Inspector: Quelltext für Include
*  DATA(o_si) = cl_ci_source_include=>create( p_name = p_prog ).
** Code Inspector: Quelltext für SCAN  erzeugen
*  DATA(o_scan) = NEW cl_ci_scan( p_include = o_si ).
*
** Include-Zeilen
*  cl_demo_output=>write_data( o_si->lines ).
** Tokens
*  cl_demo_output=>write_data( o_scan->tokens ).
** Anweisungen
*  cl_demo_output=>write_data( o_scan->statements ).
*
** Verknüpfung Statements -> Tokens
** Statements
*  LOOP AT o_scan->statements ASSIGNING FIELD-SYMBOL(<s>).
*
*    DATA(idx) = sy-tabix.
*
** Tokens
*    LOOP AT o_scan->tokens ASSIGNING FIELD-SYMBOL(<t>) FROM <s>-from TO <s>-to.
*      cl_demo_output=>write_data( value = <t>-str name = |Statement { idx }| ).
*    ENDLOOP.
*
*    cl_demo_output=>line( ).
*
*  ENDLOOP.
*
**   HTML-Code vom Demo-Output holen
*  DATA(lv_html) = cl_demo_output=>get( ).
*
**   Daten im Inline-Browser im SAP-Fenster anzeigen
*  cl_abap_browser=>show_html( EXPORTING
*                                title        = 'Code'
*                                html_string  = lv_html
*                                container    = cl_gui_container=>default_screen ).
*
**   cl_gui_container=>default_screen erzwingen
*  WRITE: space.

DATA(it_bapi_ret) = VALUE bapiret2_t( ).

CALL FUNCTION 'C14ALD_BAPIRET2_SHOW'
  TABLES
    i_bapiret2_tab = it_bapi_ret.

CALL FUNCTION 'RSCRMBW_DISPLAY_BAPIRET2'
  TABLES
    it_return = it_bapi_ret.
