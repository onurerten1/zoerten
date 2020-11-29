REPORT  zupdwd.
***********************************************************************

* Description : download/upload a report from a flat file along with its Source code,
* Attributes, Text elements, PF-status and Documentation in different languages     *
*_____________________________________________________________________*
* Inputs:                                                             *
*   Tables:                                                           *
*     SSCRFIELDS - Fields on selection screens                        *
*   Select options:                                                   *
*     N/A                                                             *
*   Parameters:                                                       *
*     P_DWN   -  Radio Button for Download                            *
*     P_UPL   -  Radio Button for Upload                              *
*     P_PROG  -  Program Name                                         *
*     P_FILE  -  File Name                                            *
* Outputs:                                                            *
*  When Uploaded:                                                     *
*    A report is generated along with its Source code, Attributes,    *
*  Text elements, PF-status and Documentation and the report would be *
*  in Active state.                                                   *
*                                                                     *
*  When Downloaded:                                                   *
*    A file is generated on the local system in which Source code,    *
*  Attributes, Text elements, PF-status and Documentation of the      *
*  report are downloaded.                                             *

***********************************************************************

* Table declarations...................................................
TABLES: sscrfields.                    " Fields on selection screens

* Selection screen elements............................................
SELECTION-SCREEN BEGIN OF BLOCK b1
                           WITH FRAME
                          TITLE tit1.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) comm1 FOR FIELD p_dwn.
PARAMETERS: p_dwn RADIOBUTTON GROUP rad1 DEFAULT 'X' USER-COMMAND ucom.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) comm2 FOR FIELD p_upl.
PARAMETERS: p_upl RADIOBUTTON GROUP rad1 .
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN BEGIN OF BLOCK b2
                           WITH FRAME
                          TITLE tit2 .
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) comm3 FOR FIELD p_prog.
PARAMETERS: p_prog TYPE trdir-name MODIF ID bl1.
*                                      " Program Name
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN SKIP.

SELECTION-SCREEN COMMENT /1(50) comm5.
SELECTION-SCREEN COMMENT /1(50) comm6.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) comm4 FOR FIELD p_file.
PARAMETERS: p_file   TYPE rlgrap-filename DEFAULT 'C:\'
                                         MODIF ID bl1.
*                                      " Download File Name
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

* Type declarations for internal tables................................
TYPES: BEGIN OF type_s_dd03l,
         fieldname TYPE fieldname,     " Field Name
       END OF type_s_dd03l,

       BEGIN OF type_s_trdir,
         name    TYPE progname,         " Program Name
         edtx    TYPE edtx,             " Editor lock flag
         subc    TYPE subc,             " Program type
         secu    TYPE secu,             " Authorization Group
         fixpt   TYPE fixpt,            " Fixed point arithmetic
         sset    TYPE sset,             " Start only via variant
         uccheck TYPE uccheck,          " Unicode check flag
         rstat   TYPE rdir_rstat,       " Status
         appl    TYPE rdir_appl,        " Application
         ldbname TYPE ldbnam,           " LDB name
         type    TYPE rdir_type,        " Selection screen version
       END   OF type_s_trdir.


* Work variables........................................................
DATA:
  w_file       TYPE string,           " File Name
  w_type(10)   TYPE c,                " File Type
  w_exist(1)   TYPE c,                " Flag
  w_prog(60)   TYPE c,                " Program Name
  w_index      TYPE sytabix,          " Index
  w_text       TYPE repti,            " Title of the program
  w_appl       TYPE  rdir_appl,       " Application
  w_prog2(120) TYPE c,                " Program name
  w_prog3(70)  TYPE c,                " Program name
  w_name       TYPE progname,         " Program name
  w_obj        TYPE trobj_name,       " Object Name in Object List
  w_str        TYPE string,           " String
  w_ans(1)     TYPE c,                " Answer
  w_pgmid      TYPE pgmid,            " Program ID
  w_object     TYPE trobjtype,        " Object Type
  w_char(1)    TYPE c,                " Language Key
  w_len(10)    TYPE c,                " Reserved length for text
  w_state      TYPE dokstate,         " Documentation status
  w_typ        TYPE doku_typ,         " Documentation type
  w_version    TYPE dokvers,          " Documentation version
  w_lang(1)    TYPE c,                " Language Key
  w_mess       TYPE string,           " Message
  w_lin        TYPE i,                " Line Number
  w_wrd        TYPE string,           " Word
  w_strlen     TYPE i,                " String Length
  w_cnt2       TYPE i,                " Counter Variable
  w_cnt3       TYPE i,                " Counter Variable
  w_field(20)  TYPE c,                " Holds Text
  w_val        TYPE string.           " Holds Field Symbol value

* Constants.............................................................
CONSTANTS:
  c_asc(10)  VALUE 'ASC',              " File type
  c_x(1)     VALUE 'X',                " Flag
  c_lang(1)  VALUE 'E',                " Language
  c_prog(4)  VALUE 'PROG',             " Object type
  c_stat(10) VALUE 'RSMPE_STAT',       " Constant 'RSMPE_STAT'
  c_funt(10) VALUE 'RSMPE_FUNT',       " Constant 'RSMPE_FUNT'
  c_men(9)   VALUE 'RSMPE_MEN',        " Constant 'RSMPE_MEN'
  c_mnlt(10) VALUE 'RSMPE_MNLT',       " Constant 'RSMPE_MNLT'
  c_act(9)   VALUE 'RSMPE_ACT',        " Constant 'RSMPE_ACT'
  c_but(9)   VALUE 'RSMPE_BUT',        " Constant 'RSMPE_BUT'
  c_pfk(9)   VALUE 'RSMPE_PFK',        " Constant 'RSMPE_PFK'
  c_staf(10) VALUE 'RSMPE_STAF',       " Constant 'RSMPE_STAF'
  c_atrt(10) VALUE 'RSMPE_ATRT',       " Constant 'RSMPE_ATRT'
  c_titt(10) VALUE 'RSMPE_TITT',       " Constant 'RSMPE_TITT'
  c_buts(10) VALUE 'RSMPE_BUTS',       " Constant 'RSMPE_BUTS'
  c_sep(1)   VALUE ';',                " Separator ';'
  c_sep2(1)  VALUE '*'.                " Separator '*'

* Field Strings.........................................................
DATA: fs_trdir      TYPE type_s_trdir, " (Structure) TRDIR
      fs_tadir      TYPE tadir,        " (Structure) TADIR
      fs_tdevc      TYPE tdevc,        " (Structure) TDEVC
      fs_thead      TYPE thead,        " (Structure) THEAD
      fs_adm        TYPE rsmpe_adm,    " (Structure) RSMPE_ADM
      fs_doc(50000) TYPE c,            " (Structure) String
      fs_str(50000) TYPE c,            " (Structure) String
      fs_dir        TYPE trdir,        "  System Table TRDIR
      fs_trkey      TYPE trkey,        " (Structure) TRKEY
      fs_code       TYPE string,       " (Structure) Source Code
      fs_attr       TYPE string,       " (Structure) Attributes
      fs_docu       TYPE string,       " (Structure) Documentation
      fs_text1      TYPE string,       " (Structure) Texts
      fs_pfs        TYPE string,       " (Structure) PF-Status
      fs_data       TYPE string,       " (Structure) Complete Data
      fs_data2      TYPE string,       " (Structure) Complete Data
      fs_dokil      TYPE dokil,        " (Structure) Index for
*                                      " Documentation
      fs_tline      TYPE tline,        " (Structure) Docu Tables
      fs_sta        TYPE rsmpe_stat,   " (Structure) Text-dependentStat
      fs_fun        TYPE rsmpe_funt,   " (Structure) Language-specific
*                                      " function texts
      fs_men        TYPE rsmpe_men,    " (Structure) Menu structure
      fs_mtx        TYPE rsmpe_mnlt,   " (Structure) Language-specific
*                                      " menu texts
      fs_act        TYPE rsmpe_act,    " (Structure) Menu bars
      fs_but        TYPE rsmpe_but,    " (Structure) Pushbuttons
      fs_pfk        TYPE rsmpe_pfk,    " (Structure) Function key
*                                      " assignments
      fs_set        TYPE rsmpe_staf,   " (Structure) Status functions
      fs_atrt       TYPE rsmpe_atrt,   " (Structure) Attributes with
*                                      " texts
      fs_tit        TYPE rsmpe_titt,   " (Structure) Title Codes with
*                                      " texts
      fs_biv        TYPE rsmpe_buts,   " (Structure) Fixed Functions on
*                                      " Application Toolbars
      fs_txt        TYPE textpool,     " (Structure) ABAP Text Pool
*                                      " Definition
      fs_dd03l      TYPE type_s_dd03l. " Table Fields

* Internal tables.......................................................
DATA:
*----------------------------------------------------------------------*
* Internal table to hold Source code                                   *
*----------------------------------------------------------------------*
  t_code  TYPE TABLE OF string,

*----------------------------------------------------------------------*
* Internal table to hold Attributes                                    *
*----------------------------------------------------------------------*
  t_attr  TYPE STANDARD TABLE OF string,

*----------------------------------------------------------------------*
* Internal table to hold Documentation                                 *
*----------------------------------------------------------------------*
  t_docu  TYPE TABLE OF string,

*----------------------------------------------------------------------*
* Internal table to hold Texts                                         *
*----------------------------------------------------------------------*
  t_text  TYPE TABLE OF string,

*----------------------------------------------------------------------*
* Internal table to hold PF-Status                                     *
*----------------------------------------------------------------------*
  t_pfs   TYPE TABLE OF string,

*----------------------------------------------------------------------*
* Internal table to hold Complete data                                 *
*----------------------------------------------------------------------*
  t_data  TYPE TABLE OF string,
  t_data2 TYPE TABLE OF string,

*----------------------------------------------------------------------*
* Internal table to hold Index for Documentation                       *
*----------------------------------------------------------------------*
  t_dokil TYPE TABLE OF dokil,

*----------------------------------------------------------------------*
* Internal table to hold Docu tables                                   *
*----------------------------------------------------------------------*
  t_tline TYPE TABLE OF tline,

*----------------------------------------------------------------------*
* PF-STATUS related tables                                             *
*----------------------------------------------------------------------*
  t_sta   TYPE TABLE OF rsmpe_stat,
  t_fun   TYPE TABLE OF rsmpe_funt,
  t_men   TYPE TABLE OF rsmpe_men,
  t_mtx   TYPE TABLE OF rsmpe_mnlt,
  t_act   TYPE TABLE OF rsmpe_act,
  t_but   TYPE TABLE OF rsmpe_but,
  t_pfk   TYPE TABLE OF rsmpe_pfk,
  t_set   TYPE TABLE OF rsmpe_staf,
  t_atrt  TYPE TABLE OF rsmpe_atrt,
  t_tit   TYPE TABLE OF rsmpe_titt,
  t_biv   TYPE TABLE OF rsmpe_buts,
  t_txt   TYPE TABLE OF textpool,
  t_dd03l TYPE TABLE OF type_s_dd03l.

* Field Symbols........................................................
FIELD-SYMBOLS: <fs1> TYPE any.

*---------------------------------------------------------------------*
*                       INITIALIZATION EVENT                          *
*---------------------------------------------------------------------*
INITIALIZATION.
  MOVE : 'Selection Criteria'                             TO tit1,
         'Specify the required parameters'                TO tit2,
         'Download'                                       TO comm1,
         'Upload'                                         TO comm2,
         'Program Name'                                   TO comm3,
         'File Path'                                      TO comm4,
         'Specify only File Path in case of Download,'    TO comm5,
         'filename is taken from Program name by default' TO comm6.

*---------------------------------------------------------------------*
*                  AT SELECTION-SCREEN OUTPUT EVENT                   *
*---------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
* For upload option
  IF p_upl = 'X'.
    MOVE ' ' TO p_file.
    MOVE ' ' TO p_prog.
  ENDIF.                               " IF P_UPL = 'X'

* For download option
  IF p_dwn = 'X'.
    MOVE 'C:\' TO p_file.
  ENDIF.                               " IF P_DWN = 'X'


*----------------------------------------------------------------*
*      AT SELECTION-SCREEN ON VALUE-REQUEST FOR FIELD EVENT      *
*----------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
* F4 help for file
  PERFORM file_help CHANGING p_file.

*--------------------------------------------------------------------*
*                   AT SELECTION-SCREEN EVENT                        *
*--------------------------------------------------------------------*
AT SELECTION-SCREEN.
* If program name is not entered on the screen
  IF sscrfields-ucomm = 'ONLI'.
    IF p_prog IS INITIAL.
      MESSAGE 'Specify Program Name' TYPE 'E'.
    ENDIF.                             " IF P_PROG IS INITIAL
  ENDIF.                               " IF SSCRFIELDS-UCOMM = 'ONLI'

* If file path is not entered on the screen
  IF sscrfields-ucomm = 'ONLI'.
    IF p_file IS INITIAL.
      MESSAGE 'Specify File Path' TYPE 'E'.
    ENDIF.                             " IF P_FILE IS INITIAL
  ENDIF.                               " IF SSCRFIELDS-UCOMM = 'ONLI'

* check if program name entered is greater than 30 chars
  w_strlen = strlen( p_prog ).
  IF w_strlen GT 30.
    CONCATENATE 'Program name too long. '
                'Names longer than 30 chars for internal use only'
           INTO w_str.
    MESSAGE w_str TYPE 'E'.
    CLEAR w_str.
  ENDIF.                               " IF W_STRLEN GT 30...

* Check if the file already exists
  PERFORM check_file.

*---------------------------------------------------------------------*
*                   START-OF-SELECTION EVENT                          *
*---------------------------------------------------------------------*
START-OF-SELECTION.

* When download option is selected
  IF p_dwn = 'X'.

* Get Program Name
    PERFORM get_prog_name.

* Check if the program is active or not
    PERFORM check_prog_status.

* Get Source code
    PERFORM get_source USING fs_trdir-name.

* Get Attributes
    PERFORM get_attr USING fs_trdir.

* Get Documentaion maintained in all the languages
* i.e; includes translations
    PERFORM get_docu.

* Get all the texts maintained in all the languages
* i.e; includes translations
    PERFORM get_text USING fs_trdir-name.

* Get PF-STATUS
    PERFORM get_pfstat USING fs_trdir-name.

* File type
    MOVE c_asc TO w_type.

* Append all the data to final internal table
    APPEND LINES OF t_code TO t_data.
    APPEND LINES OF t_attr TO t_data.
    APPEND LINES OF t_docu TO t_data.
    APPEND LINES OF t_text TO t_data.
    APPEND LINES OF t_pfs  TO t_data.

* Download file
    PERFORM download TABLES t_data
                     USING  w_file
                            w_type.
  ENDIF.                               " IF P_DWN = 'X'

* When upload option is selected
  IF p_upl = 'X'.

* Check if the program already exists
    PERFORM check_prog.

* File type
    MOVE c_asc TO w_type.

* Upload File
    PERFORM upload TABLES t_data
                   USING  w_file
                          w_type.

* Split the data into different tables
    PERFORM process_data.

* Create New Program
    PERFORM create_prog.
  ENDIF.                               " IF P_UPL = 'X'

*&---------------------------------------------------------------------*
*&      Form  FILE_HELP                                                *
*&---------------------------------------------------------------------*
* Subroutine for f4 help for file                                      *
*----------------------------------------------------------------------*
* PV_FILE ==> File Name                                                *
*----------------------------------------------------------------------*
FORM file_help  CHANGING pv_file TYPE rlgrap-filename.
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = pv_file.
ENDFORM.                               " FILE_HELP

*&---------------------------------------------------------------------*
*&      Form  CHECK_FILE                                               *
*&---------------------------------------------------------------------*
* Subroutine to check if file exists or not                            *
*----------------------------------------------------------------------*
* There are no interface parameters to be passed to this subroutine    *
*----------------------------------------------------------------------*
FORM check_file .

* Concatenate Filepath and Program name to get filename in case
* of download
  IF p_dwn = 'X'.
    IF p_file NS '.txt'.
      CONCATENATE p_file
                  p_prog
                  '.txt'
             INTO p_file.
    ENDIF.                             " IF p_file NS...
  ENDIF.                               " IF P_DWN = 'X'

* Populate file and program variables
  MOVE p_file TO w_file.
  MOVE p_prog TO w_prog2.
  MOVE p_prog TO w_prog3.

  CALL FUNCTION 'TMP_GUI_GET_FILE_EXIST'
    EXPORTING
      fname          = p_file
    IMPORTING
      exist          = w_exist
    EXCEPTIONS
      fileinfo_error = 1
      OTHERS         = 2.

  IF sy-subrc EQ 0.
* If file already exists in case of download
    IF w_exist = c_x AND p_dwn = 'X'.
      CLEAR: w_str,w_ans.
      CONCATENATE 'File '
                   p_file
                  ' already exists,'
                  'do you want to overwrite it?'
             INTO w_str
     SEPARATED BY space.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          text_question         = w_str
          display_cancel_button = ' '
        IMPORTING
          answer                = w_ans
        EXCEPTIONS
          text_not_found        = 1.

      IF sy-subrc = 0.
* If user doesn't want to overwrite the existing file,
* allow him to specify different file name, otherwise continue
        IF w_ans = '2'.
          MESSAGE 'Specify valid Filename along with Path and Extension'
          TYPE 'S'.
          STOP.
        ENDIF.                         " IF w_ans = '2'
      ENDIF.                           " IF sy-subrc = 0
* If file does not exist in case of upload
    ELSEIF w_exist NE c_x AND p_upl = 'X'.
      MESSAGE 'File does not exist' TYPE 'S'.
      STOP.
    ENDIF.                             " IF W_EXIST = C_X...
  ENDIF.                               " IF SY-SUBRC EQ 0

  CLEAR: w_str,w_ans.

ENDFORM.                               " CHECK_FILE

*&---------------------------------------------------------------------*
*&      Form  GET_PROG_NAME                                            *
*&---------------------------------------------------------------------*
* Subroutine to get program name                                       *
*----------------------------------------------------------------------*
* There are no interface parameters to be passed to this subroutine    *
*----------------------------------------------------------------------*
FORM get_prog_name.

  MOVE p_prog TO w_prog.

  SELECT SINGLE name                   " ABAP Program Name
                edtx                   " Editor lock flag
                subc                   " Program type
                secu                   " Authorization Group
                fixpt                  " Fixed point arithmetic
                sset                   " Start only via variant
                uccheck                " Unicode check was performed
                rstat                  " Status
                appl                   " Application
                ldbname                " LDB Name
                type                   " Selection screen version
           FROM trdir
           INTO fs_trdir
          WHERE name = w_prog.

  IF sy-subrc NE 0.
    MESSAGE 'Invalid Program name' TYPE 'S'.
    STOP.
  ENDIF.                               " IF SY-SUBRC NE 0
ENDFORM.                               " GET_PROG_NAME

*&---------------------------------------------------------------------*
*&      Form  GET_SOURCE                                               *
*&---------------------------------------------------------------------*
* Subroutine to get source code                                        *
*----------------------------------------------------------------------*
* PV_NAME ==> Program Name                                             *
*----------------------------------------------------------------------*
FORM get_source USING pv_name TYPE trdir-name.

  READ REPORT pv_name INTO t_code.

  IF sy-subrc EQ 0.

    CONCATENATE '**This code is automatically generated by YASH program'
                ', please do not make any changes**'
           INTO fs_code
   SEPARATED BY space.
    INSERT fs_code INTO t_code INDEX 1.

    LOOP AT t_code INTO fs_code.
      IF sy-tabix NE 1.
        MOVE sy-tabix TO w_index.
        CONCATENATE 'C'
                    fs_code
               INTO fs_code.
        MODIFY t_code FROM fs_code INDEX w_index.
      ELSE.
        MOVE sy-tabix TO w_index.
        CONCATENATE 'H'
                    fs_code
               INTO fs_code.
        MODIFY t_code FROM fs_code INDEX w_index.

      ENDIF.                           " IF SY-TABIX NE 1
    ENDLOOP.                           " LOOP AT T_CODE INTO FS_CODE...
  ENDIF.                               " IF SY-SUBRC EQ 0
ENDFORM.                               " GET_SOURCE

*&---------------------------------------------------------------------*
*&      Form  GET_ATTR                                                 *
*&---------------------------------------------------------------------*
* Subroutine to get attributes                                         *
*----------------------------------------------------------------------*
* PV_TRDIR ==> TRDIR structure                                         *
*----------------------------------------------------------------------*
FORM get_attr USING pv_trdir TYPE type_s_trdir.

* Report Title
  SELECT SINGLE text                   " Report Title
           FROM trdirt
           INTO w_text
          WHERE name  = p_prog
            AND sprsl = c_lang.

  IF sy-subrc EQ 0.
    CONCATENATE 'A'
                'TEXT'
                w_text
           INTO fs_attr.
    APPEND fs_attr TO t_attr.
    CLEAR  fs_attr.
  ENDIF.                               " IF SY-SUBRC EQ 0


* Type
  CONCATENATE 'A'
              'SUBC'
              pv_trdir-subc
         INTO fs_attr.
  APPEND fs_attr TO t_attr.
  CLEAR  fs_attr.

* Status
  CONCATENATE 'A'
              'RSTAT'
              pv_trdir-rstat
         INTO fs_attr.
  APPEND fs_attr TO t_attr.
  CLEAR  fs_attr.

* Application
  SELECT SINGLE appl                   " Applications programs,function
*                                      " modules, logical databases
           FROM taplp
           INTO w_appl
          WHERE appl = pv_trdir-appl.

  IF sy-subrc EQ 0.
    CONCATENATE 'A'
                'APPL'
                w_appl
           INTO fs_attr.
    APPEND fs_attr TO t_attr.
    CLEAR  fs_attr.
  ENDIF.                               " IF SY-SUBRC EQ 0

* Authorization Group
  CONCATENATE 'A'
              'SECU'
              pv_trdir-secu
         INTO fs_attr.
  APPEND fs_attr TO t_attr.
  CLEAR  fs_attr.

* Package
  CALL FUNCTION 'AKB_GET_TADIR'
    EXPORTING
      obj_type         = c_prog
      obj_name         = pv_trdir-name
    IMPORTING
      tadir            = fs_tadir
      tdevc            = fs_tdevc
    EXCEPTIONS
      object_not_found = 1
      OTHERS           = 2.

  IF sy-subrc EQ 0.
    CONCATENATE 'A'
                'DEVCLASS'
                fs_tdevc-devclass
           INTO fs_attr.
    APPEND fs_attr TO t_attr.
    CLEAR  fs_attr.
  ELSE.
    MESSAGE 'Object not found' TYPE 'S'.
  ENDIF.                               " IF SY-SUBRC EQ 0

* Logical database
  CONCATENATE 'A'
              'LDBNAME'
              pv_trdir-ldbname
         INTO fs_attr.
  APPEND fs_attr TO t_attr.
  CLEAR  fs_attr.

* Selection screen version
  CONCATENATE 'A'
              'TYPE'
              pv_trdir-type
         INTO fs_attr.
  APPEND fs_attr TO t_attr.
  CLEAR  fs_attr.

* Editor Lock
  CONCATENATE 'A'
              'EDTX'
              pv_trdir-edtx
         INTO fs_attr.
  APPEND fs_attr TO t_attr.
  CLEAR  fs_attr.

* Fixed point arithmetic
  CONCATENATE 'A'
              'FIXPT'
              pv_trdir-fixpt
         INTO fs_attr.
  APPEND fs_attr TO t_attr.
  CLEAR  fs_attr.

* Unicode checks active
  CONCATENATE 'A'
              'UCCHECK'
              pv_trdir-uccheck
         INTO fs_attr.
  APPEND fs_attr TO t_attr.
  CLEAR  fs_attr.

* Start using variant
  CONCATENATE 'A'
              'SSET'
              pv_trdir-sset
              INTO fs_attr.
  APPEND fs_attr TO t_attr.
  CLEAR  fs_attr.

* Variables for documentation
* Program ID
  CONCATENATE 'D'
              'PGMID'
              fs_tadir-pgmid
         INTO fs_docu.
  APPEND fs_docu TO t_docu.
  CLEAR  fs_docu.

* Object Type
  CONCATENATE 'D'
              'OBJECT'
              fs_tadir-object
         INTO fs_docu.
  APPEND fs_docu TO t_docu.
  CLEAR  fs_docu.
ENDFORM.                               " GET_ATTR

*&---------------------------------------------------------------------*
*&      Form  GET_DOCU                                                 *
*&---------------------------------------------------------------------*
* Subroutine to get documentation                                      *
*----------------------------------------------------------------------*
* There are no interface parameters to be passed to this subroutine    *
*----------------------------------------------------------------------*
FORM get_docu.

* Get Index for Documentation
  SELECT id                            " Document class
         object                        " Documentation Object
         langu                         " Documentation Language
         typ                           " Documentation type
         version                       " Version of DocumentationModule
         dokstate                      " Status of Documentation Module
    FROM dokil
    INTO TABLE t_dokil
   WHERE object = w_prog.

  IF sy-subrc EQ 0.
    LOOP AT t_dokil INTO fs_dokil.
      CLEAR: fs_thead,
             fs_tline,
             t_tline[].

      CALL FUNCTION 'DOCU_READ'
        EXPORTING
          id      = fs_dokil-id
          langu   = fs_dokil-langu
          object  = fs_dokil-object
          typ     = fs_dokil-typ
          version = fs_dokil-version
        IMPORTING
          head    = fs_thead
        TABLES
          line    = t_tline.

* Text lines
      LOOP AT t_tline INTO fs_tline.
        CONCATENATE 'DLINE'
                    fs_tline-tdformat
                    fs_tline-tdline
               INTO fs_docu
       SEPARATED BY ';'.
        APPEND fs_docu TO t_docu.
        CLEAR  fs_docu.
      ENDLOOP.                         " LOOP AT T_TLINE INTO FS_TLINE

* Text header
      CONCATENATE 'DHEAD'
                  fs_thead-tdobject fs_thead-tdname     fs_thead-tdid
                  fs_thead-tdspras  fs_thead-tdtitle    fs_thead-tdform
                  fs_thead-tdstyle  fs_thead-tdversion
                  fs_thead-tdfuser  fs_thead-tdfreles
                  fs_thead-tdfdate  fs_thead-tdftime
                  fs_thead-tdluser  fs_thead-tdlreles
                  fs_thead-tdldate  fs_thead-tdltime
                  fs_thead-tdlinesize
                  fs_thead-tdtxtlines fs_thead-tdhyphenat
                  fs_thead-tdospras   fs_thead-tdtranstat
                  fs_thead-tdmacode1  fs_thead-tdmacode2
                  fs_thead-tdrefobj   fs_thead-tdrefname
                  fs_thead-tdrefid    fs_thead-tdtexttype
                  fs_thead-tdcompress fs_thead-mandt fs_thead-tdoclass
                  fs_thead-logsys
             INTO fs_docu
     SEPARATED BY ';'.

      APPEND fs_docu TO t_docu.
      CLEAR  fs_docu.

* Other parameters
* Documentation Status
      CONCATENATE 'D'
                  'DOKSTATE'
                  fs_dokil-dokstate
             INTO fs_docu.
      APPEND fs_docu TO t_docu.
      CLEAR  fs_docu.

* Documentation Type
      CONCATENATE 'D'
                  'TYP'
                  fs_dokil-typ
             INTO fs_docu.
      APPEND fs_docu TO t_docu.
      CLEAR  fs_docu.

* Documentation Version
      CONCATENATE 'D'
                  'DOKVERSION'
                  fs_dokil-version
             INTO fs_docu.
      APPEND fs_docu TO t_docu.
      CLEAR  fs_docu.
    ENDLOOP.                           " LOOP AT T_DOKIL INTO FS_DOKIL
  ENDIF.                               " IF SY-SUBRC EQ 0
ENDFORM.                               " GET_DOCU

*&---------------------------------------------------------------------*
*&      Form  GET_TEXT                                                 *
*&---------------------------------------------------------------------*
* Subroutine to get text elements                                      *
*----------------------------------------------------------------------*
* PV_NAME ==> Program Name                                             *
*----------------------------------------------------------------------*
FORM get_text USING pv_name TYPE trdir-name.

  DATA: lv_len(10) TYPE c.

  TYPES: BEGIN OF type_s_txtlang,
           language TYPE spras,
         END   OF type_s_txtlang.

  DATA: fs_txtlang TYPE type_s_txtlang,
        lt_txtlang TYPE TABLE OF type_s_txtlang.

  SELECT language
    FROM repotext
    INTO TABLE lt_txtlang
   WHERE progname = pv_name.

  IF sy-subrc EQ 0.

    LOOP AT lt_txtlang INTO fs_txtlang.
      READ TEXTPOOL pv_name INTO t_txt LANGUAGE fs_txtlang-language.
      IF sy-subrc EQ 0.
        LOOP AT t_txt INTO fs_txt.
          MOVE fs_txt-length TO lv_len.
          CONCATENATE 'T'          fs_txtlang-language
                      fs_txt-id    fs_txt-key
                      fs_txt-entry lv_len
                     INTO fs_text1 SEPARATED BY '*%'.
          APPEND fs_text1 TO t_text.
          CLEAR: fs_text1,
                 lv_len.
        ENDLOOP.                       " LOOP AT T_TXT INTO FS_TXT
* IF report title is not populated, exceptional cases
        CLEAR: w_lang.
        MOVE sy-langu TO w_lang.
        IF fs_txtlang-language = w_lang.
          CLEAR: fs_txt-key,
                 lv_len,
                 fs_text1,
                 fs_txt.

          READ TABLE t_txt INTO fs_txt WITH KEY id = 'R'.
          IF sy-subrc NE 0.
            lv_len = strlen( w_text ).
            CONCATENATE 'T'          fs_txtlang-language
                        'R'          fs_txt-key
                        w_text       lv_len
                       INTO fs_text1 SEPARATED BY '*%'.
            APPEND fs_text1 TO t_text.
            CLEAR: fs_text1,
                   lv_len.
          ENDIF.                       " IF SY-SUBRC NE 0
        ENDIF.                         " IF FS_TXTLANG-LANGUAGE...
      ENDIF.                           " IF SY-SUBRC EQ 0
    ENDLOOP.                           " LOOP AT lt_txtlang
  ENDIF.                               " IF SY-SUBRC EQ 0
ENDFORM.                               " GET_TEXT

*&---------------------------------------------------------------------*
*&      Form  GET_PFSTAT                                               *
*&---------------------------------------------------------------------*
* Subroutine to get pf-status                                          *
*----------------------------------------------------------------------*
* PV_NAME ==> Program Name                                             *
*----------------------------------------------------------------------*
FORM get_pfstat USING pv_name TYPE trdir-name.

  DATA:
    lt_langu TYPE TABLE OF sprsl,
    fs_langu TYPE sprsl.

  SELECT sprsl
    FROM rsmptexts
    INTO TABLE lt_langu
   WHERE progname = pv_name.

  IF sy-subrc EQ 0.
    SORT lt_langu.

    DELETE ADJACENT DUPLICATES FROM lt_langu.

    LOOP AT lt_langu INTO fs_langu.
      CLEAR: fs_adm,
             fs_sta, t_sta[],
             fs_fun, t_fun[],
             fs_men, t_men[],
             fs_mtx, t_mtx[],
             fs_act, t_act[],
             fs_but, t_but[],
             fs_pfk, t_pfk[],
             fs_set, t_set[],
             fs_atrt,t_atrt[],
             fs_tit, t_tit[],
             fs_biv, t_biv[].

      CALL FUNCTION 'RS_CUA_INTERNAL_FETCH'
        EXPORTING
          program         = pv_name
          language        = fs_langu
        IMPORTING
          adm             = fs_adm
        TABLES
          sta             = t_sta
          fun             = t_fun
          men             = t_men
          mtx             = t_mtx
          act             = t_act
          but             = t_but
          pfk             = t_pfk
          set             = t_set
          doc             = t_atrt
          tit             = t_tit
          biv             = t_biv
        EXCEPTIONS
          not_found       = 1
          unknown_version = 2
          OTHERS          = 3.

      IF sy-subrc EQ 0.

        CONCATENATE 'PLAN'
                    fs_langu
               INTO fs_pfs.
        APPEND fs_pfs TO t_pfs.
        CLEAR  fs_pfs.

        CLEAR: w_cnt3.
        PERFORM download_pf_tabs TABLES t_sta
                                 USING  c_stat
                                        fs_sta
                                        'FS_STA-'
                                        'PSTA'.

        PERFORM download_pf_tabs TABLES t_fun
                                 USING  c_funt
                                        fs_fun
                                        'FS_FUN-'
                                        'PFUN'.

        PERFORM download_pf_tabs TABLES t_men
                                 USING  c_men
                                        fs_men
                                        'FS_MEN-'
                                        'PMEN'.

        PERFORM download_pf_tabs TABLES t_mtx
                                 USING  c_mnlt
                                        fs_mtx
                                        'FS_MTX-'
                                        'PMTX'.

        PERFORM download_pf_tabs TABLES t_act
                                 USING  c_act
                                        fs_act
                                        'FS_ACT-'
                                        'PACT'.

        PERFORM download_pf_tabs TABLES t_but
                                 USING  c_but
                                        fs_but
                                        'FS_BUT-'
                                        'PBUT'.

        PERFORM download_pf_tabs TABLES t_pfk
                                 USING  c_pfk
                                        fs_pfk
                                        'FS_PFK-'
                                        'PPFK'.

        PERFORM download_pf_tabs TABLES t_set
                                 USING  c_staf
                                        fs_set
                                        'FS_SET-'
                                        'PSET'.

        PERFORM download_pf_tabs TABLES t_atrt
                                 USING  c_atrt
                                        fs_atrt
                                        'FS_ATRT-'
                                        'PATR'.

        PERFORM download_pf_tabs TABLES t_tit
                                 USING  c_titt
                                        fs_tit
                                        'FS_TIT-'
                                        'PTIT'.

        PERFORM download_pf_tabs TABLES t_biv
                                 USING  c_buts
                                        fs_biv
                                        'FS_BIV-'
                                        'PBIV'.
        CLEAR: w_cnt3.

        CONCATENATE 'PADM'
                    fs_adm-actcode    fs_adm-mencode    fs_adm-pfkcode
                    fs_adm-defaultact fs_adm-defaultpfk
                    fs_adm-mod_langu
               INTO fs_pfs
       SEPARATED BY ';'.
        APPEND fs_pfs TO t_pfs.
        CLEAR  fs_pfs.

      ELSE.
        MESSAGE 'Error during PF-STATUS download' TYPE 'E' DISPLAY LIKE
        'S'.
      ENDIF.                           " IF SY-SUBRC EQ 0
    ENDLOOP.                           " LOOP AT LT_LANGU INTO FS_LANGU
  ENDIF.                               " IF SY-SUBRC EQ 0

  CONCATENATE 'PTRK'
              fs_tadir-devclass
              fs_tadir-object
              p_prog
         INTO fs_pfs
 SEPARATED BY ';'.
  APPEND fs_pfs TO t_pfs.
  CLEAR  fs_pfs.
ENDFORM.                               " GET_PFSTAT

*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD                                                 *
*&---------------------------------------------------------------------*
* Subroutine to downlaod File to PC                                    *
*----------------------------------------------------------------------*
* PT_ITAB                                                              *
* PC_FILE ==> Filename                                                 *
* PC_TYPE ==> Filetype                                                 *
*----------------------------------------------------------------------*
FORM download TABLES pt_itab
              USING  pc_file TYPE string
                     pc_type TYPE char10.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = pc_file
      filetype                = pc_type
    TABLES
      data_tab                = pt_itab
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.

  IF sy-subrc NE 0.
    MESSAGE 'Error during file download' TYPE 'S'.
  ENDIF.                               " IF SY-SUBRC NE 0
ENDFORM.                               " DOWNLOAD

*&---------------------------------------------------------------------*
*&      Form  CHECK_PROG_STATUS                                        *
*&---------------------------------------------------------------------*
* Subroutine to check program status                                   *
*----------------------------------------------------------------------*
* There are no interface parameters to be passed to this subroutine    *
*----------------------------------------------------------------------*
FORM check_prog_status .

  SELECT obj_name
    FROM dwinactiv
    INTO w_obj
      UP TO 1 ROWS
   WHERE obj_name = p_prog.

  ENDSELECT.                           " SELECT OBJ_NAME...

  IF sy-subrc EQ 0.
    MESSAGE 'Given program is inactive, activate it before downloading'
       TYPE 'S'.
    STOP.
  ENDIF.                               " IF SY-SUBRC EQ 0
ENDFORM.                               " CHECK_PROG_STATUS

*&---------------------------------------------------------------------*
*&      Form  CHECK_PROG                                               *
*&---------------------------------------------------------------------*
* Subroutine to check if the program exists                            *
*----------------------------------------------------------------------*
* There are no interface parameters to be passed to this subroutine    *
*----------------------------------------------------------------------*
FORM check_prog .

  IF p_prog+0(1) = 'Y'
  OR p_prog+0(1) = 'Z'.
    SELECT SINGLE name                 " ABAP Program Name
             FROM trdir
             INTO w_name
            WHERE name = p_prog.

    IF sy-subrc EQ 0.

      CONCATENATE 'Program '
                   p_prog
                  ' already exists,'
                  'do you want to overwrite it?'
             INTO w_str
     SEPARATED BY space.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          text_question         = w_str
          display_cancel_button = ' '
        IMPORTING
          answer                = w_ans
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc EQ 0.
* If user doesn't want to overwrite the existing program,
* Stop and come out of the program
        IF w_ans = '2'.
          STOP.
* If the user wants to overwrite the existing program,
* delete it and continue
        ELSE.
          CALL FUNCTION 'RS_DELETE_PROGRAM'
            EXPORTING
              program            = p_prog
              with_cua           = 'X'
            EXCEPTIONS
              enqueue_lock       = 1
              object_not_found   = 2
              permission_failure = 3
              reject_deletion    = 4.

          IF sy-subrc EQ 1.
            MESSAGE
            'Another User is currently editing the given program'
               TYPE 'S'.
            STOP.
          ENDIF.                       " IF SY-SUBRC EQ 1
        ENDIF.                         " IF W_ANS = '2'
      ENDIF.                           " IF SY-SUBRC EQ 0
      CLEAR w_str.
    ENDIF.                             " IF SY-SUBRC EQ 0
  ELSE.
    MESSAGE 'Test objects cannot be created in foreign namespaces'
       TYPE 'S'.
    STOP.
  ENDIF.                               " IF P_PROG+0(1) = 'Y'...
ENDFORM.                               " CHECK_PROG

*&---------------------------------------------------------------------*
*&      Form  UPLOAD                                                   *
*&---------------------------------------------------------------------*
* Subroutine to Upload file data to internal table                     *
*----------------------------------------------------------------------*
* PT_ITAB                                                              *
* PC_FILE ==> Filename                                                 *
* PC_TYPE ==> Filetype                                                 *
*----------------------------------------------------------------------*
FORM upload  TABLES   pt_itab
             USING    pc_file TYPE string
                      pc_type TYPE char10.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = pc_file
      filetype                = pc_type
    TABLES
      data_tab                = pt_itab
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  IF sy-subrc NE 0.
    MESSAGE 'Error during file upload' TYPE 'S'.
  ENDIF.                               " IF SY-SUBRC NE 0
ENDFORM.                               " UPLOAD

*&---------------------------------------------------------------------*
*&      Form  PROCESS_DATA                                             *
*&---------------------------------------------------------------------*
* Subroutine to process data                                           *
*----------------------------------------------------------------------*
* There are no interface parameters to be passed to this subroutine    *
*----------------------------------------------------------------------*
FORM process_data .

  LOOP AT t_data INTO fs_data.
    CLEAR: fs_doc,
           fs_str.
    MOVE sy-tabix TO w_index.

    CASE fs_data+0(1).
* Header Text
      WHEN 'H'.
        DELETE t_data INDEX w_index.

* Code
      WHEN 'C'.
        MOVE fs_data+1 TO fs_code.
        APPEND fs_code TO t_code.
        CLEAR  fs_code.
        DELETE t_data INDEX w_index.

* Documentation
      WHEN 'D'.
        MOVE fs_data+1 TO fs_doc.
        IF fs_doc+0(5) = 'PGMID'.
          SHIFT fs_doc BY 5 PLACES.
          MOVE fs_doc TO w_pgmid.

        ELSEIF fs_doc+0(6) = 'OBJECT'.
          SHIFT fs_doc BY 6 PLACES.
          MOVE fs_doc TO w_object.
        ENDIF.                         " IF FS_DOC+0(5) = 'PGMID'

* Attributes
      WHEN 'A'.
        MOVE fs_data+1 TO fs_doc.
        IF fs_doc+0(4) = 'SUBC'.
          SHIFT fs_doc BY 4 PLACES.
          MOVE fs_doc TO fs_dir-subc.

        ELSEIF fs_doc+0(5) = 'FIXPT'.
          SHIFT fs_doc BY 5 PLACES.
          MOVE fs_doc TO fs_dir-fixpt.

        ELSEIF fs_doc+0(7) = 'UCCHECK'.
          SHIFT fs_doc BY 7 PLACES.
          MOVE fs_doc TO fs_dir-uccheck.

        ELSEIF fs_doc+0(4) = 'SECU'.
          SHIFT fs_doc BY 4 PLACES.
          MOVE fs_doc TO fs_dir-secu.

        ELSEIF fs_doc+0(4) = 'EDTX'.
          SHIFT fs_doc BY 4 PLACES.
          MOVE fs_doc TO fs_dir-edtx.

        ELSEIF fs_doc+0(4) = 'SSET'.
          SHIFT fs_doc BY 4 PLACES.
          MOVE fs_doc TO fs_dir-sset.

        ELSEIF fs_doc+0(7) = 'LDBNAME'.
          SHIFT fs_doc BY 7 PLACES.
          MOVE fs_doc TO fs_dir-ldbname.

        ELSEIF fs_doc+0(4) = 'APPL'.
          SHIFT fs_doc BY 4 PLACES.
          MOVE fs_doc TO fs_dir-appl.

        ELSEIF fs_doc+0(5) = 'RSTAT'.
          SHIFT fs_doc BY 5 PLACES.
          MOVE fs_doc TO fs_dir-rstat.

        ELSEIF fs_doc+0(4) = 'TYPE'.
          SHIFT fs_doc BY 4 PLACES.
          MOVE fs_doc TO fs_dir-type.
        ENDIF.                         " IF FS_DOC+0(4)..

        DELETE t_data INDEX w_index.

* PF-STATUS
      WHEN 'P'.
        MOVE fs_data+1 TO fs_doc.
        IF fs_doc+0(3) = 'TRK'.
          fs_str = fs_doc+4.
          SPLIT fs_str AT ';'
                     INTO fs_trkey-devclass
                          fs_trkey-obj_type
                          fs_trkey-obj_name.
        ENDIF.                         " IF FS_DOC+0(3)

* Text elements
      WHEN 'T'.
        MOVE fs_data TO fs_data2.
        APPEND fs_data2 TO t_data2.
        CLEAR  fs_data2.
        DELETE t_data INDEX w_index.
    ENDCASE.                           " CASE T_DATA+0(1)
  ENDLOOP.                             " LOOP AT T_DATA...
ENDFORM.                               " PROCESS_DATA

*&---------------------------------------------------------------------*
*&      Form  CREATE_PROG                                              *
*&---------------------------------------------------------------------*
* Subroutine to create new program                                     *
*----------------------------------------------------------------------*
* There are no interface parameters to be passed to this subroutine    *
*----------------------------------------------------------------------*
FORM create_prog .

* Creates a new program uploading source code and attributes
  INSERT REPORT p_prog
           FROM t_code
DIRECTORY ENTRY fs_dir.

* Create TADIR entry for the new program
  CALL FUNCTION 'TR_TADIR_POPUP_ENTRY_E071'
    EXPORTING
      wi_e071_pgmid             = w_pgmid
      wi_e071_object            = w_object
      wi_e071_obj_name          = w_prog2
    IMPORTING
      we_tadir                  = fs_tadir
      es_tdevc                  = fs_tdevc
    EXCEPTIONS
      display_mode              = 1
      exit                      = 2
      global_tadir_insert_error = 3
      no_repair_selected        = 4
      no_systemname             = 5
      no_systemtype             = 6
      no_tadir_type             = 7
      reserved_name             = 8
      tadir_enqueue_failed      = 9
      devclass_not_found        = 10
      tadir_not_exist           = 11
      object_exists             = 12
      internal_error            = 13
      object_append_error       = 14
      tadir_modify_error        = 15
      object_locked             = 16
      no_object_authority       = 17
      OTHERS                    = 18.

  IF sy-subrc NE 0.
    MESSAGE 'Error while creating TADIR entry' TYPE 'S'.
  ENDIF.                               " IF SY-SUBRC NE 0

* Upload text elements to the new program,
* Using translation they can be maintained in different languages
  MOVE 1 TO w_index.

  DESCRIBE TABLE t_data2 LINES w_cnt2.

  LOOP AT t_data2 INTO fs_data2.
    w_cnt3 = w_cnt3 + 1.
    CLEAR: fs_doc,fs_str.

    IF w_index = 1.
      MOVE fs_data2+3(1) TO w_char.
    ENDIF.                             " IF W_INDEX = 1
* Check if language is same
    IF w_char = fs_data2+3(1).
      MOVE fs_data2+6 TO fs_doc.
      SPLIT fs_doc AT '*%'
               INTO fs_txt-id
                    fs_txt-key
                    fs_txt-entry
                    w_len.
      MOVE w_len TO fs_txt-length.
      APPEND fs_txt TO t_txt.
      CLEAR  fs_txt.
      w_index = w_index + 1.
* If it comes to last line of the internal table
      IF w_cnt3 = w_cnt2.
* Upload text elements to the new program
        INSERT TEXTPOOL p_prog FROM t_txt
                               LANGUAGE w_char.
        CLEAR: w_char,
               fs_doc,
               fs_txt,
               t_txt[].
      ENDIF.                           " IF W_CNT3 = W_CNT2
* If language changes, insert text elements up to here
* into the given language
    ELSE.
* Upload text elements to the new program
      INSERT TEXTPOOL p_prog FROM t_txt
                             LANGUAGE w_char.
      CLEAR: w_char,
             fs_doc,
             t_txt,
             t_txt[].
* Append 1st line of new language here
      MOVE fs_data2+6 TO fs_doc.
      SPLIT fs_doc AT '*%'
               INTO fs_txt-id
                    fs_txt-key
                    fs_txt-entry
                    w_len.
      MOVE w_len TO fs_txt-length.
      APPEND fs_txt TO t_txt.
      CLEAR  fs_txt.
      MOVE 1 TO w_index.
    ENDIF.                             " IF W_CHAR =...
  ENDLOOP.                             " LOOP AT T_DATA2

  LOOP AT t_data INTO fs_data.
    CLEAR: fs_doc,
           fs_str.

    CASE fs_data+0(1).
* Documentation
      WHEN 'D'.
        MOVE fs_data+1 TO fs_doc.

        IF fs_doc+0(4) = 'LINE'.
          MOVE fs_doc+5 TO fs_str.
          SPLIT fs_str AT ';'
                     INTO fs_tline-tdformat
                          fs_tline-tdline.
          APPEND fs_tline TO t_tline.
          CLEAR: fs_tline,
                 fs_str.

        ELSEIF fs_doc+0(4)    = 'HEAD'.
          MOVE fs_doc+5 TO fs_str.
          SPLIT fs_str AT ';'
                     INTO  fs_thead-tdobject   fs_thead-tdname
                           fs_thead-tdid       fs_thead-tdspras
                           fs_thead-tdtitle    fs_thead-tdform
                           fs_thead-tdstyle    fs_thead-tdversion
                           fs_thead-tdfuser    fs_thead-tdfreles
                           fs_thead-tdfdate    fs_thead-tdftime
                           fs_thead-tdluser    fs_thead-tdlreles
                           fs_thead-tdldate    fs_thead-tdltime
                           fs_thead-tdlinesize fs_thead-tdtxtlines
                           fs_thead-tdhyphenat fs_thead-tdospras
                           fs_thead-tdtranstat fs_thead-tdmacode1
                           fs_thead-tdmacode2  fs_thead-tdrefobj
                           fs_thead-tdrefname  fs_thead-tdrefid
                           fs_thead-tdtexttype fs_thead-tdcompress
                           fs_thead-mandt      fs_thead-tdoclass
                           fs_thead-logsys.

          CLEAR fs_thead-tdname.
          MOVE w_prog3 TO fs_thead-tdname.
          CLEAR fs_str.

        ELSEIF fs_doc+0(8) = 'DOKSTATE'.
          SHIFT fs_doc BY 8 PLACES.
          MOVE fs_doc TO w_state.

        ELSEIF fs_doc+0(3) = 'TYP'.
          SHIFT fs_doc BY 3 PLACES.
          MOVE fs_doc TO w_typ.

        ELSEIF fs_doc+0(10) = 'DOKVERSION'.
          SHIFT fs_doc BY 10 PLACES.
          MOVE fs_doc TO w_version.

* Update
          CALL FUNCTION 'DOCU_UPDATE'
            EXPORTING
              head    = fs_thead
              state   = w_state
              typ     = w_typ
              version = w_version
            TABLES
              line    = t_tline.

          CLEAR: fs_tline,
                 t_tline[],
                 fs_thead,
                 w_state,
                 w_typ,
                 w_version.
        ENDIF.                         " IF FS_DOC+0(4) = 'LINE'

* PF-Status
      WHEN 'P'.
        MOVE fs_data+1 TO fs_doc.

        IF fs_doc+0(3) = 'LAN'.
          MOVE fs_doc+3 TO w_lang.

        ELSEIF fs_doc+0(3) = 'STA'.
          PERFORM populate_pf_tabs TABLES t_sta
                                    USING 'FS_STA'
                                          fs_sta
                                          c_stat.

        ELSEIF fs_doc+0(3) = 'FUN'.
          PERFORM populate_pf_tabs TABLES t_fun
                                    USING 'FS_FUN'
                                          fs_fun
                                          c_funt.

        ELSEIF fs_doc+0(3) = 'MEN'.
          PERFORM populate_pf_tabs TABLES t_men
                                    USING 'FS_MEN'
                                          fs_men
                                          c_men.

        ELSEIF fs_doc+0(3) = 'MTX'.
          PERFORM populate_pf_tabs TABLES t_mtx
                                    USING 'FS_MTX'
                                          fs_mtx
                                          c_mnlt.

        ELSEIF fs_doc+0(3) = 'ACT'.
          PERFORM populate_pf_tabs TABLES t_act
                                    USING 'FS_ACT'
                                          fs_act
                                          c_act.

        ELSEIF fs_doc+0(3) = 'BUT'.
          PERFORM populate_pf_tabs TABLES t_but
                                    USING 'FS_BUT'
                                          fs_but
                                          c_but.

        ELSEIF fs_doc+0(3) = 'PFK'.
          PERFORM populate_pf_tabs TABLES t_pfk
                                    USING 'FS_PFK'
                                          fs_pfk
                                          c_pfk.

        ELSEIF fs_doc+0(3) = 'SET'.
          PERFORM populate_pf_tabs TABLES t_set
                                    USING 'FS_SET'
                                          fs_set
                                          c_staf.

        ELSEIF fs_doc+0(3) = 'ATR'.
          PERFORM populate_pf_tabs TABLES t_atrt
                                    USING 'FS_ATRT'
                                          fs_atrt
                                          c_atrt.

        ELSEIF fs_doc+0(3) = 'TIT'.
          PERFORM populate_pf_tabs TABLES t_tit
                                    USING 'FS_TIT'
                                          fs_tit
                                          c_titt.

        ELSEIF fs_doc+0(3) = 'BIV'.
          PERFORM populate_pf_tabs TABLES t_biv
                                    USING 'FS_BIV'
                                          fs_biv
                                          c_buts.

        ELSEIF fs_doc+0(3) = 'ADM'.
          MOVE fs_doc+4 TO fs_str.
          SPLIT fs_str AT ';'
                     INTO fs_adm-actcode
                          fs_adm-mencode
                          fs_adm-pfkcode
                          fs_adm-defaultact
                          fs_adm-defaultpfk
                          fs_adm-mod_langu.

* Upload PF-STATUS to the new program
          CALL FUNCTION 'RS_CUA_INTERNAL_WRITE'
            EXPORTING
              program   = p_prog
              language  = w_lang
              tr_key    = fs_trkey
              adm       = fs_adm
            TABLES
              sta       = t_sta
              fun       = t_fun
              men       = t_men
              mtx       = t_mtx
              act       = t_act
              but       = t_but
              pfk       = t_pfk
              set       = t_set
              doc       = t_atrt
              tit       = t_tit
              biv       = t_biv
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.

          IF sy-subrc NE 0.
            MESSAGE 'Error during PF-STATUS upload' TYPE 'S'.
          ENDIF.                       " IF SY-SUBRC NE 0
          CLEAR: w_lang, fs_adm,
                 fs_sta, t_sta[],
                 fs_fun, t_fun[],
                 fs_men, t_men[],
                 fs_mtx, t_mtx[],
                 fs_act, t_act[],
                 fs_but, t_but[],
                 fs_pfk, t_pfk[],
                 fs_set, t_set[],
                 fs_atrt,t_atrt[],
                 fs_tit, t_tit[],
                 fs_biv, t_biv[].
        ENDIF.                         " IF FS_DOC+0(3) = 'LAN'
    ENDCASE.                           " CASE FS_DATA+0(1)
  ENDLOOP.                             " LOOP AT T_DATA...

  SYNTAX-CHECK FOR t_code MESSAGE w_mess
                             LINE w_lin
                             WORD w_wrd
                          PROGRAM p_prog.
  IF sy-subrc NE 0.
    CONCATENATE 'Program '
                 p_prog
                ' is syntactically incorrect,'
                'correct it before executing'
           INTO w_str
   SEPARATED BY space.

    MESSAGE w_str TYPE 'S'.
    CLEAR w_str.
    STOP.
  ELSE.
    CONCATENATE p_prog
                ' created successfully'
           INTO w_str
   SEPARATED BY space.

    MESSAGE w_str TYPE 'S'.
    CLEAR w_str.
  ENDIF.                               " IF SY-SUBRC NE 0
ENDFORM.                               " CREATE_PROG

*&---------------------------------------------------------------------*
*&      Form  download_pf_tabs                                         *
*&---------------------------------------------------------------------*
* This subroutine downloads PF Tabs                                    *
*----------------------------------------------------------------------*
*  PT_TAB                                                              *
*  PC_TABNAME ==> Text                                                 *
*  PC_WA      ==> Text                                                 *
*  PC_TXT     ==> Text                                                 *
*  PC_CONS    ==> Text                                                 *
*----------------------------------------------------------------------*
FORM download_pf_tabs TABLES pt_tab
                       USING pc_tabname
                             pc_wa
                             pc_txt
                             pc_cons.
  CLEAR: fs_dd03l,t_dd03l[].

  SELECT fieldname
    FROM dd03l
    INTO TABLE t_dd03l
   WHERE tabname = pc_tabname.

  IF sy-subrc EQ 0.
    CLEAR: w_cnt3.
    LOOP AT t_dd03l INTO fs_dd03l WHERE fieldname = '.INCLUDE'.
      DELETE TABLE t_dd03l FROM fs_dd03l.
    ENDLOOP.                           " LOOP AT T_DD03L INTO...
    DESCRIBE TABLE t_dd03l LINES w_cnt3.
  ENDIF.                               " IF SY-SUBRC EQ 0

  LOOP AT pt_tab INTO pc_wa.
    CLEAR: w_index,
           w_field,
           fs_pfs.

    LOOP AT t_dd03l INTO fs_dd03l.
      MOVE sy-tabix TO w_index.
      CONCATENATE pc_txt fs_dd03l-fieldname INTO w_field.
      CONDENSE w_field NO-GAPS.
      ASSIGN (w_field) TO <fs1>.
      IF <fs1> IS ASSIGNED.
        IF w_index = 1.
          CONCATENATE pc_cons
                      fs_dd03l-fieldname '*' <fs1>
                      INTO fs_pfs.
        ELSE.
          CONCATENATE fs_pfs
                      ';'
                      fs_dd03l-fieldname '*' <fs1>
                      INTO fs_pfs.
        ENDIF.                         " IF W_INDEX = 1
      ENDIF.                           " IF <FS1> IS ASSIGNED
    ENDLOOP.                           " LOOP AT T_DD03L INTO...
    APPEND fs_pfs TO t_pfs.
  ENDLOOP.                             " LOOP AT P_TAB INTO P_WA
ENDFORM.                               " DOWNLOAD_PF_TABS

*&---------------------------------------------------------------------*
*&      Form  POPULATE_PF_TABS                                         *
*&---------------------------------------------------------------------*
* This subroutine populates PF Tabs                                    *
*----------------------------------------------------------------------*
* PT_TAB                                                               *
* PC_WANAME  ==>  Text                                                 *
* PC_WA      ==>  Text                                                 *
* PC_STRUCT  ==>  Text                                                 *
*----------------------------------------------------------------------*
FORM populate_pf_tabs TABLES pt_tab
                       USING pc_waname
                             pc_wa
                             pc_struct.

  UNASSIGN: <fs1>.

  FIELD-SYMBOLS: <fs_wa>.

  CLEAR: w_str,
         w_cnt2,
         fs_str.

  SELECT fieldname
    FROM dd03l
    INTO TABLE t_dd03l
   WHERE tabname = pc_struct.

  IF sy-subrc EQ 0.
    SORT t_dd03l.

    MOVE fs_doc+3 TO fs_str.
    ASSIGN (pc_waname) TO <fs_wa>.

    WHILE NOT fs_str IS INITIAL.
      IF fs_str CS c_sep.
        MOVE sy-fdpos TO w_cnt2.
        MOVE fs_str+0(w_cnt2) TO w_str.
        w_cnt2 = w_cnt2 + 1.
        SHIFT fs_str BY w_cnt2 PLACES LEFT.

        IF w_str CS c_sep2.
          CLEAR: w_cnt2.
          MOVE sy-fdpos TO w_cnt2.
          MOVE w_str+0(w_cnt2) TO w_wrd.
          w_cnt2 = w_cnt2 + 1.
          MOVE w_str+w_cnt2 TO w_val.

          READ TABLE t_dd03l INTO fs_dd03l WITH KEY
                        fieldname = w_wrd BINARY SEARCH.
          IF sy-subrc EQ 0.
            IF <fs_wa> IS ASSIGNED.
              ASSIGN COMPONENT fs_dd03l-fieldname OF
                       STRUCTURE <fs_wa> TO <fs1>.
              IF <fs1> IS ASSIGNED.
                MOVE w_val TO <fs1>.
                UNASSIGN <fs1>.
              ENDIF.                   " IF <FS1> IS ASSIGNED
            ENDIF.                     " IF <FS_WA> IS ASSIGNED
            CLEAR: w_cnt2,
                   w_str,
                   w_wrd,
                   w_val,
                   fs_dd03l.
          ENDIF.                       " IF SY-SUBRC EQ 0
        ENDIF.                         " IF W_STR CS C_SEP2
      ELSE.
        IF fs_str CS c_sep2.
          CLEAR: w_cnt2.
          MOVE sy-fdpos TO w_cnt2.
          MOVE fs_str+0(w_cnt2) TO w_wrd.
          w_cnt2 = w_cnt2 + 1.
          MOVE fs_str+w_cnt2 TO w_val.

          READ TABLE t_dd03l INTO fs_dd03l WITH KEY
                        fieldname = w_wrd BINARY SEARCH.
          IF sy-subrc EQ 0.
            IF <fs_wa> IS ASSIGNED.
              ASSIGN COMPONENT fs_dd03l-fieldname OF
                       STRUCTURE <fs_wa> TO <fs1>.
              IF <fs1> IS ASSIGNED.
                MOVE w_val TO <fs1>.
                UNASSIGN <fs1>.
              ENDIF.                   " IF <FS1> IS ASSIGNED
            ENDIF.                     " IF <FS_WA> IS ASSIGNED
            CLEAR: w_cnt2,
                 w_str,
                 w_wrd,
                 w_val,
                 fs_dd03l,
                 fs_str.
          ENDIF.                       " IF SY-SUBRC EQ 0
        ENDIF.                         " IF FS_STR CS C_SEP2
      ENDIF.                           " IF FS_STR CS C_SEP
    ENDWHILE.                          " WHILE NOT FS_STR IS INITIAL

    APPEND pc_wa TO pt_tab.
    CLEAR  pc_wa.
  ENDIF.                               " IF SY-SUBRC EQ 0

  UNASSIGN: <fs1>,
            <fs_wa>.
ENDFORM.                               " POPULATE_PF_TABS
