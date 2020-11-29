*&---------------------------------------------------------------------*
*& Report zoe_amdp02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_amdp02.

PARAMETERS: p_vbeln TYPE vbeln.

zoe_amdp02=>get_salesorder_details(
            EXPORTING iv_vbeln = p_vbeln
            IMPORTING et_order = DATA(lt_order) ).

cl_demo_output=>display_data( name = 'Sales Order Details'
                              value = lt_order ).
