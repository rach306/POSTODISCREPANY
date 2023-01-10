@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for discrepancies in PO and STO'
define root view entity ZCDS_DISC_PO_STO

  as select from zdisc_po_sto_pl as Disc

/* Associations */
  association [0..1] to /DMO/I_Customer as _Customer on $projection.customer_id = _Customer.CustomerID
  association [0..1] to ZCDS_DISC_REASON_VALUES as _Reason on $projection.discrepancy_reason = _Reason.discrepancy_reason
  association [0..1] to ZCDS_DISC_STATUS_VALUES as _Status on $projection.discrepancy_status = _Status.discrepancy_status 
    
{

  key po_number,
  key sto_number,
  key mat_number,
      @ObjectModel.text.element: ['CustomerName']
      @Consumption.valueHelpDefinition: [{ entity : {name: '/DMO/I_Customer', element: 'CustomerID'  } }]
      customer_id,      
      _Customer.LastName as CustomerName,
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
      @ObjectModel.text.element: ['ReasonText']
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZCDS_DISC_REASON_VALUES', element: 'discrepancy_reason'  } }]
      discrepancy_reason,
      _Reason.ReasonText as ReasonText,
      @ObjectModel.text.element: ['StatusText']
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZCDS_DISC_STATUS_VALUES', element: 'discrepancy_status'  } }]
      discrepancy_status,
      _Status.StatusText as StatusText,
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
      _Customer,
      _Reason,
      _Status
}
