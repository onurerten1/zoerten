*&---------------------------------------------------------------------*
*& Report ZOE_SEL_SCREEN_LOGO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_sel_screen_logo.

* START OF DO NOT CHANGE***********************************
DATA: docking           TYPE REF TO cl_gui_docking_container,
      picture_control_1 TYPE REF TO cl_gui_picture,
      url(256)          TYPE c.
DATA: query_table    LIKE w3query OCCURS 1 WITH HEADER LINE,
      html_table     LIKE w3html OCCURS 1,
      return_code    LIKE  w3param-ret_code,
      content_type   LIKE  w3param-cont_type,
      content_length LIKE  w3param-cont_len,
      pic_data       LIKE w3mime OCCURS 0,
      pic_size       TYPE i.
* END OF DO NOT CHANGE*************************************
DATA : sum(4) , num1(4) , num2(4).
PARAMETERS: p_dummy(4) DEFAULT '4' .
PARAMETERS: p_dummy1(4) DEFAULT '5' .

AT SELECTION-SCREEN OUTPUT.
  PERFORM show_pic.

START-OF-SELECTION.
*&-------------------------------------------------------------------
*& Form show_pic
*&-------------------------------------------------------------------
FORM show_pic.
  DATA: repid LIKE sy-repid.
  repid = sy-repid.
  CREATE OBJECT picture_control_1 EXPORTING parent = docking.
  CHECK sy-subrc = 0.
  CALL METHOD picture_control_1->set_3d_border
    EXPORTING
      border = 5.
  CALL METHOD picture_control_1->set_display_mode
    EXPORTING
      display_mode = cl_gui_picture=>display_mode_stretch.
  CALL METHOD picture_control_1->set_position
    EXPORTING
      height = 60
      left   = 100
      top    = 20
      width  = 200.
*CHANGE POSITION AND SIZE ABOVE***************************
  IF url IS INITIAL.
    REFRESH query_table.
    query_table-name  = '_OBJECT_ID'.
*CHANGE IMAGE NAME BELOW UPLOADED IN SWO0******************
    query_table-value = 'ZOE_LOGO'.
    APPEND query_table.
    CALL FUNCTION 'WWW_GET_MIME_OBJECT'
      TABLES
        query_string        = query_table
        html                = html_table
        mime                = pic_data
      CHANGING
        return_code         = return_code
        content_type        = content_type
        content_length      = content_length
      EXCEPTIONS
        object_not_found    = 1
        parameter_not_found = 2
        OTHERS              = 3.
    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    CALL FUNCTION 'DP_CREATE_URL'
      EXPORTING
        type     = 'image'
        subtype  = cndp_sap_tab_unknown
        size     = pic_size
        lifetime = cndp_lifetime_transaction
      TABLES
        data     = pic_data
      CHANGING
        url      = url
      EXCEPTIONS
        OTHERS   = 1.
  ENDIF.
  CALL METHOD picture_control_1->load_picture_from_url
    EXPORTING
      url = url.
*Syntax for URL
*url = 'file://D:\corp-gbanerji\pickut\cartoon_184.gif'.
*url = 'http://l.yimg.com/a/i/ww/beta/y3.gif'.
ENDFORM.                    "show_pic
