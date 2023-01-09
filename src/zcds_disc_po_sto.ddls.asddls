@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for discrepancies in PO and STO'
define root view entity ZCDS_DISC_PO_STO

  as select from zdisc_po_sto_pl as Disc

/* Associations */
  association [0..1] to /DMO/I_Customer as _Customer on $projection.customer_id = _Customer.CustomerID  
{

  key po_number,
  key sto_number,
  key mat_number,
      customer_id,
      requirement_date,
      supp_plant,
      receive_plant,
      quantity_unit,
      @Semantics.quantity.unitOfMeasure : 'quantity_unit'
      po_quantity,
      @Semantics.quantity.unitOfMeasure : 'quantity_unit'
      sto_quantity,
      po_start_date,
      po_end_date,
      discrepancy_days,
      discrepancy_crit,
      discrepancy_reason,
      discrepancy_status,
      discrepancy_action,      
      resolution_text,      
  
      /*-- Admin data --*/
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,
      @Semantics.user.lastChangedBy: true
      last_changed_by,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at,

      /* Public associations */
      _Customer
}
