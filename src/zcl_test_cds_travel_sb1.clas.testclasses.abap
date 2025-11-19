"!@testing ZR_TRAVEL_SB1
CLASS ltc_zr_travel_sb1 DEFINITION FINAL
  FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    CLASS-DATA environment TYPE REF TO if_cds_test_environment.

    DATA td_ztravel_sb1 TYPE STANDARD TABLE OF ztravel_sb1 WITH EMPTY KEY.
    DATA act_results TYPE STANDARD TABLE OF zr_travel_sb1 WITH EMPTY KEY.
    DATA exp_results TYPE STANDARD TABLE OF zr_travel_sb1 WITH EMPTY KEY.

    "! In CLASS_SETUP, corresponding doubles and clone(s) for the CDS view under test and its dependencies are created.
    CLASS-METHODS class_setup RAISING cx_static_check.
    "! In CLASS_TEARDOWN, Generated database entities (doubles & clones) should be deleted at the end of test class execution.
    CLASS-METHODS class_teardown.

    "! SETUP method creates a common start state for each test method,
    "! clear_doubles clears the test data for all the doubles used in the test method before each test method execution.
    METHODS setup RAISING cx_static_check.

    "! In this method test data is inserted into the generated double(s) for test case
    "! "Calculate VATTAX field"
    METHODS td_calculate_vattax_field.

    "! <strong>Test Case:</strong> Calculate VATTAX field <br><br>
    "! Test calculation of VATTAX field.
    "! <br><br> The results should be asserted with the actuals.
    METHODS calculate_vattax_field FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_ZR_TRAVEL_SB1 IMPLEMENTATION.

  METHOD class_setup.
    environment = cl_cds_test_environment=>create( i_for_entity = 'ZR_TRAVEL_SB1' ).
  ENDMETHOD.

  METHOD setup.
    environment->clear_doubles( ).
  ENDMETHOD.

  METHOD class_teardown.
    environment->destroy( ).
  ENDMETHOD.

  METHOD calculate_vattax_field.
    td_calculate_vattax_field( ).
    SELECT * FROM zr_travel_sb1 INTO TABLE @act_results.
    cl_abap_unit_assert=>assert_equals( exp = lines( exp_results ) act = lines( act_results ) msg = 'Test Generated using AI: Recheck test data' ).
    LOOP AT exp_results INTO DATA(exp_result).
      cl_abap_unit_assert=>assert_equals( exp = exp_result-vattax act = act_results[ sy-tabix ]-vattax
      msg = 'Test Generated using AI: Expected result for field VATTAX is incorrect. Recheck test data.' ).
    ENDLOOP.
  ENDMETHOD.

  METHOD td_calculate_vattax_field.
    " Prepare test data for 'ztravel_sb1'
    td_ztravel_sb1 = VALUE #(
      (
        client = '100'
        travel_id = '00000001'
        total_price = '2000'
        currency_code = 'USD'
      ) ).
    environment->insert_test_data( i_data = td_ztravel_sb1 ).

    " Prepare test data for 'zr_travel_sb1'
    exp_results = VALUE #(
      (
           travelid = '00000001'
           totalprice = '2000'
           currencycode = 'USD'
           vattax = '100.00'
      ) ).
  ENDMETHOD.

ENDCLASS.
