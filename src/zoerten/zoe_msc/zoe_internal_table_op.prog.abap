*&---------------------------------------------------------------------*
*& Report ZOE_INTERNAL_TABLE_OP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_internal_table_op.

* Type declaration
TYPES: BEGIN OF ty_mara,
         matnr LIKE mara-matnr,
         mtart LIKE mara-mtart,
       END OF ty_mara.

* Internal table declaration
DATA:
  t_mara  TYPE STANDARD TABLE OF ty_mara,
  t_mara1 TYPE SORTED TABLE OF ty_mara
          WITH NON-UNIQUE KEY mtart.

* Variable declaration
DATA:
  w_counter  TYPE i,
  w_runtime1 TYPE i,
  w_runtime2 TYPE i,
  w_tabix    LIKE sy-tabix.

* Table workarea definition
DATA:
  wa_mara TYPE ty_mara.
SELECT matnr                           " Material Number
       mtart                           " Material Type
  FROM mara
  INTO TABLE t_mara.
t_mara1[] = t_mara[].
* CASE 1: Processing internal table using LOOP..WHERE Condition
GET RUN TIME FIELD w_runtime1.
LOOP AT t_mara INTO wa_mara WHERE mtart EQ 'FHMI'.
  ADD 1 TO w_counter.
ENDLOOP.
GET RUN TIME FIELD w_runtime2.
* Calculate Runtime
w_runtime2 = w_runtime2 - w_runtime1.
WRITE w_runtime2.
CLEAR w_counter.
* CASE 2: Using a Sorted table
GET RUN TIME FIELD w_runtime1.
LOOP AT t_mara1 INTO wa_mara WHERE mtart EQ 'FHMI'.
  ADD 1 TO w_counter.
ENDLOOP.
GET RUN TIME FIELD w_runtime2.
* Calculate Runtime
w_runtime2 = w_runtime2 - w_runtime1.
WRITE w_runtime2.
CLEAR w_counter.
* CASE 3: Using INDEX on a sorted table
GET RUN TIME FIELD w_runtime1.
READ TABLE t_mara1 INTO wa_mara WITH KEY mtart = 'FHMI'.
IF sy-subrc EQ 0.
  w_tabix = sy-tabix + 1.
  ADD 1 TO w_counter.
  LOOP AT t_mara1 INTO wa_mara FROM w_tabix.
    IF wa_mara-mtart NE 'FHMI'.
      EXIT.
    ENDIF.
    ADD 1 TO w_counter.
  ENDLOOP.
ENDIF.
GET RUN TIME FIELD w_runtime2.
* Calculate Runtime
w_runtime2 = w_runtime2 - w_runtime1.
WRITE w_runtime2.
