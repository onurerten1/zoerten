interface ZOE_IF_CUST_NAME
  public .


  interfaces IF_BADI_INTERFACE .

  methods GET_CUST_NAME
    importing
      !I_KUNNR type KUNNR
    changing
      !C_KNA1 type KNA1 .
endinterface.
