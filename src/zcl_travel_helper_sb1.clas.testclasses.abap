CLASS ltc_travel_helper_sb1 DEFINITION FINAL FOR TESTING
  DURATION SHORT RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: cut TYPE REF TO zcl_travel_helper_sb1.

    METHODS:
      setup,

      "! Test valid booking status conversion
      get_status_valid FOR TESTING,

      "! Test invalid booking status conversion
      get_status_invalid FOR TESTING,
      "! Test subtraction with positive integers
      subtract_positive FOR TESTING,

      "! Test subtraction resulting in negative value
      subtract_negative FOR TESTING.

ENDCLASS.

CLASS ltc_travel_helper_sb1 IMPLEMENTATION.

  METHOD setup.
    cut = NEW zcl_travel_helper_sb1( ).
  ENDMETHOD.

  METHOD get_status_valid.
    DATA: lv_status_text TYPE /dmo/booking_status_text,
          lv_status      TYPE /dmo/booking_status.

    lv_status_text = 'Booked'.

    lv_status = cut->get_booking_status( iv_status = lv_status_text ).

    cl_abap_unit_assert=>assert_equals( act = lv_status exp = 'B' ).
  ENDMETHOD.

  METHOD get_status_invalid.
    DATA: lv_status_text TYPE /dmo/booking_status_text,
          lv_status      TYPE /dmo/booking_status.

    lv_status_text = 'Cancelled'.

    lv_status = cut->get_booking_status( iv_status = lv_status_text ).

    cl_abap_unit_assert=>assert_equals( act = lv_status exp = 'X' ).
  ENDMETHOD.

  METHOD subtract_positive.
    DATA: lv_a TYPE int4,
          lv_b TYPE int4,
          lv_c TYPE int4.

    lv_a = 10.
    lv_b = 5.

    lv_c = cut->subtract( iv_a = lv_a iv_b = lv_b ).

    cl_abap_unit_assert=>assert_equals( act = lv_c exp = 5 ).
  ENDMETHOD.

  METHOD subtract_negative.
    DATA: lv_a TYPE int4,
          lv_b TYPE int4,
          lv_c TYPE int4.

    lv_a = 5.
    lv_b = 10.

    lv_c = cut->subtract( iv_a = lv_a iv_b = lv_b ).

    cl_abap_unit_assert=>assert_equals( act = lv_c exp = -5 ).
  ENDMETHOD.

ENDCLASS.
