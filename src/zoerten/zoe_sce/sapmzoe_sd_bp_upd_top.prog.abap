*&---------------------------------------------------------------------*
*& Include SAPMZOE_SD_BP_UPD_TOP                    - Module Pool      SAPMZOE_SD_BP_UPD
*&---------------------------------------------------------------------*
PROGRAM sapmzoe_sd_bp_upd.


TABLES: t005s, t005u, t005t, zoe_sd_bp_upd.
DATA: p_customer, p_vendor.

DATA: ok_code TYPE sy-ucomm.

DATA: gt_ucomm LIKE TABLE OF sy-ucomm.
DATA: gs_ucomm LIKE LINE OF gt_ucomm.

DATA: gv_int TYPE i.

DATA: BEGIN OF gs_cust OCCURS 0,
        flg,
        kunnr LIKE kna1-kunnr,
        name1 LIKE kna1-name1,
        name2 LIKE kna1-name2,
        land1 LIKE kna1-land1,
        regio LIKE kna1-regio,
        telf1 LIKE kna1-telf1,
        adrnr LIKE kna1-adrnr,
      END OF gs_cust.

DATA: gt_cust LIKE TABLE OF gs_cust WITH HEADER LINE.
DATA: gs_cust2 LIKE gs_cust.

DATA: BEGIN OF gs_vendor OCCURS 0,
        flg,
        lifnr LIKE lfa1-lifnr,
        name1 LIKE lfa1-name1,
        name2 LIKE lfa1-name2,
        land1 LIKE lfa1-land1,
        regio LIKE lfa1-regio,
        telf1 LIKE lfa1-telf1,
        adrnr LIKE lfa1-adrnr,
      END OF gs_vendor.

DATA: gt_vendor LIKE TABLE OF gs_vendor WITH HEADER LINE.
DATA: gs_vendor2 LIKE gs_vendor.

DATA : it_return  LIKE ddshretval OCCURS 0 WITH HEADER LINE,
       it_return1 LIKE ddshretval OCCURS 0 WITH HEADER LINE,
       it_return2 LIKE ddshretval OCCURS 0 WITH HEADER LINE.

DATA: BEGIN OF it_land1 OCCURS 0,
        land1 LIKE t005t-land1,
        landx LIKE t005t-landx,
      END OF it_land1.

DATA: BEGIN OF it_bland OCCURS 0,
        bland LIKE t005s-bland,
        bezei LIKE t005u-bezei,
      END OF it_bland.

DATA: but01(20).
DATA: gv_int_cd TYPE i.
DATA: gv_title TYPE i.

DATA: gs_cust_land1(20),
      gs_cust_regio(20),
      gs_vendor_land1(20),
      gs_vendor_regio(20).

DATA: BEGIN OF gs_tabc,
        flg,
        number    LIKE zoe_sd_bp_upd-cust_vend_no,
        names(60) TYPE c,
        telf1     LIKE zoe_sd_bp_upd-telf1,
        adrnr     LIKE zoe_sd_bp_upd-adrnr,
      END OF gs_tabc.

DATA: gt_tabc LIKE TABLE OF gs_tabc WITH HEADER LINE.

DATA: itab LIKE TABLE OF gs_tabc WITH HEADER LINE.

DATA: wa LIKE LINE OF itab.
DATA: fill TYPE i.

DATA: idx   TYPE i,
      line  TYPE i,
      lines TYPE i,
      limit TYPE i,
      c     TYPE i,
      n1    TYPE i VALUE 5,
      n2    TYPE i VALUE 25.

DATA:  save_ok TYPE sy-ucomm.

DATA: gv_cv(20),
      gv_names(20) .

*&SPWIZARD: DECLARATION OF TABLECONTROL 'G_TC_TAB' ITSELF
CONTROLS: g_tc_tab TYPE TABLEVIEW USING SCREEN 0200.

*&SPWIZARD: LINES OF TABLECONTROL 'G_TC_TAB'
DATA:     g_g_tc_tab_lines  LIKE sy-loopc.
