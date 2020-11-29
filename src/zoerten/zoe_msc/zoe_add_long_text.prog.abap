*&---------------------------------------------------------------------*
*& Report ZOE_ADD_LONG_TEXT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_add_long_text.
*Internal table to hold long text...
DATA:
  BEGIN OF t_upload OCCURS 0,
    matnr LIKE mara-matnr,             " Material number
    id(2) TYPE c,                      " Identification
    ltext LIKE tline-tdline,           " Long text
  END OF t_upload,
*Internal table to hold long text....
  t_line LIKE tline OCCURS 0 WITH HEADER LINE.
DATA:
  w_grun       LIKE thead-tdid ,            " To hold id
  w_object     LIKE thead-tdobject VALUE 'MATERIAL',
  " To hold object id
  lv_value(70).                       " Value to hold material number

START-OF-SELECTION.
* This perform is used to upload the file
  PERFORM upload_file.
* This perform is used to place the text in MM02 transaction
  PERFORM place_longtext.
*&---------------------------------------------------------------------*
*&      Form  create_text
*&---------------------------------------------------------------------*
*  This routine used to create text in MM02 transaction
*----------------------------------------------------------------------*
*  Passed the parameter w_grun to P_C_GRUN
*                 and lv_value to P_LV_VALUE
*----------------------------------------------------------------------*
FORM create_text  USING    p_c_grun
                           p_lv_value.
  DATA:
    l_id       LIKE thead-tdid,
    l_name(70).
  MOVE : p_c_grun TO l_id,
         p_lv_value TO l_name.
  CALL FUNCTION 'CREATE_TEXT'
    EXPORTING
      fid       = l_id
      flanguage = sy-langu
      fname     = l_name
      fobject   = w_object
*     SAVE_DIRECT       = 'X'
*     FFORMAT   = '*'
    TABLES
      flines    = t_line
    EXCEPTIONS
      no_init   = 1
      no_save   = 2
      OTHERS    = 3.
  IF sy-subrc <> 0.
    CLEAR lv_value.
  ELSE.
    DELETE t_line INDEX 1.
  ENDIF.
ENDFORM.                    " create_text
*&---------------------------------------------------------------------*
*&      Form  upload_file
*&---------------------------------------------------------------------*
*  This routine is used to upload file
*----------------------------------------------------------------------*
*  No interface parameters are passed
*----------------------------------------------------------------------*
FORM upload_file .
  CALL FUNCTION 'UPLOAD'
    EXPORTING
*     CODEPAGE                = ' '
*     FILENAME                = ' '
      filetype                = 'DAT'
*     ITEM                    = ' '
*     FILEMASK_MASK           = ' '
*     FILEMASK_TEXT           = ' '
*     FILETYPE_NO_CHANGE      = ' '
*     FILEMASK_ALL            = ' '
*     FILETYPE_NO_SHOW        = ' '
*     LINE_EXIT               = ' '
*     USER_FORM               = ' '
*     USER_PROG               = ' '
*     SILENT                  = 'S'
*   IMPORTING
*     FILESIZE                =
*     CANCEL                  =
*     ACT_FILENAME            =
*     ACT_FILETYPE            =
    TABLES
      data_tab                = t_upload
    EXCEPTIONS
      conversion_error        = 1
      invalid_table_width     = 2
      invalid_type            = 3
      no_batch                = 4
      unknown_error           = 5
      gui_refuse_filetransfer = 6
      OTHERS                  = 7.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
  SORT t_upload BY matnr id.
ENDFORM.                    " upload_file
*&---------------------------------------------------------------------*
*&      Form  place_longtext
*&---------------------------------------------------------------------*
*  This routine places the text in MM02 transaction
*----------------------------------------------------------------------*
*  No interface parameters are passed
*----------------------------------------------------------------------*
FORM place_longtext .
  LOOP AT t_upload.
    t_line-tdformat = 'ST'.
    t_line-tdline = t_upload-ltext.
    APPEND t_line.
    IF t_upload-id EQ 'BT'.
      MOVE t_upload-matnr TO lv_value.
      MOVE 'GRUN' TO w_grun.                   "Test ID for Basic data text
      PERFORM create_text USING w_grun lv_value.
    ENDIF.
    IF t_upload-id EQ 'IT'.
      CLEAR w_grun.
      MOVE t_upload-matnr TO lv_value.
      MOVE 'PRUE' TO w_grun.                      "Test ID for Inspection text
      PERFORM create_text USING w_grun lv_value.
    ENDIF.
    IF t_upload-id EQ 'IC'.
      CLEAR w_grun.
      MOVE : t_upload-matnr TO lv_value,
             'IVER' TO w_grun.
      "Test ID for Internal comment
      PERFORM create_text USING w_grun lv_value.
    ENDIF.
  ENDLOOP.
ENDFORM.                    " place_longtext
