CLASS zcl_stubdata_po_sto_disc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
    METHODS: generate_stub_data.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_stubdata_po_sto_disc IMPLEMENTATION.
 METHOD if_oo_adt_classrun~main.
  CALL METHOD generate_stub_data(  ).
  out->write( |{ sy-dbcnt } discrepancy entries inserted successfully!| ).
 ENDMETHOD.

  METHOD generate_stub_data.
*****************************************************************************
* This method is used for generating test data in ZDISC_PO_STO table
* in systems where there is no integartion to 3rd party systems
*****************************************************************************
    DATA: lt_disc_data TYPE STANDARD TABLE OF zdisc_po_sto_pl.
    Check sy-sysid+0(1) NE 'P'. "Will produce test data for non production systems only

*    DELETE from zdisc_po_sto_pl.
    DO 20 TIMES.
**Prepare dummy data
      APPEND INITIAL LINE TO lt_disc_data ASSIGNING FIELD-SYMBOL(<disc_data>).
      DATA(lv_run) = sy-index.
      <disc_data> = VALUE #( po_number          = 'PO300000' &&  lv_run
                             sto_number         = 'STO40000' &&  lv_run
                             mat_number         = 'DESKTOP'
                             customer_id        = '000003'
                             requirement_date   = sy-datum + lv_run * 2
                             supp_plant         = '1005'
                             receive_plant      = '2005'
                             quantity_unit      = 'EA'
                             sto_quantity       = 10 + lv_run
                             po_quantity        = 10 + lv_run * 1 + lv_run
                             po_start_date      = sy-datum - 10
                             po_end_date        = sy-datum + lv_run
                             discrepancy_days   = <disc_data>-requirement_date - <disc_data>-po_end_date
                             discrepancy_crit   = COND #( when <disc_data>-discrepancy_days > 15             then 1
                                                          when <disc_data>-discrepancy_days between 9 and 15 then 2
                                                          else 3 )
                             created_by         = sy-uname
                             created_at         = '20230106133945.5960060'
                             last_changed_by    = sy-uname
                             last_changed_at    = '20230111133945.5960060').
    ENDDO.

    MODIFY zdisc_po_sto_pl FROM TABLE @lt_disc_data.
    IF sy-subrc EQ 0.
      COMMIT WORK AND WAIT.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
