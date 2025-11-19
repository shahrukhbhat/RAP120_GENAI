CLASS lhc_zr_travel_sb1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Travel
        RESULT result,
      validateCustomer FOR VALIDATE ON SAVE
        IMPORTING keys FOR Travel~validateCustomer,
      setInitialTravelStatus FOR DETERMINE ON SAVE
        IMPORTING keys FOR Travel~setInitialTravelStatus,
      setDescription FOR DETERMINE ON MODIFY
        IMPORTING keys FOR Travel~setDescription.
ENDCLASS.

CLASS lhc_zr_travel_sb1 IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD validateCustomer.
*    "ABAP EML to read the field CustomerId from CDS view ZR_TRAVEL_SB1
*    READ ENTITIES OF zr_travel_sb1 IN LOCAL MODE
*      ENTITY travel
*        FIELDS ( customerid ) WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_travel).
*
*    LOOP AT lt_travel INTO DATA(travel).
*      DATA(lo_travel_helper) = NEW zcl_travel_helper_SB1(  ).
*      DATA(customer_id) = travel-CustomerID.
*
*      IF customer_id IS INITIAL.
*        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
*        APPEND VALUE #( %tky                = travel-%tky
*                        %state_area         = 'VALIDATE_CUSTOMER'
*                        %msg                = NEW /dmo/cm_flight_messages(
*                                                                textid   = /dmo/cm_flight_messages=>enter_customer_id
*                                                                severity = if_abap_behv_message=>severity-error )
*                        %element-CustomerID = if_abap_behv=>mk-on
*                      ) TO reported-travel.
*
*      ELSEIF lo_travel_helper->validate_customer( customer_id ) = abap_false.
*
*        APPEND VALUE #( %tky = travel-%tky ) TO failed-travel.
*        APPEND VALUE #( %tky                = travel-%tky
*                        %state_area         = 'VALIDATE_CUSTOMER'
*                        %msg                = NEW /dmo/cm_flight_messages( textid   = /dmo/cm_flight_messages=>customer_unkown
*                                                                            customer_id = travel-CustomerId
*                                                                            severity = if_abap_behv_message=>severity-error )
*                        %element-CustomerID = if_abap_behv=>mk-on
*                        ) TO reported-travel.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD setInitialTravelStatus.

    DATA(lo_travel_helper) = NEW zcl_travel_helper_SB1(  ).

    "1) ABAP EML to read the field Status from CDS view ZR_TRAVEL_SB1
    READ ENTITIES OF zr_travel_sb1 IN LOCAL MODE
      ENTITY travel
        FIELDS ( status ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel).
    "2) If Status is already set, do nothing, i.e. remove such instances
    DELETE lt_travel WHERE Status IS NOT INITIAL.
    "Check for lt_travel intial
    CHECK lt_travel IS NOT INITIAL.
    "3) ABAP EML to update the field Status in CDS view ZR_TRAVEL_SB1. Use variable update_reported
    MODIFY ENTITIES OF zr_travel_sb1 IN LOCAL MODE
      ENTITY travel
        UPDATE
          FIELDS ( status )
          WITH VALUE #( FOR key IN lt_travel ( %tky          = key-%tky
                                               Status        = lo_travel_helper->get_booking_status( 'New' ) ) )
      REPORTED DATA(update_reported).
    "4) Set the changing parameter reported
    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD setDescription.
    DATA(lo_travel_helper) = NEW zcl_travel_helper_SB1(  ).

    READ ENTITIES OF zr_travel_SB1 IN LOCAL MODE
    ENTITY Travel
      FIELDS ( Destination Description ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travel).

    DELETE lt_travel WHERE Description IS NOT INITIAL.
    CHECK lt_travel IS NOT INITIAL.

    MODIFY ENTITIES OF zr_travel_SB1 IN LOCAL MODE
      ENTITY Travel
        UPDATE FIELDS ( Description )
        WITH VALUE #( FOR key IN lt_travel ( %tky   = key-%tky
                                             Description = lo_travel_helper->generate_description( key-Destination )  ) )
      REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

ENDCLASS.
