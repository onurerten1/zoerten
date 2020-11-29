@AbapCatalog.sqlViewName: 'ZOEVCHARC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Charachteristic Test'
define view zoe_charac_test
  as select from    I_BatchCrossPlant           as mch1
    left outer join I_ClfnObjectCharcValueBasic as ausp  on mch1.ClfnObjectInternalID = ausp.ClfnObjectID
    left outer join I_CharacteristicText        as cabnt on  ausp.CharcInternalID = cabnt.CharacteristicInternalID
                                                         and cabnt.Language       = 'T'
  //  association [0..*] to I_ClfnObjectCharcValueBasic as _ausp  on mch1.ClfnObjectInternalID = _ausp.ClfnObjectID
  //  association [0..*] to I_CharacteristicText        as _cabnt on _ausp.CharcInternalID = _cabnt.CharacteristicInternalID
{
  key Material,
  key Batch,
  key ausp.CharcInternalID,
  key cabnt.CharacteristicDescription,
      ausp.CharcValue,

      ClfnObjectInternalID

      //      _ausp,
      //      _cabnt
}
