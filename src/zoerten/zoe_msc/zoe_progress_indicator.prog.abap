*&---------------------------------------------------------------------*
*& Report ZOE_PROGRESS_INDICATOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_progress_indicator.

DO 10 TIMES.

  DATA(lv_percentage) = 10 * sy-index.

  DATA(lv_percentage_text) = |{ lv_percentage }% completed|.

  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
    EXPORTING
      percentage = lv_percentage
      text       = lv_percentage_text.

  WAIT UP TO 1 SECONDS.

ENDDO.

*SELECT *
*  FROM mara
*  INTO TABLE @DATA(lt_mara).
*
*DATA(lv_line_count) = lines( lt_mara ).
*
*DATA: lv_item_percentage TYPE rrfactor.
*
*lv_item_percentage = 100 / lv_line_count.
*
*LOOP AT lt_mara INTO DATA(ls_mara).
*
*  DATA(lv_percentage) = lv_item_percentage * sy-tabix.
*
*  DATA(lv_percentage_text) = |{ lv_percentage }% { TEXT-000 }|.
*
*  CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
*    EXPORTING
*      percentage = lv_percentage
*      text       = lv_percentage_text.
*
*ENDLOOP.
