@AbapCatalog.sqlViewName: 'ZOE_MM_V_MGB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Malzeme Görünüm Bakımı CDS'
define view ZOE_MM_CDS_MALZ_GRN_BKM
  as select from    marc as c
    inner join      mara as m on c.matnr = m.matnr
    left outer join mvke as v on c.matnr = v.matnr
    left outer join makt as t on  c.matnr = t.matnr
                              and t.spras = $session.system_language
{
  key c.matnr,
  key c.werks,
      v.vkorg,
      v.vtweg,
      t.maktx,
      m.matkl,
      m.mtart,
      case instr (m.vpsta, 'K')
      when 0 then ' '
      else 'X'
      end as grnm1,
      case instr (c.pstat, 'V')
      when 0 then ' '
      else 'X'
      end as grnm2,
      case instr (c.pstat, 'E')
      when 0 then ' '
      else 'X'
      end as grnm3,
      case instr (c.pstat, 'D')
      when 0 then ' '
      else 'X'
      end as grnm4,
      case instr (c.pstat, 'L')
      when 0 then ' '
      else 'X'
      end as grnm5,
      case instr (c.pstat, 'B')
      when 0 then ' '
      else 'X'
      end as grnm6,
      case instr (c.pstat, 'G')
      when 0 then ' '
      else 'X'
      end as grnm7,
      case instr (c.pstat, 'A')
      when 0 then ' '
      else 'X'
      end as grnm8,
      case instr (m.vpsta, 'C')
      when 0 then ' '
      else 'X'
      end as grnm9,
      case instr (c.pstat, 'F')
      when 0 then ' '
      else 'X'
      end as grnm10,
      case instr (c.pstat, 'P')
      when 0 then ' '
      else 'X'
      end as grnm11,
      case instr (c.pstat, 'Q')
      when 0 then ' '
      else 'X'
      end as grnm12,
      case instr (c.pstat, 'S')
      when 0 then ' '
      else 'X'
      end as grnm13,
      case instr (m.vpsta, 'X')
      when 0 then ' '
      else 'X'
      end as grnm14,
      case instr (m.vpsta, 'Z')
      when 0 then ' '
      else 'X'
      end as grnm15
}
union select from mara as m
  left outer join makt as t on  m.matnr = t.matnr
                            and t.spras = $session.system_language
association [0..1] to marc as _marc on m.matnr = _marc.matnr
{
  key m.matnr,
      '    ' as werks,
      '    ' as vkorg,
      '  '   as vtweg,
      t.maktx,
      m.matkl,
      m.mtart,
      case instr (m.vpsta, 'K')
      when 0 then ' '
      else 'X'
      end    as grnm1,
      ' '    as grnm2,
      ' '    as grnm3,
      ' '    as grnm4,
      ' '    as grnm5,
      ' '    as grnm6,
      ' '    as grnm7,
      ' '    as grnm8,
      case instr (m.vpsta, 'C')
      when 0 then ' '
      else 'X'
      end    as grnm9,
      ' '    as grnm10,
      ' '    as grnm11,
      ' '    as grnm12,
      ' '    as grnm13,
      case instr (m.vpsta, 'X')
      when 0 then ' '
      else 'X'
      end    as grnm14,
      case instr (m.vpsta, 'Z')
      when 0 then ' '
      else 'X'
      end    as grnm15
}
where
  _marc.mandt is null;
