function ZOE_WF_FM_DISP_LOGO.
*"--------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_INFO) TYPE  SWR_WIPR_I
*"  EXPORTING
*"     REFERENCE(E_INFO) TYPE  SWR_WIPR_E
*"--------------------------------------------------------------------

  e_info-gif-id      = 'ZOE_LOGO'.
  e_info-gif-align   = 'L'.
  e_info-dialogtext = 'Logo'.



endfunction.
