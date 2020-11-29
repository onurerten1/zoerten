*&---------------------------------------------------------------------*
*& Report ZOE_NESTED_LOOP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_nested_loop.

TABLES:
  likp,
  lips.

DATA:
  t_likp TYPE TABLE OF likp,
  t_lips TYPE TABLE OF lips.

DATA:
  w_runtime1 TYPE i,
  w_runtime2 TYPE i.

START-OF-SELECTION.
  SELECT *
    FROM likp
    INTO TABLE t_likp.

  SELECT *
    FROM lips
    INTO TABLE t_lips.

  GET RUN TIME FIELD w_runtime1.

  LOOP AT t_likp INTO likp.
    LOOP AT t_lips INTO lips WHERE vbeln EQ likp-vbeln.
    ENDLOOP.
  ENDLOOP.

  GET RUN TIME FIELD w_runtime2.

  w_runtime2 = w_runtime2 - w_runtime1.

  WRITE w_runtime2.
