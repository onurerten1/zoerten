*&---------------------------------------------------------------------*
*& Report zoe_create_zip
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_create_zip.

TYPES: BEGIN OF bin_file,
         name TYPE string,
         size TYPE i,
         data TYPE solix_tab,
       END OF bin_file  .

DATA: lv_filename     TYPE string,
      wa_bindata      TYPE bin_file,
      it_bindata      TYPE STANDARD TABLE OF bin_file,
      oref_zip        TYPE REF TO cl_abap_zip,
      lv_zip_xstring  TYPE xstring,
      lv_xstring      TYPE xstring,
      lv_path         TYPE string,
      it_filetab      TYPE filetable,
      ret_code        TYPE i,
      v_usr           TYPE i,
      v_zip_size      TYPE i,
      it_zip_bin_data TYPE STANDARD TABLE OF raw255,
      v_dest_filepath TYPE string.
CREATE OBJECT oref_zip.

cl_gui_frontend_services=>file_open_dialog(
EXPORTING
window_title            = 'Select files that you want to ZIP'
multiselection          = 'X'
CHANGING
file_table                 = it_filetab
rc                              = ret_code
user_action             = v_usr ).

LOOP AT it_filetab INTO DATA(wa_filetab).

  lv_filename = wa_filetab-filename.

  cl_gui_frontend_services=>gui_upload(
    EXPORTING
      filename                = lv_filename
      filetype                = 'BIN'
    IMPORTING
      filelength              = wa_bindata-size
    CHANGING
      data_tab                = wa_bindata-data ).

  CALL FUNCTION 'SO_SPLIT_FILE_AND_PATH'
    EXPORTING
      full_name     = lv_filename
    IMPORTING
      stripped_name = wa_bindata-name
    EXCEPTIONS
      x_error       = 1
      OTHERS        = 2.

  APPEND wa_bindata TO it_bindata.

ENDLOOP.

LOOP AT it_bindata INTO wa_bindata.

  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = wa_bindata-size
    IMPORTING
      buffer       = lv_xstring
    TABLES
      binary_tab   = wa_bindata-data.

  oref_zip->add( name    = wa_bindata-name

            content = lv_xstring ).

ENDLOOP.

lv_zip_xstring = oref_zip->save( ).

CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
  EXPORTING
    buffer        = lv_zip_xstring
  IMPORTING
    output_length = v_zip_size
  TABLES
    binary_tab    = it_zip_bin_data.

cl_gui_frontend_services=>file_save_dialog(
EXPORTING
window_title         = 'SELECT THE LOCATION TO SAVE THE FILE'
file_filter          = '(*.ZIP)|*.ZIP|'
CHANGING
filename             = lv_filename
path                 = lv_path
fullpath             = v_dest_filepath ).

cl_gui_frontend_services=>gui_download(
EXPORTING
bin_filesize              = v_zip_size
filename                  = v_dest_filepath
filetype                  = 'BIN'
*      IMPORTING
*        FILELENGTH                = V_FILESIZE
CHANGING
data_tab                  = it_zip_bin_data ).
