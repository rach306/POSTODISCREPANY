@EndUserText.label: 'Discrepancy projection view - Processor'
@AccessControl.authorizationCheck: #NOT_REQUIRED

// Header information and default sorting order
@UI: {
      headerInfo: { typeName: 'Discrepancy', typeNamePlural: 'Discrepancies' },
      presentationVariant: [{
                             sortOrder: [{
                             by: 'discrepancy_days',
                             direction: #DESC
                           }],
                             visualizations: [{
                             type: #AS_LINEITEM
                           }] 
                           }] 
        }

@Search.searchable: true

define root view entity ZP_DISC_PO_STO
provider contract transactional_query
as projection on ZCDS_DISC_PO_STO
association [0..1] to /DMO/I_Customer as _Customer on $projection.customer_id = _Customer.CustomerID 
association [0..1] to ZCDS_DISC_REASON_VALUES as _Reason on $projection.discrepancy_reason = _Reason.discrepancy_reason
association [0..1] to ZCDS_DISC_STATUS_VALUES as _Status on $projection.discrepancy_status = _Status.discrepancy_status   
{
  
@UI.facet: [

  // Body Facets (Object Page)

       // Facet 1 - Parent (collection) for Fieldgroup 1, Fieldgroup 2 and Fieldgroup 3
       
             { id:              'Facet1-ID',
               type:            #COLLECTION,
               label:           'Disrepancy b/w PO and STO',
               position:        10 },
               
          // Facet for Fieldgroup 1 - nested inside Facet 1
             { id:              'Fieldgroup1-ID',
               type:            #FIELDGROUP_REFERENCE, 
               label:           'Production order data',
               parentId:        'Facet1-ID',   // Places this facet into 'Facet 1'
               targetQualifier: 'Fieldgroup1',
               position:         10 },

       // Facet for Fieldgroup 2 - nested inside Facet 1

             { id:              'Fieldgroup2-ID',
               type:            #FIELDGROUP_REFERENCE,
               label:           'Stock transport order data',
               parentId:        'Facet1-ID',   // Places this facet into 'Facet 1'
               targetQualifier: 'Fieldgroup2', // No targetElement defined. Default target is the entity in which the facet is defined.
               position:         20 },
        
          // Facet for Fieldgroup 3 - nested inside Facet 1       
             { id:              'Fieldgroup3-ID',
               type:            #FIELDGROUP_REFERENCE,
               label:           'General data',
               parentId:        'Facet1-ID',   // Places this facet into 'Facet 1'
               targetQualifier: 'Fieldgroup3', // No targetElement defined. Default target is the entity in which the facet is defined.
               position:         30 }
            
             ]

      @UI: {
             lineItem: [ { position: 10, label: 'PO Number', importance: #HIGH } ],
             selectionField: [ { position: 10 } ], 
             fieldGroup: [ { qualifier: 'Fieldgroup1', label: 'PO Number', position: 10 } ] }
      @Search.defaultSearchElement: true
      
      key po_number          as Po_number,

      @UI: {
             lineItem: [ { position: 20, label: 'STO Number', importance: #HIGH } ],
//                identification: [ { position: 20, label: 'STO Number', importance: #HIGH } ],
             selectionField: [ { position: 20 } ],
             fieldGroup: [ { qualifier: 'Fieldgroup2', label: 'STO Number', position: 10 } ] }
      @Search.defaultSearchElement: true
  
      key sto_number         as sto_number,

      @UI: {
             lineItem: [ { position: 30, label: 'Mat. Number', importance: #HIGH  } ],
             fieldGroup: [ { qualifier: 'Fieldgroup3', label: 'Mat. Number', position: 10 } ] } 
      @Search.defaultSearchElement: true
     
      key mat_number         as mat_number,

      @UI: {
             lineItem:       [ { position: 40, importance: #HIGH, type: #WITH_NAVIGATION_PATH, targetElement: '_Customer'  } ],
             fieldGroup:     [ { qualifier: 'Fieldgroup3', position: 20 } ] }
      @Search.defaultSearchElement: true
      @UI.textArrangement: #TEXT_ONLY
      
      customer_id        as customer_id,
      CustomerName,

      @UI: {
             lineItem: [ { position: 50, label: 'Required date', importance: #MEDIUM } ],
             fieldGroup: [ { qualifier: 'Fieldgroup2', label: 'Required date', position: 20 } ]  }
      
      requirement_date   as requirement_date,

      @UI: {
             lineItem: [ { position: 60, label: 'Supplying plant', importance: #HIGH } ],
             selectionField: [ { position: 40 } ],
             fieldGroup: [ { qualifier: 'Fieldgroup2', label: 'Supplying plant', position: 30 } ] }
      
      supp_plant         as supp_plant,

      @UI: {
             lineItem: [ { position: 65, label: 'Receiving plant', importance: #HIGH } ],
             fieldGroup: [ { qualifier: 'Fieldgroup2', label: 'Receiving plant', position: 40 } ] }
      
      receive_plant      as receive_plant,

      @UI: {
             lineItem: [ { position: 70, label: 'PO Quantity', importance: #MEDIUM } ],
             fieldGroup: [ { qualifier: 'Fieldgroup1',label: 'PO Quantity', position: 20 } ] }
      @Semantics.quantity.unitOfMeasure : 'quantity_unit'
      
      po_quantity        as po_quantity,

      @UI: {
             lineItem: [ { position: 80, label: 'STO Quantity',importance: #MEDIUM } ],
             fieldGroup: [ { qualifier: 'Fieldgroup2', label: 'STO Quantity', position: 50 } ] }
      @Semantics.quantity.unitOfMeasure : 'quantity_unit'
      
      sto_quantity       as sto_quantity,
      
      quantity_unit      as quantity_unit,

    @UI: {
             lineItem:       [ { position: 90, label: 'PO start date', importance: #MEDIUM } ],
             fieldGroup:     [ { qualifier: 'Fieldgroup1', label: 'PO start date', position: 30 } ]  }
        
      po_start_date      as po_start_date,

      @UI: {
             lineItem:       [ { position: 100, label: 'PO end date', importance: #MEDIUM } ],
             fieldGroup:     [ { qualifier: 'Fieldgroup1', label: 'PO end date', position: 40 } ] }
        
      po_end_date        as po_end_date,
      
      @UI: {
             lineItem: [{ position: 110,  label: 'Disc days',importance: #MEDIUM, criticality: 'discrepancy_crit' } ],
             fieldGroup: [ { qualifier: 'Fieldgroup3', label: 'Discrepancy days', position: 30 } ] }
                                                                              
      discrepancy_days as discrepancy_days,
      
                   
      @UI: { 
             lineItem: [ { position: 115, label: 'Disc reason',importance: #MEDIUM },
                          { type: #FOR_ACTION, dataAction: 'Move', label: 'Move stock to another STO' } ],
             fieldGroup: [ { qualifier: 'Fieldgroup3', label: 'Discrepancy reason', position: 40 } ] }
//      @Consumption.derivation: { lookupEntity: 'ZCDS_DISC_REASON_VALUES', resultElement: 'discrepancy_reason' , binding: [{targetParameter: 'ZDISC_REASON', type: #PARAMETER , value: 'p_domian_name' }]  }                        
      @UI.textArrangement: #TEXT_ONLY                                
      discrepancy_reason as discrepancy_reason,
      ReasonText,

      @UI: {
             lineItem: [{ position: 120,  label: 'Disc status',importance: #MEDIUM  },
                        { type: #FOR_ACTION, dataAction: 'Trigger', label: 'Trigger next process' } ],
             fieldGroup: [ { qualifier: 'Fieldgroup3', label: 'Discrepancy Status', position: 50 } ] }
             
      @UI.textArrangement: #TEXT_ONLY
                                                                              
      discrepancy_status as discrepancy_status,
      StatusText,

      @UI: {
             lineItem:       [ { position: 130, label: 'Resolution text', importance: #LOW } ],
             fieldGroup:     [ { qualifier: 'Fieldgroup3',label: 'Resolution text', position: 60 } ],
             multiLineText: true  }
        
      resolution_text    as resolution_text,

//   Hidden fields
      @UI.hidden: true
      discrepancy_crit,
      
      @UI.hidden: true
      discrepancy_action as discrepancy_action,                          
     
      @UI.hidden: true
      created_by         as created_by,

      @UI.hidden: true
      created_at         as created_At,

      @UI.hidden: true
      last_changed_by    as Last_Changed_by,

      @UI.hidden: true
      last_changed_at    as Last_Changed_At,
      
      _Customer,
      _Reason,
      _Status
}
