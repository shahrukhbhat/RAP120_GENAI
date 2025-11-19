CLASS zcl_travel_gen_data_SB1 DEFINITION
PUBLIC
FINAL
CREATE PUBLIC .

PUBLIC SECTION.
   INTERFACES if_oo_adt_classrun.

PROTECTED SECTION.
PRIVATE SECTION.
   METHODS: delete_demo_data.
   METHODS: generate_demo_data.

ENDCLASS.



CLASS ZCL_TRAVEL_GEN_DATA_SB1 IMPLEMENTATION.


   METHOD delete_demo_data.
      DELETE FROM ztravel_SB1.
      COMMIT WORK.
   ENDMETHOD.


   METHOD generate_demo_data.
      DATA: ls_travel TYPE ztravel_SB1,
            lt_travel TYPE STANDARD TABLE OF ztravel_SB1.

      ls_travel-client = '100'.
      ls_travel-travel_id = '00000001'.
      ls_travel-agency_id = '070001'.
      ls_travel-customer_id = '000001'.
      ls_travel-begin_date = '20231101'.
      ls_travel-end_date = '20231110'.
      ls_travel-destination = 'Berlin'.
      ls_travel-booking_fee = '150.00'.
      ls_travel-total_price = '1200.00'.
      ls_travel-currency_code = 'EUR'.
      ls_travel-description = 'Business Trip to Berlin'.

      APPEND ls_travel TO lt_travel.
      CLEAR ls_travel.

      "Add more entries
       ls_travel-client = '100'.
      ls_travel-travel_id = '00000002'.
      ls_travel-agency_id = '070002'.
      ls_travel-customer_id = '000002'.
      ls_travel-begin_date = '20231111'.
      ls_travel-end_date = '2023112'.
      ls_travel-destination = 'Paris'.
      ls_travel-booking_fee = '180.00'.
      ls_travel-total_price = '1400.00'.
      ls_travel-currency_code = 'EUR'.
      ls_travel-description = 'BusinessTrip to Paris'.

      APPEND ls_travel TO lt_travel.
      CLEAR ls_travel.

      ls_travel-client = '100'.
      ls_travel-travel_id = '00000003'.
      ls_travel-agency_id = '070003'.
      ls_travel-customer_id = '000003'.
      ls_travel-begin_date = '20231111'.
      ls_travel-end_date = '2023112'.
      ls_travel-destination = 'Tokyo'.
      ls_travel-booking_fee = '200.00'.
      ls_travel-total_price = '1600.00'.
      ls_travel-currency_code = 'JPY'.
      ls_travel-description = 'BusinessTrip to Tokyo'.

      APPEND ls_travel TO lt_travel.
      CLEAR ls_travel.



      INSERT ztravel_SB1 FROM TABLE @lt_travel.
      COMMIT WORK.

      CLEAR lt_travel.
   ENDMETHOD.


   METHOD if_oo_adt_classrun~main.
      me->delete_demo_data(  ).
      out->write( 'Table entries deleted' ).

      me->generate_demo_data(  ).
      out->write( 'Demo data was generated' ).
   ENDMETHOD.
ENDCLASS.
