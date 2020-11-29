*&---------------------------------------------------------------------*
*& Include          ZEGT00_OE_SENARYO1_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form SCREEN_LOOP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM screen_loop.

  LOOP AT SCREEN.
    CASE screen-group1.
      WHEN 'GR1'.
        IF pa_rb2 = 'X' OR pa_rb3 = 'X'.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
      WHEN 'GR2'.
        IF pa_rb1 = 'X' OR pa_rb3 = 'X'.
          screen-input = 0.
          screen-invisible = 1.
        ENDIF.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  IF pa_rb1 = 'X'.
    SELECT mchb~matnr makt~maktx mchb~werks t001w~name1
                  mchb~lgort mchb~charg mchb~clabs
       INTO CORRESPONDING FIELDS OF TABLE gt_data
       FROM mchb LEFT OUTER JOIN makt
       ON mchb~matnr EQ makt~matnr
       AND makt~spras EQ sy-langu
       LEFT OUTER JOIN t001w
       ON mchb~werks EQ t001w~werks
       WHERE mchb~matnr IN so_matnr
       AND mchb~werks IN so_werks
       AND mchb~charg IN so_charg.
  ELSEIF pa_rb2 = 'X'.
    SELECT mard~matnr makt~maktx mard~werks t001w~name1
                mard~lgort mard~labst AS clabs
      INTO CORRESPONDING FIELDS OF TABLE gt_data
      FROM mard LEFT OUTER JOIN makt
      ON mard~matnr EQ makt~matnr
      AND makt~spras EQ sy-langu
      LEFT OUTER JOIN t001w
      ON mard~werks EQ t001w~werks
      WHERE mard~matnr IN so_matnr
      AND mard~werks IN so_werks
      AND mard~lgort IN so_lgort.
  ELSEIF pa_rb3 = 'X'.
    SELECT mchb~matnr makt~maktx mchb~werks t001w~name1
                     SUM( mchb~clabs ) AS clabs
      INTO CORRESPONDING FIELDS OF TABLE gt_data
      FROM mchb LEFT OUTER JOIN makt
      ON mchb~matnr EQ makt~matnr
      AND makt~spras EQ sy-langu
      LEFT OUTER JOIN t001w
      ON mchb~werks EQ t001w~werks
      WHERE mchb~matnr IN so_matnr
      AND mchb~werks IN so_werks
      GROUP BY mchb~matnr mchb~matnr makt~maktx mchb~werks t001w~name1.


  ENDIF.




  IF pa_rb1 = 'X' .
    gv_num = '01'.
  ELSEIF pa_rb2 = 'X' .
    gv_num = '02'.
  ELSEIF pa_rb3 = 'X' .
    gv_num = '03'.
  ENDIF.




  DATA: ls_stokupd LIKE zmb_mm_stokup_oe.

  " Tabloda veri var mı yok mu?
  LOOP AT gt_data.
    CLEAR:ls_stokupd.
    SELECT SINGLE * FROM zmb_mm_stokup_oe
      INTO ls_stokupd
      WHERE stok_tipi = gv_num          AND
            matnr     = gt_data-matnr   AND
            werks     = gt_data-werks   AND
            lgort     = gt_data-lgort   AND
            charg     = gt_data-charg."   AND
*            mail      = 'X'.
    IF ls_stokupd-mail = 'X'.
      gt_data-light = gc_green.
    ELSE.
      gt_data-light = gc_yellow.
    ENDIF.

    gt_data-clabs2 = ls_stokupd-clabs.

    IF gt_data-clabs2 = gt_data-clabs.
      gt_data-line_color = 'C510'.
    ELSE.
      gt_data-line_color = 'C610'.
    ENDIF.


    MODIFY gt_data TRANSPORTING light clabs2 line_color.
  ENDLOOP.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form LIST_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM list_data .
  gs_layout-box_fieldname = 'BOX'.
  gs_layout-info_fieldname = 'LINE_COLOR'.
  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.


  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = sy-repid
      i_internal_tabname = 'GS_DATA'
      i_inclname         = 'ZEGT00_OE_SENARYO1_TOP'
    CHANGING
      ct_fieldcat        = gt_fieldcat[].



  LOOP AT gt_fieldcat.
    CASE gt_fieldcat-fieldname.
      WHEN 'LIGHT'.
        gt_fieldcat-col_pos = 0.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Durum'.
      WHEN 'MATNR'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Malzeme'.
      WHEN 'MAKTX'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Malzeme Tanımı'.
      WHEN 'WERKS'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Üretim Yeri'.
      WHEN 'NAME1'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Üretim Yeri Tanımı'.
      WHEN 'LGORT'.
        IF pa_rb3 = 'X'.
          gt_fieldcat-tech = 'X'.
        ENDIF.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Depo Yeri'.
      WHEN 'CHARG'.
        IF pa_rb2 = 'X' OR pa_rb3 = 'X'.
          gt_fieldcat-tech = 'X'.
        ENDIF.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Parti'.
      WHEN 'CLABS'.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'SAP Stok'.
      WHEN 'CLABS2'.
        IF pa_chk1 = space.
          gt_fieldcat-tech = 'X'.
        ENDIF.
        gt_fieldcat-seltext_s =
        gt_fieldcat-seltext_m =
        gt_fieldcat-seltext_l =
        gt_fieldcat-reptext_ddic = 'Fiziksel Stok'.
        gt_fieldcat-edit = 'X'.
    ENDCASE.
    MODIFY gt_fieldcat.
  ENDLOOP.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_grid_title             = sy-title
      i_callback_program       = sy-repid
      is_layout                = gs_layout
      i_save                   = 'A'
      it_fieldcat              = gt_fieldcat[]
      i_callback_pf_status_set = 'SET_PF_STATUS'
      i_callback_user_command  = 'USER_COMMAND'
    TABLES
      t_outtab                 = gt_data.

ENDFORM.
*&---------------------------------------------------------------------*
FORM user_command USING r_ucomm LIKE sy-ucomm
                   rs_selfield TYPE slis_selfield.


  DATA: gd_repid LIKE sy-repid,
        ref_grid TYPE REF TO cl_gui_alv_grid.
  IF ref_grid IS INITIAL.
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = ref_grid.
  ENDIF.
  IF NOT ref_grid IS INITIAL.
    CALL METHOD ref_grid->check_changed_data .
  ENDIF.

  CASE r_ucomm.
    WHEN 'UCOMM1'. " güncelle
      PERFORM ucomm1.
    WHEN 'UCOMM2'.  " kaydet
      PERFORM ucomm2.
    WHEN 'UCOMM3'.  " gönder
      PERFORM ucomm3.
  ENDCASE.



  rs_selfield-refresh = 'X'.
  rs_selfield-col_stable = 'X'.
  rs_selfield-row_stable = 'X'.
ENDFORM.

*&---------------------------------------------------------------------*
FORM set_pf_status USING rt_exhab TYPE slis_t_extab.

  DATA: lt_ucomm LIKE TABLE OF sy-ucomm.
  DATA: ls_ucomm LIKE LINE OF lt_ucomm.

  " Exclude PF Status

  IF pa_chk1 = 'X'.
    SET PF-STATUS 'STATUS' .
  ELSE.
    ls_ucomm = 'UCOMM1'. APPEND ls_ucomm TO lt_ucomm.
    ls_ucomm = 'UCOMM2'. APPEND ls_ucomm TO lt_ucomm.
    SET PF-STATUS 'STATUS' EXCLUDING lt_ucomm.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
FORM ucomm1.

  DATA: ld_color(4) TYPE c.



  IF pa_chk1 = 'X'.
    LOOP AT gt_data WHERE box = 'X'.
      IF gt_data-clabs NE gt_data-clabs2.
        gt_data-line_color = 'C610'.
      ELSEIF gt_data-clabs EQ gt_data-clabs2.
        gt_data-line_color = 'C510'.
      ENDIF.
      MODIFY gt_data TRANSPORTING line_color.
      CLEAR: gt_data.
    ENDLOOP.
  ENDIF.

  IF sy-subrc <> 0.
    MESSAGE 'Lütfen satır seçiniz.' TYPE 'I'.
  ELSE.
    MESSAGE 'Güncellendi.' TYPE 'S'.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
FORM ucomm2.


  DATA: ls_stokupd LIKE zmb_mm_stokup_oe.

  CASE gv_num.
    WHEN '01'.
      LOOP AT gt_data WHERE box = 'X'.
        ls_stokupd-stok_tipi = gv_num.
        ls_stokupd-matnr = gt_data-matnr.
        ls_stokupd-werks = gt_data-werks.
        ls_stokupd-lgort = gt_data-lgort.
        ls_stokupd-charg = gt_data-charg.
        ls_stokupd-clabs = gt_data-clabs2.
        MODIFY zmb_mm_stokup_oe FROM ls_stokupd.
        COMMIT WORK AND WAIT.
*        MOVE-CORRESPONDING gt_data TO zmb_mm_stokup_oe.
*        zmb_mm_stokup_oe-stok_tipi = gv_num.
*        MODIFY zmb_mm_stokup_oe.
*        COMMIT WORK AND WAIT.
      ENDLOOP.
    WHEN '02'.
      LOOP AT gt_data WHERE box = 'X'.
        ls_stokupd-stok_tipi = gv_num.
        ls_stokupd-matnr = gt_data-matnr.
        ls_stokupd-werks = gt_data-werks.
        ls_stokupd-lgort = gt_data-lgort.
        ls_stokupd-clabs = gt_data-clabs2.
        MODIFY zmb_mm_stokup_oe FROM ls_stokupd.
        COMMIT WORK AND WAIT.
      ENDLOOP.
    WHEN '03'.
      LOOP AT gt_data WHERE box = 'X'.
        ls_stokupd-stok_tipi = gv_num.
        ls_stokupd-matnr = gt_data-matnr.
        ls_stokupd-werks = gt_data-werks.
        ls_stokupd-clabs = gt_data-clabs2.
        MODIFY zmb_mm_stokup_oe FROM ls_stokupd.
        COMMIT WORK AND WAIT.
      ENDLOOP.
  ENDCASE.

  IF sy-subrc <> 0.
    MESSAGE 'Lütfen satır seçiniz.' TYPE 'E' DISPLAY LIKE 'I'.
  ELSE.
    MESSAGE 'Kaydedildi.' TYPE 'S'.
  ENDIF.
ENDFORM.


FORM ucomm3.

  DATA: ls_stokupd LIKE zmb_mm_stokup_oe.

  "seçili satırları collect tablosuna attık.
  LOOP AT gt_data WHERE box = 'X'.
    gt_werks-werks = gt_data-werks.
    COLLECT gt_werks.
  ENDLOOP.

  "collect edilen üy'lerde dönülür.
  "her biri için bir mail atılır.
  LOOP AT gt_werks.

    CLEAR gt_mailtxt[].
    gt_mailtxt-line = 'Sayın ilgili,'.
    APPEND gt_mailtxt.


    CLEAR gt_mailsub.
    gt_mailsub-obj_name = 'Test'.
    gt_mailsub-obj_langu = sy-langu.
    gt_mailsub-obj_descr = 'Stok Test'.

    "gt_werks'deki üy için mail hazırlanır.
    LOOP AT gt_data WHERE box = 'X'
                      AND werks = gt_werks-werks.

      SELECT SINGLE * FROM zmb_mm_stokup_oe INTO ls_stokupd
        WHERE stok_tipi = gv_num          AND
              matnr     = gt_data-matnr   AND
              werks     = gt_data-werks   AND
              lgort     = gt_data-lgort   AND
              charg     = gt_data-charg.
      IF sy-subrc IS NOT INITIAL.
        MESSAGE 'Satırın stok güncellemesi yapılmamış' TYPE 'E'.
      ENDIF.



      IF gt_data-light = gc_green.
        DATA: lv_answer.
        CALL FUNCTION 'POPUP_TO_CONFIRM'
          EXPORTING
            titlebar              = 'Gönderilmiş Mail'
*           DIAGNOSE_OBJECT       = ' '
            text_question         = TEXT-b01
            text_button_1         = 'Evet'
            text_button_2         = 'Hayır'
            default_button        = '2'
            display_cancel_button = ''
          IMPORTING
            answer                = lv_answer
          EXCEPTIONS
            text_not_found        = 1
            OTHERS                = 2.

        " Evetse mail gönder
        IF lv_answer = '1'.
          PERFORM send_mail.
        ENDIF.

      ELSE.
        " Mail Gönderimi
        PERFORM send_mail.

        gt_data-light = gc_green.
        MODIFY gt_data TRANSPORTING light.
        ls_stokupd-mail = 'X'.
        MODIFY zmb_mm_stokup_oe FROM ls_stokupd.

      ENDIF.

    ENDLOOP.

    CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
      EXPORTING
        document_data  = gt_mailsub
      TABLES
        object_content = gt_mailtxt
        receivers      = gt_mailrec.

    COMMIT WORK.

  ENDLOOP.

  IF sy-subrc <> 0.
    MESSAGE 'Lütfen satır seçiniz.' TYPE 'E' DISPLAY LIKE 'I'.
  ELSEIF lv_answer = '2'.
    MESSAGE 'İşlem iptal edildi.' TYPE 'S'.
  ELSE.
    MESSAGE 'Mail Gönderildi.' TYPE 'S'.
  ENDIF.


ENDFORM.

FORM send_mail.
  DATA: lv_clabs(20).

  CLEAR lv_clabs.
  CLEAR gt_mailrec.


  SELECT SINGLE
  zwerks
  zemail
  FROM zoe_bt1
  INTO CORRESPONDING FIELDS OF gt_mail
  WHERE zwerks = gt_data-werks.

  WRITE gt_data-clabs2 TO lv_clabs LEFT-JUSTIFIED.

  IF sy-subrc IS INITIAL.
    IF gt_mail-zemail = ''.
      MESSAGE 'İlgili üretim yeri için mail adresi tanımlanmamıştır'
            TYPE 'E'.
    ELSE.
      CLEAR gt_mailrec.
      CLEAR gt_mailrec[].
      gt_mailrec-rec_type = 'U'.
      gt_mailrec-receiver = gt_mail-zemail.
      COLLECT gt_mailrec.
      IF pa_rb1 = 'X'.
        CONCATENATE gt_data-matnr 'Malzemesinin,' gt_data-werks
              'üretim yerinde,' gt_data-lgort 'isimli depo yerinde,'
              gt_data-charg 'nolu partisinde,'
              lv_clabs 'stoğu bulunmaktadır.'
             INTO gt_mailtxt-line SEPARATED BY space.
        APPEND gt_mailtxt.
        CLEAR gt_mailtxt.
        APPEND gt_mailtxt.
      ELSEIF pa_rb2 = 'X'.
        CONCATENATE gt_data-matnr 'Malzemesinin,' gt_data-werks
              'üretim yerinde,' gt_data-lgort 'isimli depo yerinde,'
               lv_clabs 'stoğu bulunmaktadır.'
             INTO gt_mailtxt-line SEPARATED BY space.
        APPEND gt_mailtxt.
        CLEAR gt_mailtxt.
        APPEND gt_mailtxt.
      ELSEIF pa_rb3 = 'X'.
        CONCATENATE gt_data-matnr 'Malzemesinin,' gt_data-werks
             'üretim yerinde' lv_clabs 'stoğu bulunmaktadır.'
             INTO gt_mailtxt-line SEPARATED BY space.
        APPEND gt_mailtxt.
        CLEAR gt_mailtxt.
        APPEND gt_mailtxt.
      ENDIF.
    ENDIF.
  ELSE.
    MESSAGE 'Üretim yeri bakım tablosunda yoktur.' TYPE 'E'.
  ENDIF.



ENDFORM.
