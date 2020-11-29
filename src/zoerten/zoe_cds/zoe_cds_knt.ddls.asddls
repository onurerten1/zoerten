@AbapCatalog.sqlViewName: 'ZOE_V_KNT_RPR'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Kantar Raporu CDS Deneme'
define view ZOE_CDS_KNT
  as select from    zmbis_knt_t015 as knt
    left outer join kna1           as k  on knt.kunnr = k.kunnr
    left outer join makt           as t  on  knt.matnr = t.matnr
                                         and t.spras   = $session.system_language
    left outer join vbak           as v  on knt.zzsatisno = v.vbeln
    left outer join likp           as lk on knt.zztesno = lk.vbeln
    left outer join lips           as lp on  knt.zztesno  = lp.vbeln
                                         and knt.zztesklm = lp.posnr
    left outer join vbkd           as vd on knt.zzsatisno = vd.vbeln
    left outer join lfa1 as l1 on knt.lifnr = l1.lifnr
    left outer join lfa1 as l2 on knt.zznaklyc = l2.lifnr
{
      //zmbis_knt_t015
  key knt.mandt,
  key knt.zzkntfis,
  key knt.zzkntklm,
  key knt.bukrs,
  key knt.werks,
      knt.zzkntno,
      knt.zzkntno2,
      knt.zzdurum,
      knt.zzsurecno,
      knt.zzislemno,
      knt.zzislemtip,
      knt.zzgyapan,
      knt.zzgtarih,
      knt.zzgsaat,
      knt.zzcyapan,
      knt.zzctarih,
      knt.zzcsaat,
      knt.zzplaka,
      knt.zzsofor,
      knt.zztartim1,
      knt.zztartim2,
      knt.zztartbrm,
      knt.zzdara,
      //      knt.zzdarabrm,
      case knt.zzdarabrm
      when '' then ( case zzdara
                     when 0 then ''
                     else knt.zztartbrm
                     end )
                     else knt.zzdarabrm
                     end                   as zzdarabrm,
      knt.matnr,
      knt.lifnr,
      knt.kunnr,
      knt.zzirsno,
      knt.zzirstar,
      knt.zzirsmik,
      knt.zzirsbrm,
      knt.zztesno,
      //      knt.zztesklm,
      case knt.zztesklm
      when '' then '000010'
      else knt.zztesklm
      end                                  as zztesklm,
      knt.zzsasno,
      knt.zzsasklm,
      knt.zzsatisno,
      knt.zzsatisklm,
      knt.mblnr,
      knt.mjahr,
      knt.zzauy,
      knt.zzadepo,
      knt.zzguy,
      knt.zzgdepo,
      knt.zznot,
      knt.zzmatno,
      knt.zzbantno,
      knt.zzsilono,
      knt.zzmalzeme,
      knt.zzsatici,
      knt.zzmgiris,
      knt.zzmgyapan,
      knt.zzmgtarih,
      knt.zzmgsaat,
      knt.zzmcyapan,
      knt.zzmctarih,
      knt.zzmcsaat,
      knt.netwr,
      knt.waerk,
      knt.zzrefkntfis,
      knt.zzgckfis,
      knt.zznaklyc,
      knt.zzocak,
      knt.belnr,
      knt.gjahr,
      knt.belnr_nak,
      knt.gjahr_nak,
      knt.mblnr_fark,
      knt.mjahr_fark,
      knt.zzirsmikklm,
      knt.zztekklm,
      knt.zzcharg,
      knt.zznmblnr,
      knt.zznmjahr,
      knt.zznzeile,
      knt.zzuecha,
      t.maktx,
      v.auart,
      lk.wadat_ist,
      lp.lfimg,
      lp.vrkme,
      abs( knt.zztartim1 - knt.zztartim2 ) as netagr,
      vd.bzirk,
      case knt.zzdurum
      when 'X' then ( ( abs( knt.zztartim1 - knt.zztartim2 ) - lp.lfimg ) * 1000 )
      else 0
      end                                  as tolerans,
      1                                    as lv_sayi,
      case k.name1
      when '' then ( l1.name1 )
      else k.name1
      end as name1,
      l2.name2 as name2
}
