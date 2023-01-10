@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Discrepancy Reasons view entity'
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
define view entity ZCDS_DISC_REASON_VALUES
  as select from zdisc_reas_val as Status
{
  @UI.textArrangement: #TEXT_ONLY
  @ObjectModel.text.element: [ 'ReasonText' ]
  key Status.discrepancy_reason as discrepancy_reason,
  @UI.hidden: true
  Status.disc_reason_text as ReasonText 
}

