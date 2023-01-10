CLASS zcl_stubdata_disc_master_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
    METHODS: generate_stub_data.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_stubdata_disc_master_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    CALL METHOD generate_stub_data( ).
    out->write(  'Entries created in discrepancy master data tables' ).
  ENDMETHOD.

  METHOD generate_stub_data.
*****************************************************************************
* This method is used for generating master data for DIscrepancy master data entries
*****************************************************************************
    DATA: lt_disc_reasons TYPE STANDARD TABLE OF zdisc_reas_val,
          lt_disc_status  TYPE STANDARD TABLE OF zdisc_stat_val,
          lt_disc_actions TYPE STANDARD TABLE OF zdisc_act_val.

    lt_disc_reasons = VALUE #(  ( discrepancy_reason =  '01' disc_reason_text = 'Capacity optimization' )
                                ( discrepancy_reason =  '02' disc_reason_text = 'Supply delay from 3rd party' )
                                ( discrepancy_reason =  '03' disc_reason_text = 'High priority' )
                                ( discrepancy_reason =  '04' disc_reason_text = 'Low priority' )
                                ( discrepancy_reason =  '05' disc_reason_text = 'Missing information' )
                                ( discrepancy_reason =  '06' disc_reason_text = 'Other' ) ).

    lt_disc_status = VALUE #(  ( discrepancy_status =  1 disc_status_text = 'Open' )
                               ( discrepancy_status =  2 disc_status_text = 'In process' )
                               ( discrepancy_status =  3 disc_status_text = 'Consultation' )
                               ( discrepancy_status =  4 disc_status_text = 'Closed' )  ).

    lt_disc_actions = VALUE #(  ( discrepancy_action =  1 disc_action_text = 'Trigger next process' )
                                ( discrepancy_action =  2 disc_action_text = 'Move qty to another STO' )
                                ( discrepancy_action =  3 disc_action_text = 'Manual action' )   ).

    MODIFY zdisc_reas_val FROM TABLE @lt_disc_reasons.
    MODIFY zdisc_stat_val FROM TABLE @lt_disc_status.
    MODIFY zdisc_act_val  FROM TABLE @lt_disc_actions.


    COMMIT WORK AND WAIT.

  ENDMETHOD.
ENDCLASS.
