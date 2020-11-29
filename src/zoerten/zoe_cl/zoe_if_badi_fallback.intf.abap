interface ZOE_IF_BADI_FALLBACK
  public .


  interfaces IF_BADI_INTERFACE .

  methods ADD
    importing
      !VALUE1 type I
      !VALUE2 type I
    changing
      !RESULT type I .
endinterface.
