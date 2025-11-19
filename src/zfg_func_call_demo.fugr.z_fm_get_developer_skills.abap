FUNCTION z_fm_get_developer_skills.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(DEVELOPER) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     REFERENCE(SKILLS) TYPE  STRING
*"  RAISING
*"      CX_SY_ZERODIVIDE
*"     RESUMABLE(CX_SY_ASSIGN_CAST_ERROR)
*"----------------------------------------------------------------------
skills = |ABAP, UI5, CDS|.



ENDFUNCTION.
