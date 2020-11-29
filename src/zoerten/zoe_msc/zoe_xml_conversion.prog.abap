*&---------------------------------------------------------------------*
*& Report ZOE_XML_CONVERSION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_xml_conversion.

TABLES: pa0001.

SELECT-OPTIONS: s_pernr FOR pa0001-pernr.

TYPES: BEGIN OF ty_itab,
         pernr TYPE pa0001-pernr,
         begda TYPE pa0001-begda,
         enda  TYPE pa0001-endda,
       END OF ty_itab.

DATA: lt_itab TYPE STANDARD TABLE OF ty_itab,
      ls_itab TYPE ty_itab.

DATA: xml_out TYPE string,
      lv_src  TYPE string,
      lv_trg  TYPE string.

START-OF-SELECTION.

  SELECT pernr,
         begda,
         endda
    FROM pa0001
    INTO TABLE @lt_itab
    WHERE pernr IN @s_pernr.

END-OF-SELECTION.
  DATA: lt_final LIKE TABLE OF ls_itab.
  CALL TRANSFORMATION ('ID')
  SOURCE tab = lt_itab[]
  RESULT XML xml_out.

  DATA : lt_spl TYPE swastrtab OCCURS 0 WITH HEADER LINE.
  DATA : s_appl(255),
         p_appl(255).

  OPEN DATASET p_appl FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.


  CALL FUNCTION 'SWA_STRING_SPLIT'
    EXPORTING
      input_string                 = xml_out
      max_component_length         = 255
      terminating_separators       = '>'
    TABLES
      string_components            = lt_spl
    EXCEPTIONS
      max_component_length_invalid = 1
      OTHERS                       = 2.
  LOOP AT lt_spl.
    TRANSFER lt_spl-str TO p_appl.
  ENDLOOP.
  CLEAR : lt_spl[].
  CLOSE DATASET p_appl.

  WRITE: / xml_out.
*  BREAK-POINT.
