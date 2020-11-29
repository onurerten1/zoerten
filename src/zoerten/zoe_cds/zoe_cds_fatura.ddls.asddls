@AbapCatalog.sqlViewName: 'ZOE_CDS_FAT_RAP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'fatura raporu cds'
define view zoe_cds_fatura
  as select from    vbrk  as k
    left outer join tvfkt as tv on  k.fkart  = tv.fkart
                                and tv.spras = $session.system_language
    inner join      kna1  as k1 on k.kunrg = k1.kunnr
    inner join      kna1  as k2 on k.kunag = k2.kunnr
    left outer join t052u as t  on  k.zterm = t.zterm
                                and t.spras = $session.system_language
    inner join      vbrp  as p  on k.vbeln = p.vbeln
    inner join      mara  as mr on p.matnr = mr.matnr
    inner join      marc  as mc on  p.matnr = mc.matnr
                                and p.werks = mc.werks
    left outer join likp  as l  on p.vgbel = l.vbeln
    left outer join vbap  as vp on  p.aubel = vp.vbeln
                                and p.aupos = vp.posnr
{
  k.vtweg,
  p.vstel,
  k.fkart,
  tv.vtext,
  k.xblnr,
  p.vbeln,
  k.kunrg,
  @EndUserText.label: 'Description'
  @EndUserText.quickInfo: 'Description'
  k1.name1,
  k.kunag,
  @EndUserText.label: 'Description'
  @EndUserText.quickInfo: 'Description'
  k2.name1                    as name11,
  k.fkdat,
  k.zterm,
  @EndUserText.label: 'Pay.Term.Desc.'
  @EndUserText.quickInfo: 'Payment Term Description'
  t.text1,
  p.posnr,
  p.matnr,
  p.arktx,
  p.fkimg,
  p.netwr,
  @EndUserText.label: 'Unit Price'
  @EndUserText.quickInfo: 'Unit Price'
  case p.fkimg
  when 0 then cast( 0 as abap.curr( 15, 2 ))
  else division( p.netwr, p.fkimg, 2 )
  end                         as brmfy,
  p.mwsbp,
  @EndUserText.label: 'TRY Total Price'
  @EndUserText.quickInfo: 'Total'
  ( p.netwr + p.mwsbp )       as toptt,
  k.waerk,
  @EndUserText.label: 'TRY Net Price'
  @EndUserText.quickInfo: 'TRY Net Price'
  case k.waerk
  when 'TRY' then p.netwr
  else ( cast( p.netwr *  k.kurrf as abap.curr( 15, 2 )))
  end                         as trynf,
  @EndUserText.label: 'TRY Unit Price'
  @EndUserText.quickInfo: 'TRY Unit Price'
  case k.waerk
  when 'TRY' then ( case p.fkimg
                    when 0 then cast( 0 as abap.curr(15,2))
                    else division(p.netwr,p.fkimg,2)
                    end )
  else ( case p.fkimg
          when 0 then cast( 0 as abap.curr(15,2) )
          else division( ( p.netwr * k.kurrf ), p.fkimg, 2 )
          end )
  end                         as trybf,
  @EndUserText.label: 'TRY Tax'
  @EndUserText.quickInfo: 'TRY Tax'
  case k.waerk
  when 'TRY' then p.mwsbp
  else ( cast( p.mwsbp *  k.kurrf as abap.curr( 15, 2 )))
  end                         as tryvr,
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
  mc.stawn
}

