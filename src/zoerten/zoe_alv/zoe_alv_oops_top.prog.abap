*&---------------------------------------------------------------------*
*& Include          ZOE_ALV_OOPS_TOP
*&---------------------------------------------------------------------*
************************************************************************
*TABLES                                                                *
************************************************************************


************************************************************************
* TYPE POOLS                                                           *
************************************************************************


************************************************************************
*DATA TYPES                                                            *
************************************************************************
*TYPES: GTTY_XXXX,
*       GSTY_XXXX.
TYPES: BEGIN OF ty_output,
         ebeln TYPE ebeln,
         bukrs TYPE bukrs,
         bstyp TYPE bstyp,
         aedat TYPE aedat,
         ernam TYPE ernam,
       END OF ty_output.


TYPES: BEGIN OF ty_output2,
         ebeln TYPE ebeln,
         aedat TYPE erdat,
         ernam TYPE ernam,
         ebelp TYPE ebelp,
         matnr TYPE matnr,
         werks TYPE werks_d,
         menge TYPE bstmg,
         meins TYPE bstme,
         netwr TYPE bwert,
         dummy TYPE xfeld,
       END OF ty_output2.

************************************************************************
*CONSTANTS                                                             *
************************************************************************

************************************************************************
*FIELD SYMBOLS                                                         *
************************************************************************


************************************************************************
*DATA DECLARATION                                                      *
************************************************************************
DATA: lt_ekko      TYPE TABLE OF ekko,
      ls_ekko      TYPE ekko,
      lt_ekpo      TYPE TABLE OF ekpo,
      ls_ekpo      TYPE ekpo,
      lt_mara      TYPE TABLE OF mara,
      ls_mara      TYPE mara,
      lt_output    TYPE TABLE OF ty_output,
      ls_output    TYPE ty_output,
      lt_output2   TYPE TABLE OF ty_output2,
      ls_output2   TYPE ty_output2,
      lt_fieldcat  TYPE lvc_t_fcat,
      lw_fieldcat  TYPE lvc_s_fcat,
      lw_layout    TYPE lvc_s_layo,
      grid         TYPE REF TO cl_gui_alv_grid,
      container    TYPE REF TO cl_gui_custom_container,
      lt_fieldcat2 TYPE lvc_t_fcat,
      lw_fieldcat2 TYPE lvc_s_fcat,
      lw_layout2   TYPE lvc_s_layo,
      grid2        TYPE REF TO cl_gui_alv_grid,
      container2   TYPE REF TO cl_gui_custom_container.

DATA:       gv_int TYPE i.

DATA: gt_mailsub TYPE sodocchgi1.
DATA: gt_mailrec TYPE STANDARD TABLE OF somlrec90 WITH HEADER LINE.
DATA: gt_mailtxt TYPE STANDARD TABLE OF soli WITH HEADER LINE.

************************************************************************
*STRUCTURES & INTERNAL TABLES                                          *
************************************************************************


************************************************************************
*SELECTION SCREENS                                                     *
************************************************************************


************************************************************************
*RANGES                                                                *
************************************************************************
