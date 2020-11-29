interface ZIF_ZOE_FIORI_FM_EBEVEYN_READL
  public .


  types:
    CHAR40 type C length 000040 .
  types:
    MANDT type C length 000003 .
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
  types:
    __ZOE_FIO_EBEVEYN              type standard table of ZOE_FIO_EBEVEYN                with non-unique default key .
endinterface.
