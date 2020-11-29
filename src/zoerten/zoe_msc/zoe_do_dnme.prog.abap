*&---------------------------------------------------------------------*
*& Report ZOE_DO_DNME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_do_dnme.
DATA: ynbr     LIKE mchb-clabs VALUE '15',
      clabs    LIKE mchb-clabs VALUE '10',
      sernr    LIKE equi-sernr VALUE 'SY10000009',
      serialno LIKE equi-sernr.


DATA n(8) TYPE n.
DATA(lv_fark) = ynbr - clabs.
DO lv_fark TIMES.
  n = sernr+2(8).
  n = n + 1.
  sernr+2(8) = n.
  serialno = sernr.
  WRITE :/ serialno.
ENDDO.
*  APPEND gs_sernum TO gt_sernum.
