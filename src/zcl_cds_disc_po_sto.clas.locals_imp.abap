CLASS lhc_ZCDS_DISC_PO_STO DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zcds_disc_po_sto RESULT result.

    METHODS Move FOR MODIFY
      IMPORTING keys FOR ACTION zcds_disc_po_sto~Move RESULT result.

    METHODS Trigger FOR MODIFY
      IMPORTING keys FOR ACTION zcds_disc_po_sto~Trigger RESULT result.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR zcds_disc_po_sto~validateCustomer.

    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR zcds_disc_po_sto~validateDates.

ENDCLASS.

CLASS lhc_ZCDS_DISC_PO_STO IMPLEMENTATION.

  METHOD get_instance_features.
    "%control-<fieldname> specifies which fields are read from the entities
    READ ENTITY IN LOCAL MODE zcds_disc_po_sto FROM VALUE #( FOR <keyval> IN keys
                                                           (  %key                        = <keyval>-%key
                                                              %control-discrepancy_status = if_abap_behv=>mk-on
                                                              %control-discrepancy_days   = if_abap_behv=>mk-on ) )
                                RESULT DATA(lt_disc_result).

    result = VALUE #( FOR <disc> IN lt_disc_result
                      ( %key                      = <disc>-%key
                        %features-%action-Trigger = COND #( WHEN <disc>-discrepancy_status = '4'
                                                            THEN if_abap_behv=>fc-o-disabled
                                                            ELSE if_abap_behv=>fc-o-enabled   )
                        %features-%action-Move    = COND #( WHEN <disc>-discrepancy_status NE '4' AND <disc>-discrepancy_days GE 10
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled   )
                      ) ).
  ENDMETHOD.

  METHOD Trigger.
    " Modify in local mode: BO-related updates that are not relevant for authorization checks
    MODIFY ENTITIES OF zcds_disc_po_sto IN LOCAL MODE
           ENTITY zcds_disc_po_sto
              UPDATE FROM VALUE #( FOR <keyval> IN keys ( %key                        = <keyval>-%key
                                                          discrepancy_action          = '1' " Trigger next process
                                                          %control-discrepancy_action = if_abap_behv=>mk-on
                                                          discrepancy_reason          = '1' " Capacity optimization
                                                          %control-discrepancy_reason = if_abap_behv=>mk-on
                                                          discrepancy_status          = '4' " Closes
                                                          %control-discrepancy_status = if_abap_behv=>mk-on
                                                          resolution_text             = 'Triggered delivery to receiving plant'
                                                          %control-resolution_text    = if_abap_behv=>mk-on ) )
           FAILED   failed
           REPORTED reported.

    " Read changed data for action result
    READ ENTITIES OF zcds_disc_po_sto  IN LOCAL MODE
         ENTITY zcds_disc_po_sto
         FROM VALUE #( FOR <keyval> IN keys (  %key = <keyval>-%key
                                               %control = VALUE #(
                                                           customer_id        = if_abap_behv=>mk-on
                                                           requirement_date   = if_abap_behv=>mk-on
                                                           supp_plant         = if_abap_behv=>mk-on
                                                           receive_plant      = if_abap_behv=>mk-on
                                                           quantity_unit      = if_abap_behv=>mk-on
                                                           po_quantity        = if_abap_behv=>mk-on
                                                           sto_quantity       = if_abap_behv=>mk-on
                                                           po_start_date      = if_abap_behv=>mk-on
                                                           po_end_date        = if_abap_behv=>mk-on
                                                           discrepancy_reason = if_abap_behv=>mk-on
                                                           discrepancy_status = if_abap_behv=>mk-on
                                                           discrepancy_action = if_abap_behv=>mk-on
                                                           resolution_text    = if_abap_behv=>mk-on
                                                           created_by         = if_abap_behv=>mk-on
                                                           created_at         = if_abap_behv=>mk-on
                                                           last_changed_by    = if_abap_behv=>mk-on
                                                           last_changed_at    = if_abap_behv=>mk-on
                                          ) ) )
         RESULT DATA(lt_disc).

    result = VALUE #( FOR <disc> IN lt_disc ( %key   = <disc>-%key
                                              %param = <disc>
                                             ) ).
  ENDMETHOD.

  METHOD Move.
    " Modify in local mode: BO-related updates that are not relevant for authorization checks
    MODIFY ENTITIES OF zcds_disc_po_sto IN LOCAL MODE
           ENTITY zcds_disc_po_sto
              UPDATE FROM VALUE #( FOR key IN keys ( %key                        = key-%key
                                                     discrepancy_action          = '2' " Moved to another STO
                                                     %control-discrepancy_action = if_abap_behv=>mk-on
                                                     discrepancy_reason          = '1' " Capacity optimization
                                                     %control-discrepancy_reason = if_abap_behv=>mk-on
                                                     discrepancy_status          = '4' " Closes
                                                     %control-discrepancy_status = if_abap_behv=>mk-on
                                                     resolution_text             = 'Moved the quanity to another STO'
                                                     %control-resolution_text    = if_abap_behv=>mk-on ) )
           FAILED   failed
           REPORTED reported.

    " Read changed data for action result
    READ ENTITIES OF zcds_disc_po_sto  IN LOCAL MODE
         ENTITY zcds_disc_po_sto
         FROM VALUE #( FOR key IN keys (  %key = key-%key
                                          %control = VALUE #(
                                            customer_id        = if_abap_behv=>mk-on
                                            requirement_date   = if_abap_behv=>mk-on
                                            supp_plant         = if_abap_behv=>mk-on
                                            receive_plant      = if_abap_behv=>mk-on
                                            quantity_unit      = if_abap_behv=>mk-on
                                            po_quantity        = if_abap_behv=>mk-on
                                            sto_quantity       = if_abap_behv=>mk-on
                                            po_start_date      = if_abap_behv=>mk-on
                                             po_end_date       = if_abap_behv=>mk-on
                                            discrepancy_reason = if_abap_behv=>mk-on
                                            discrepancy_status = if_abap_behv=>mk-on
                                            discrepancy_action = if_abap_behv=>mk-on
                                            resolution_text    = if_abap_behv=>mk-on
                                            created_by         = if_abap_behv=>mk-on
                                            created_at         = if_abap_behv=>mk-on
                                            last_changed_by    = if_abap_behv=>mk-on
                                            last_changed_at    = if_abap_behv=>mk-on
                                          ) ) )
         RESULT DATA(lt_disc).

    result = VALUE #( FOR <disc> IN lt_disc ( %key   = <disc>-%key
                                              %param = <disc>
                                              ) ).
  ENDMETHOD.

  METHOD validateCustomer.
    DATA lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.

    READ ENTITY IN LOCAL MODE zcds_disc_po_sto FROM VALUE #(
      FOR <root_key> IN keys ( %key    = <root_key>-%key
                               %control = VALUE #( customer_id = if_abap_behv=>mk-on ) ) )
      RESULT DATA(lt_disc).

    " Optimization of DB select: extract distinct non-initial customer IDs
    lt_cust = CORRESPONDING #( lt_disc DISCARDING DUPLICATES MAPPING customer_id = customer_id EXCEPT * ).
    DELETE lt_cust WHERE customer_id IS INITIAL.
    CHECK lt_cust IS NOT INITIAL.

    " Check if customer ID exist
    SELECT FROM /dmo/customer FIELDS customer_id
      FOR ALL ENTRIES IN @lt_cust
      WHERE customer_id = @lt_cust-customer_id
      INTO TABLE @DATA(lt_cust_db).

    " Raise msg for non existing customer id
    LOOP AT lt_disc ASSIGNING  FIELD-SYMBOL(<disc>).
      IF <disc>-customer_id IS NOT INITIAL AND NOT line_exists( lt_cust_db[ customer_id = <disc>-customer_id ] ).
        APPEND VALUE #(  %key = <disc>-%key ) TO failed-zcds_disc_po_sto.
        APPEND VALUE #(  %key = <disc>-%key
                         %msg      = new_message( id                   = 'ZPLANNING_MSG_CL'
                                                  number               = '001'
                                                  v1                   = <disc>-customer_id
                                                  severity             = if_abap_behv_message=>severity-error )
                                                  %element-customer_id = if_abap_behv=>mk-on ) TO reported-zcds_disc_po_sto.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateDates.
    READ ENTITY IN LOCAL MODE zcds_disc_po_sto FROM VALUE #(
          FOR <root_key> IN keys ( %key     = <root_key>-%key
                                   %control = VALUE #( po_start_date = if_abap_behv=>mk-on
                                                       po_end_date   = if_abap_behv=>mk-on ) ) )
          RESULT DATA(lt_disc).


    " Raise msg if Valid to date is less than valid from date
    LOOP AT lt_disc ASSIGNING  FIELD-SYMBOL(<disc>).
      IF <disc>-po_end_date IS NOT INITIAL AND <disc>-po_end_date LT <disc>-po_start_date.
        APPEND VALUE #(  %key = <disc>-%key ) TO failed-zcds_disc_po_sto.
        APPEND VALUE #(  %key = <disc>-%key
                         %msg = new_message( id                   = 'ZPLANNING_MSG_CL'
                                             number               = '002'
                                             v1                   = <disc>-po_end_date
                                             v2                   = <disc>-po_start_date
                                             severity             = if_abap_behv_message=>severity-error )
                                             %element-po_end_date = if_abap_behv=>mk-on ) TO reported-zcds_disc_po_sto.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
