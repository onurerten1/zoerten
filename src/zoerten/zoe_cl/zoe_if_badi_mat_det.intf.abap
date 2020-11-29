interface ZOE_IF_BADI_MAT_DET
  public .


  interfaces IF_BADI_INTERFACE .

  methods GET_MATERIALS
    importing
      !MATNR type MATNR
    changing
      !MARA type MARA .
endinterface.
