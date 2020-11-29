REPORT zoe_dynamic_table2.

TYPE-POOLS: slis.

FIELD-SYMBOLS: <t_dyntable>  TYPE STANDARD TABLE,

               <fs_dyntable>,

               <fs_fldval>   TYPE any.

PARAMETERS: p_cols(5) TYPE c.

DATA: t_newtable   TYPE REF TO data,

      t_newline    TYPE REF TO data,

      fs_fldcat     TYPE slis_t_fieldcat_alv,

      t_fldcat     TYPE lvc_t_fcat,

      wa_it_fldcat TYPE lvc_s_fcat,

      wa_colno(2)  TYPE n,

      wa_flname(5) TYPE c.

* Create fields .

DO p_cols TIMES.

  CLEAR wa_it_fldcat.

  MOVE sy-index TO wa_colno.

  CONCATENATE 'COL'

              wa_colno

         INTO wa_flname.

  wa_it_fldcat-fieldname = wa_flname.

  wa_it_fldcat-datatype = 'CHAR'.

  wa_it_fldcat-intlen = 10.

  APPEND wa_it_fldcat TO t_fldcat.

ENDDO.

* Create dynamic internal table and assign to FS

CALL METHOD cl_alv_table_create=>create_dynamic_table
  EXPORTING
    it_fieldcatalog = t_fldcat
  IMPORTING
    ep_table        = t_newtable.

ASSIGN t_newtable->* TO <t_dyntable>.

* Create dynamic work area and assign to FS

CREATE DATA t_newline LIKE LINE OF <t_dyntable>.

ASSIGN t_newline->* TO <fs_dyntable>.

DATA: fieldname(20) TYPE c.

DATA: fieldvalue(10) TYPE c.

DATA: index(3) TYPE c.

DO p_cols TIMES.

  index = sy-index.

  MOVE sy-index TO wa_colno.

  CONCATENATE 'COL'

              wa_colno

         INTO wa_flname.

* Set up fieldvalue

  CONCATENATE 'VALUE' index INTO

              fieldvalue.

  CONDENSE    fieldvalue NO-GAPS.

  ASSIGN COMPONENT  wa_flname

      OF STRUCTURE <fs_dyntable> TO <fs_fldval>.

  <fs_fldval> =  fieldvalue.

ENDDO.

* Append to the dynamic internal table

APPEND <fs_dyntable> TO <t_dyntable>.

DATA: wa_cat LIKE LINE OF fs_fldcat.

DO p_cols TIMES.

  CLEAR wa_cat.

  MOVE sy-index TO wa_colno.

  CONCATENATE 'COL'

              wa_colno

         INTO wa_flname.

  wa_cat-fieldname = wa_flname.

  wa_cat-seltext_s = wa_flname.

  wa_cat-outputlen = '10'.

  APPEND wa_cat TO fs_fldcat.

ENDDO.

* Call ABAP List Viewer (ALV)

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
  EXPORTING
    it_fieldcat = fs_fldcat
  TABLES
    t_outtab    = <t_dyntable>.
