*&---------------------------------------------------------------------*
*& Report ZOE_CDS_FINDER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_cds_finder.

TABLES: ddldependency,dd25t,dd26s.

DATA: gt_25t TYPE  STANDARD TABLE OF dd25t,
      gs_25t TYPE dd25t.

CONSTANTS: gc_true  TYPE sap_bool VALUE 'X',
           gc_false TYPE sap_bool VALUE ' '.

* Deferred Class Definition
CLASS lcl_handle_events DEFINITION DEFERRED.

DATA: gt_outtab TYPE STANDARD TABLE OF alv_t_t2.
DATA: gr_table   TYPE REF TO cl_salv_table.
DATA: gr_container TYPE REF TO cl_gui_custom_container.

*...  object for handling the events of cl_salv_table
DATA: gr_events TYPE REF TO lcl_handle_events.
DATA: g_okcode TYPE syucomm.
DATA: it_bdcdata TYPE bdcdata OCCURS 0 WITH HEADER LINE      .
DATA:wa_bdcdata TYPE bdcdata .

* Event Handler Class Definition
CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS:
      on_link_click FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column.
ENDCLASS .

* Event Handler Class Implementation
CLASS lcl_handle_events IMPLEMENTATION.

* On Click Method
  METHOD on_link_click.

    READ TABLE gt_25t INTO DATA(ls_25t) INDEX row.

    PERFORM bdc_dynpro      USING 'SAPLSD_ENTRY' '1000'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RSRD1-TBMA_VAL'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=WB_DISPLAY'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=WB_DISPLAY'.
    PERFORM bdc_field       USING 'RSRD1-TBMA'
                                  'X'.
    PERFORM bdc_field       USING 'RSRD1-TBMA_VAL'
                                  ls_25t-viewname.
*   Navigate to Data Dictionary
    CALL TRANSACTION 'SE11' USING it_bdcdata
                                  MODE 'E'
                                  UPDATE 'A' .

    CLEAR:it_bdcdata,it_bdcdata[].

  ENDMETHOD.

ENDCLASS.

* Selection Screen
SELECT-OPTIONS: s_view FOR dd25t-ddtext NO INTERVALS ,
                s_tab  FOR dd26s-tabname NO INTERVALS.
* At Selection Screen
AT SELECTION-SCREEN.

* Start of Selection
START-OF-SELECTION.

* Pull the data from the db tables
  SELECT
  a~viewname,
  ddtext,
  objecttype
    FROM dd25t AS a INNER JOIN ddldependency AS b
    ON a~viewname = b~objectname
    INNER JOIN dd26s AS c
    ON a~viewname = c~viewname
    INTO TABLE @DATA(lt_final)
    WHERE a~ddlanguage = 'E' AND
          a~ddtext IN @s_view AND
          c~tabname IN @s_tab.

  LOOP AT lt_final INTO DATA(ls_final).
    MOVE-CORRESPONDING ls_final TO gs_25t .
    APPEND gs_25t TO gt_25t.
    CLEAR:gs_25t.
  ENDLOOP.

  SORT gt_25t BY viewname ASCENDING.

  DELETE ADJACENT DUPLICATES FROM gt_25t COMPARING viewname.

  DESCRIBE TABLE  gt_25t LINES DATA(l_tabix).

  DATA: l_count TYPE c LENGTH 7.
  l_count = l_tabix.

  CONCATENATE 'Total no. of CDS found' l_count INTO DATA(msg).
  MESSAGE msg TYPE 'I'.

* Call Factory Method
  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = gr_table
    CHANGING
      t_table      = gt_25t[].

  DATA: lr_columns TYPE REF TO cl_salv_columns_table,
        lr_column  TYPE REF TO cl_salv_column_table.

  lr_columns = gr_table->get_columns( ).
  lr_columns->set_optimize( gc_true ).

  lr_column ?= lr_columns->get_column( 'VIEWNAME' ).
  lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
  lr_column->set_icon( if_salv_c_bool_sap=>true ).
  lr_column->set_long_text( 'VIEWNAME' ).

  DATA: lr_events TYPE REF TO cl_salv_events_table.

  lr_events = gr_table->get_event( ).

  CREATE OBJECT gr_events.

* Set Handler
  SET HANDLER gr_events->on_link_click FOR lr_events.

* Display ALV
  gr_table->display( ).

*---------------------------------------------------
* form for bdc dynpro
*---------------------------------------------------
FORM bdc_dynpro USING program
                      dynpro.
  CLEAR it_bdcdata.
  wa_bdcdata-program = program.
  wa_bdcdata-dynpro = dynpro.
  wa_bdcdata-dynbegin = 'X'.
  APPEND wa_bdcdata TO it_bdcdata.
  CLEAR:wa_bdcdata.

ENDFORM.                    "bdc_dynpro
*---------------------------------------------------
*        form for bdc field
*---------------------------------------------------
FORM bdc_field  USING fnam
                      fval.
  CLEAR it_bdcdata.
  wa_bdcdata-fnam = fnam.
  wa_bdcdata-fval = fval.
  APPEND wa_bdcdata TO it_bdcdata.
  CLEAR:wa_bdcdata.
ENDFORM.                    "bdc_field</code>
