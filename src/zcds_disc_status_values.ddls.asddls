@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Discrepancy Status view entity'
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
define view entity ZCDS_DISC_STATUS_VALUES
  as select from zdisc_stat_val as Status
{
  @UI.textArrangement: #TEXT_ONLY
  @ObjectModel.text.element: [ 'StatusText' ]
  key Status.discrepancy_status as discrepancy_status,
  @UI.hidden: true
  Status.disc_status_text as StatusText 
}
