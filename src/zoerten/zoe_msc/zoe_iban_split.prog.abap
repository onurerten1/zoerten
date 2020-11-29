*&---------------------------------------------------------------------*
*& Report ZOE_IBAN_SPLIT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoe_iban_split.

PARAMETERS: p_iban TYPE iban DEFAULT `TR01 23456 0 123456789123456`.

START-OF-SELECTION.

  CONDENSE p_iban NO-GAPS.

  DATA(lv_country) = p_iban(2).

  DATA(lv_bank_code) = p_iban+4(5).

  DATA(lv_account) = p_iban+10(16).

  BREAK-POINT.
