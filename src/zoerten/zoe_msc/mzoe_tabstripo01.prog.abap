*&---------------------------------------------------------------------*
*& Include MZOE_TABSTRIPO01
*&---------------------------------------------------------------------*

*&SPWIZARD: OUTPUT MODULE FOR TS 'TABSTRIP'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: SETS ACTIVE TAB
MODULE tabstrip_active_tab_set OUTPUT.
  tabstrip-activetab = g_tabstrip-pressed_tab.
  CASE g_tabstrip-pressed_tab.
    WHEN c_tabstrip-tab1.
      g_tabstrip-subscreen = '0101'.
    WHEN c_tabstrip-tab2.
      g_tabstrip-subscreen = '0102'.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0110 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0110 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.
  SELECT SINGLE vbeln,
                erdat,
                erzet,
                ernam
    FROM vbak
    INTO (@vbak-vbeln, @vbak-erdat, @vbak-erzet, @vbak-ernam).

  SELECT SINGLE vbeln,
                posnr,
                matnr,
                matwa
    FROM vbap
    INTO (@vbap-vbeln, @vbap-posnr, @vbap-matnr, @vbap-matwa).
ENDMODULE.
