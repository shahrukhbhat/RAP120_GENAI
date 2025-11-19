CLASS zcl_travel_helper_SB1 DEFINITION
 PUBLIC
 FINAL
 CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: validate_customer IMPORTING iv_customer_id TYPE /dmo/customer_id RETURNING VALUE(rv_exists) TYPE abap_bool.
    METHODS: get_booking_status IMPORTING iv_status TYPE /dmo/booking_status_text RETURNING VALUE(rv_status) TYPE /dmo/booking_status.
    METHODS: generate_description IMPORTING iv_city TYPE /dmo/city RETURNING VALUE(rv_description) TYPE /dmo/description.
    "method to add two integers and return the sum
    METHODS: sum IMPORTING iv_a TYPE int4 iv_b TYPE int4 RETURNING VALUE(rv_c) TYPE int4.
    "define a method to reverse a string
    METHODS: reverse_string IMPORTING iv_string TYPE string RETURNING VALUE(rv_reversed_string) TYPE string.

    "Define a subtraction method
    METHODS: subtract IMPORTING iv_a TYPE int4 iv_b TYPE int4 RETURNING VALUE(rv_c) TYPE int4.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TRAVEL_HELPER_SB1 IMPLEMENTATION.


  METHOD generate_description.
    TRY.
        FINAL(api) = cl_aic_islm_compl_api_factory=>get( )->create_instance( islm_scenario = 'Z_ISLM_SCEN_SB1' ).
      CATCH cx_aic_api_factory INTO DATA(lx_api).
        rv_description = ''.
    ENDTRY.

    TRY.
        FINAL(prompt_template_instance) = cl_aic_islm_prompt_tpl_factory=>get( )->create_instance(
                                                                               islm_scenario = 'Z_ISLM_SCEN_SB1'
                                                                               template_id   = 'CITY_DESC' ).
        FINAL(prompt_template_instance2) = cl_aic_islm_prompt_tpl_factory=>get( )->create_instance(
        islm_scenario = 'Z_ISLM_SCEN_SB1'
        template_id   = 'SYS_ROLE' ).

      CATCH cx_aic_api_factory INTO DATA(lx_api1).
        rv_description = ''.
    ENDTRY.

    IF ( prompt_template_instance IS BOUND ).

      TRY.
          FINAL(prompt) = prompt_template_instance->get_prompt( parameters = VALUE #( ( name  = 'ISLM_city'
                                                                                value = iv_city ) ) ).
          FINAL(sys_role_prompt) = prompt_template_instance2->get_prompt( ).
        CATCH cx_aic_prompt_template INTO DATA(lx_prompt_templ).
          "handle exception
      ENDTRY.

    ENDIF.

    IF ( api IS BOUND ).
      TRY.
          DATA(messages) = api->create_message_container( ).
          "messages->set_system_role( 'You are a travel agent expert' ).
          messages->set_system_role( sys_role_prompt ).
          messages->add_user_message( prompt ).
          "messages->add_user_message( |Generate a travel destination description for { iv_city }. It should be less than 100 characters| ).
          rv_description = api->execute_for_messages( messages )->get_completion( ).
        CATCH cx_aic_completion_api INTO DATA(lx_completion).
          rv_description = ''.
      ENDTRY.
    ENDIF.
  ENDMETHOD.


  METHOD get_booking_status.
    CASE iv_status.
      WHEN 'Booked'.
        rv_status = 'B'.
      WHEN 'New'.
        rv_status = 'N'.
      WHEN 'Cancelled'.
        rv_status = 'X'.
    ENDCASE.
  ENDMETHOD.


  METHOD REVERSE_STRING.

  ENDMETHOD.


  METHOD sum.
    rv_c = iv_a + iv_b.
  ENDMETHOD.


  METHOD validate_customer.
    rv_exists = abap_false.
    SELECT FROM /dmo/customer FIELDS customer_id
        WHERE customer_id = @iv_customer_id
    INTO TABLE @DATA(customers).

    IF customers IS NOT INITIAL.
      rv_exists = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD SUBTRACT.
    rv_c = iv_a - iv_b.
  ENDMETHOD.

ENDCLASS.
