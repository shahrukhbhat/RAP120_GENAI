CLASS zcl_function_call_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "define a method that takes a developer name and return their seniority
    METHODS get_developer_seniority
      IMPORTING
        !developer       TYPE string
      RETURNING
        VALUE(seniority) TYPE string .

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FUNCTION_CALL_DEMO IMPLEMENTATION.


  METHOD get_developer_seniority.
    CASE developer.
      WHEN 'Malik'.
        seniority = 'Senior Consultant'.
      WHEN 'Johnny'.
        seniority = 'Junior Consultant'.
      WHEN 'Rajiv'.
        seniority = 'Senior Consultant'.
      WHEN 'Amit'.
        seniority = 'Senior Consultant'.
      WHEN 'Karthik'.
        seniority = 'Senior Consultant'.
    ENDCASE.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    DATA tool_result TYPE string.
    DATA tool_calls TYPE if_aic_tool_call=>tool_calls.
    FIELD-SYMBOLS: <data> TYPE any.

    TRY.
        FINAL(api) = cl_aic_islm_compl_api_factory=>get( )->create_instance( islm_scenario = 'Z_ISLM_SCEN_SB1' ).
      CATCH cx_aic_api_factory.
        "handle exception
    ENDTRY.

    " provide function definitions
    api->register_function( 'Z_FM_GET_DEVELOPER_SKILLS' )->add_parameter(
                          name = 'developer'
                          description = 'Name of the developer'
                          " use specific type here
                          type        = cl_abap_typedescr=>describe_by_name( 'STRING' )
                          required    = abap_true )->set_description( 'Get the developer skills for a given developer' ).

    FINAL(messages) = api->create_message_container( ).
    messages->add_user_message( 'What are the developer skills for Malik?' ).

    " Repeat as long as the LLM wants to perform function calls
    DO.
      " ask LLM
      TRY.
          FINAL(result) = api->execute_for_messages( messages ).
        CATCH cx_aic_completion_api.
          "handle exception
      ENDTRY.

      " Process the calls
      LOOP AT result->get_tool_calls( ) INTO FINAL(tool_call).
        " check the call
        tool_call->get_tool_type( ). "is currently always 'function'

        DATA(function_name) = tool_call->get_function_call( )-function_name.

        DATA(param) = tool_call->get_function_call( )-parameters.  "-> a table with name/value pair;
        "                                                   the values have the type specified at the function registration

        " depending on the above, you call a corresponding function, method or whatever you like
        ASSIGN param[ 1 ]-value->* TO <data>.

        CALL FUNCTION function_name
          EXPORTING
            developer = <data>
          IMPORTING
            skills    = tool_result.
        " add the result as a string value
        tool_call->set_call_result( tool_result ).

        "call the method to fetch the seniority of the passed developer
*        DATA(seniority) = me->get_developer_seniority( CONV #( <data> ) ).
*
*        tool_call->set_call_result( seniority ).

        " pass the results to the message container
        APPEND tool_call TO tool_calls.
      ENDLOOP.
      IF sy-subrc <> 0.
        " there was no call request, i.e. we are finished
        EXIT.
      ENDIF.

      " pass the results to the message container
      messages->add_tool_results( tool_calls ).
    ENDDO.

    " get the final result
    TRY.
        FINAL(completion) = api->execute_for_messages( messages )->get_completion(  ).

        "write the completion to the console
        out->write( completion ).
      CATCH cx_aic_completion_api.
        "handle exception
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
