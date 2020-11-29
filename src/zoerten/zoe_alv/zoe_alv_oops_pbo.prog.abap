*&---------------------------------------------------------------------*
*& Include          ZOE_ALV_OOPS_PBO
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'PF_100'.
  SET TITLEBAR 'TIT_100'.

  lw_fieldcat-fieldname = 'EBELN'.
  lw_fieldcat-seltext =
  lw_fieldcat-reptext = 'Purchase Order'.
  lw_fieldcat-col_pos = 1.
  lw_fieldcat-outputlen = 18.
*  lw_fieldcat-hotspot = 'X'.
  APPEND lw_fieldcat TO lt_fieldcat.
  CLEAR lw_fieldcat.

  lw_fieldcat-fieldname = 'BUKRS'.
  lw_fieldcat-seltext =
  lw_fieldcat-reptext = 'Company Code'.
  lw_fieldcat-col_pos = 2.
  lw_fieldcat-outputlen = 18.
  APPEND lw_fieldcat TO lt_fieldcat.
  CLEAR lw_fieldcat.

  lw_fieldcat-fieldname = 'BSTYP'.
  lw_fieldcat-seltext =
  lw_fieldcat-reptext = 'Document Category'.
  lw_fieldcat-col_pos = 3.
  lw_fieldcat-outputlen = 18.
  APPEND lw_fieldcat TO lt_fieldcat.
  CLEAR lw_fieldcat.

  lw_fieldcat-fieldname = 'AEDAT'.
  lw_fieldcat-seltext =
  lw_fieldcat-reptext = 'Created On'.
  lw_fieldcat-col_pos = 4.
  lw_fieldcat-outputlen = 18.
  APPEND lw_fieldcat TO lt_fieldcat.
  CLEAR lw_fieldcat.

  lw_fieldcat-fieldname = 'ERNAM'.
  lw_fieldcat-seltext =
  lw_fieldcat-reptext = 'Created By'.
  lw_fieldcat-col_pos = 5.
  lw_fieldcat-outputlen = 18.
  APPEND lw_fieldcat TO lt_fieldcat.
  CLEAR lw_fieldcat.

  lw_layout2-cwidth_opt = 'X'.

  CREATE OBJECT container
    EXPORTING
      container_name = 'CONTAINER'.

  CREATE OBJECT grid
    EXPORTING
      i_parent = container.

  CALL METHOD grid->set_table_for_first_display
    EXPORTING
      is_layout       = lw_layout
    CHANGING
      it_outtab       = lt_output
      it_fieldcatalog = lt_fieldcat.

  DATA receiver     TYPE REF TO lcl_eventhandler.

  CREATE OBJECT receiver.
  SET HANDLER receiver->handle_double_click FOR grid.



ENDMODULE.
