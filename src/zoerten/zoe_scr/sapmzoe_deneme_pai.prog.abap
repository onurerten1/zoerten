*&---------------------------------------------------------------------*
*& Include          SAPMZOE_DENEME_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.


  CASE sy-ucomm.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'RAD'.
      IF rb0 = 'X'.
        gv_sum = gv_sum + 0.
        p_sel = 0.
      ELSEIF rb1 = 'X'.
        gv_sum = gv_sum + 1.
        p_sel = 1.
      ELSEIF rb2 = 'X'.
        gv_sum = gv_sum + 2.
        p_sel = 2.
      ELSEIF rb3 = 'X'.
        gv_sum = gv_sum + 3.
        p_sel = 3.
      ELSEIF rb4 = 'X'.
        gv_sum = gv_sum + 4.
        p_sel = 4.
      ELSEIF rb5 = 'X'.
        gv_sum = gv_sum + 5.
        p_sel = 5.
      ELSEIF rb6 = 'X'.
        gv_sum = gv_sum + 6.
        p_sel = 6.
      ELSEIF rb7 = 'X'.
        gv_sum = gv_sum + 7.
        p_sel = 7.
      ELSEIF rb8 = 'X'.
        gv_sum = gv_sum + 8.
        p_sel = 8.
      ELSEIF rb9 = 'X'.
        gv_sum = gv_sum + 9.
        p_sel = 9.
      ENDIF.
      p_sum = gv_sum.
    WHEN 'BUT01'.
      CLEAR p_check.
      IF chk1 = 'X'.
        CONCATENATE p_check '1' INTO p_check SEPARATED BY space..
      ENDIF.
      IF chk2 = 'X'.
        CONCATENATE p_check '2' INTO p_check SEPARATED BY space.
      ENDIF.
      IF chk3 = 'X'.
        CONCATENATE p_check '3' INTO p_check SEPARATED BY space.
      ENDIF.
      CONCATENATE p_check '(Selected Checkboxes)' INTO p_check SEPARATED BY space.
      CONDENSE p_check.
      IF chk1 = '' AND chk2 = '' AND chk3 = ''.
        p_check = 'No Selected Checkboxes'.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.



ENDMODULE.
