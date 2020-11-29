*&---------------------------------------------------------------------*
*& Report ZOE_AL11_DOWNLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_al11_download.

TYPES : BEGIN OF st_demo,
          reg_no(10) TYPE c,
          name(20)   TYPE c,
          addr(20)   TYPE c,
        END OF st_demo.
DATA : wa_demo TYPE st_demo,
       it_demo TYPE TABLE OF st_demo,
       l_fname TYPE string.
PARAMETERS: p_fname(128) TYPE c DEFAULT '\usr\sap\SRI\SYS\src\DOWN.TXT' OBLIGATORY.
l_fname = p_fname.
wa_demo-reg_no = '100001'.
wa_demo-name = 'ANAND'.
wa_demo-addr = 'NAGARKOVIL'.
APPEND wa_demo TO it_demo.
wa_demo-reg_no = '100002'.
wa_demo-name = 'VIKRAM'.
wa_demo-addr = 'CHENNAI'.
APPEND wa_demo TO it_demo.
OPEN DATASET l_fname FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
WRITE :5 'REG NUM',16 'NAME',37 'ADDRESS' .
LOOP AT it_demo INTO wa_demo.
  IF sy-subrc = 0.
    TRANSFER wa_demo TO l_fname.
    WRITE :/5 wa_demo-reg_no,16 wa_demo-name,37 wa_demo-addr.
  ENDIF.
ENDLOOP.
