@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Discrepancy actions view entity'
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
define view entity ZCDS_DISC_ACTION_VALUES
  as select from zdisc_act_val as Status
{
  @UI.textArrangement: #TEXT_ONLY
  @ObjectModel.text.element: [ 'ActionText' ]
  key Status.discrepancy_action as discrepancy_action,
  @UI.hidden: true
  Status.disc_action_text as ActionText 
}

