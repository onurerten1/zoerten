@AbapCatalog.sqlViewName: 'ZOE_SD_V_FAT_RAP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fatura Raporu CDS'
define view ZOE_SD_CDS_FAT_RAP
  as select from    vbrk  as k
    left outer join tvfkt as tv on  k.fkart  = tv.fkart
                                and tv.spras = $session.system_language
  //    inner join      kna1  as k1 on k.kunrg = k1.kunnr
  //    inner join      kna1  as k2 on k.kunag = k2.kunnr
    left outer join t052u as t  on  k.zterm = t.zterm
                                and t.spras = $session.system_language
    inner join      vbrp  as p  on k.vbeln = p.vbeln
    inner join      mara  as mr on p.matnr = mr.matnr
    inner join      marc  as mc on  p.matnr = mc.matnr
                                and p.werks = mc.werks
    left outer join likp  as l  on p.vgbel = l.vbeln
    left outer join vbap  as vp on  p.aubel = vp.vbeln
                                and p.aupos = vp.posnr
  association [1..1] to kna1 as _kna1 on(
    _kna1.kunnr    = k.kunrg
    or _kna1.kunnr = k.kunag
  )
{
  k.vkorg,
  k.vtweg,
  p.vstel,
  k.fkart,
  tv.vtext,
  k.xblnr,
  p.vbeln,
  k.kunrg,
  //  k1.name1,
  _kna1[ kunnr = $projection.kunrg ].name1      as name1,
  k.kunag,
  //  k2.name1                                      as name1a,
  _kna1[ kunnr = $projection.kunag ].name1      as name1a,
  k.fkdat,
  k.zterm,
  t.text1,
  p.posnr,
  p.matnr,
  p.arktx,
  p.fkimg,
  p.netwr,
  case p.fkimg
  when 0 then cast( 0 as zoe_sd_e_brmfy)
  else division( p.netwr, p.fkimg, 2 )
  end                                           as brmfy,
  p.mwsbp,
  cast(( p.netwr + p.mwsbp ) as zoe_sd_e_toptt) as toptt,
  k.waerk,
  case k.waerk
  when 'TRY' then p.netwr
  else ( cast( p.netwr *  k.kurrf as zoe_sd_e_trynf))
  end                                           as trynf,
  case k.waerk
  when 'TRY' then ( case p.fkimg
                    when 0 then cast( 0 as zoe_sd_e_trybf)
                    else division(p.netwr,p.fkimg,2)
                    end )
  else ( case p.fkimg
          when 0 then cast( 0 as zoe_sd_e_trybf)
          else division( ( p.netwr * k.kurrf ), p.fkimg, 2 )
          end )
  end                                           as trybf,
  case k.waerk
  when 'TRY' then p.mwsbp
  else ( cast( p.mwsbp *  k.kurrf as zoe_sd_e_tryvr))
  end                                           as tryvr,
  case k.waerk
  when 'TRY' then ( p.netwr + p.mwsbp )
  else ( cast( ( p.netwr + p.mwsbp ) * k.kurrf as zoe_sd_e_trytt ))
  end                                           as trytt,
  p.vgbel,
  l.lifex,
  l.wadat_ist,
  p.aubel,
  p.brgew,
  p.ntgew,
  p.matkl,
  k.inco1,
  k.inco2,
  k.rfbsk,
  k.ernam,
  k.erdat,
  mc.stawn,
  k.fksto,
  k.sfakn
}
