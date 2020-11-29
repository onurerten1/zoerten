*&---------------------------------------------------------------------*
*& Report ZOE_DYNAMIC_MAPPING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_dynamic_mapping.

PARAMETERS: p_matnr TYPE matnr.

DATA: gt_mara TYPE STANDARD TABLE OF mara,
      gs_mara LIKE LINE OF gt_mara.

TYPES: BEGIN OF ty_copy1,
         mandt TYPE mara-mandt,
         matnr TYPE mara-matnr,
         ersda TYPE mara-ersda,
         ernam TYPE mara-ernam,
         laeda TYPE mara-laeda,
         aenam TYPE mara-aenam,
         vpsta TYPE mara-vpsta,
         pstat TYPE mara-pstat,
         lvorm TYPE mara-lvorm,
         mtart TYPE mara-mtart,
       END OF ty_copy1.

TYPES: BEGIN OF ty_copy2,
         mandt TYPE mara-mandt,
         matnr TYPE mara-matnr,
         mbrsh TYPE mara-mbrsh,
         vpsta TYPE mara-vpsta,
         pstat TYPE mara-pstat,
         matkl TYPE mara-matkl,
         bismt TYPE mara-bismt,
         meins TYPE mara-meins,
         bstme TYPE mara-bstme,
       END OF ty_copy2.

DATA: gt_copy1 TYPE STANDARD TABLE OF ty_copy1,
      gs_copy1 LIKE LINE OF gt_copy1,
      gt_copy2 TYPE STANDARD TABLE OF ty_copy2,
      gs_copy2 LIKE LINE OF gt_copy2.

SELECT SINGLE *
  FROM mara
  INTO gs_mara
  WHERE matnr EQ p_matnr.

IF gs_mara IS NOT INITIAL.
  MOVE-CORRESPONDING gs_mara TO gs_copy1.
  MOVE-CORRESPONDING gs_mara TO gs_copy2.
ENDIF.

CLEAR: gs_mara.

PERFORM dynamic_mapping USING    'MARA'
                                 gs_copy1
                        CHANGING gs_mara.

PERFORM dynamic_mapping USING    'MARA'
                               gs_copy2
                      CHANGING gs_mara.
*&---------------------------------------------------------------------*
*& Form DYNAMIC_MAPPING
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> GT_COPY2
*&      <-- GT_MARA
*&---------------------------------------------------------------------*
FORM dynamic_mapping  USING    p_table TYPE c
                               p_gs_copy
                      CHANGING p_gs_mara.

  DATA: idetails      TYPE abap_compdescr_tab,
        xdetails      TYPE abap_compdescr,
        ref_table_des TYPE REF TO cl_abap_structdescr.

  FIELD-SYMBOLS: <fs1> TYPE any,
                 <fs2> TYPE any.

  ref_table_des ?= cl_abap_typedescr=>describe_by_name( p_table ).
  idetails[] = ref_table_des->components[].

  LOOP AT idetails INTO xdetails.

    ASSIGN COMPONENT xdetails-name OF STRUCTURE p_gs_copy TO <fs1>.
    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    ASSIGN COMPONENT xdetails-name OF STRUCTURE p_gs_mara TO <fs2>.
    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    IF <fs2> IS INITIAL.
      <fs2> = <fs1>.
    ENDIF.

  ENDLOOP.

ENDFORM.
