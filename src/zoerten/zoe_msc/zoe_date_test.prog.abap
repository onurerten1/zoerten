*&---------------------------------------------------------------------*
*& Report ZOE_DATE_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_date_test.

DATA: lv_date LIKE sy-datum.

WRITE: / sy-datum.

CALL METHOD cl_bs_period_toolset_basics=>subtract_days_from_date
  EXPORTING
    iv_date = sy-datum
    iv_days = 1
  RECEIVING
    rv_date = lv_date.

WRITE: / lv_date.

lv_date = cl_bs_period_toolset_basics=>get_first_day_in_month( EXPORTING iv_date = sy-datum ).

WRITE: / lv_date.

DATA(lv_days) = cl_reca_date=>get_days_between_two_dates( EXPORTING id_datefrom = '20190819'
                                                                    id_dateto = sy-datum ).

WRITE: / lv_days.

DATA(lv_dates) = cl_bs_period_toolset_basics=>get_last_day_prev_month( EXPORTING iv_date = sy-datum ).

WRITE: / lv_dates.

lv_date = cl_bs_period_toolset_basics=>get_last_day_in_month( EXPORTING iv_date = sy-datum ).

WRITE: / lv_date.
