interface ZIF_ZOE_FIORI_FM_EBEVEYN_CREAT
  public .


  types:
    MANDT type C length 000003 .
  types:
    CHAR40 type C length 000040 .
  types:
    begin of ZOE_FIO_EBEVEYN,
      MANDT type MANDT,
      ID type INT4,
      AD type CHAR40,
      SOYAD type CHAR40,
      D_TARIHI type DATS,
      SEHIR type CHAR40,
      COCUK_SAYISI type INT4,
    end of ZOE_FIO_EBEVEYN .
endinterface.
