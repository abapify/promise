class ZCX_PROMISE_NOT_RESOLVED definition
  public
  inheriting from CX_NO_CHECK
  final
  create private

  global friends ZCL_ABAP_ASYNC
                 ZCL_ABAP_SYNC
                 ZCL_PROMISE .

public section.

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_PROMISE_NOT_RESOLVED IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
  endmethod.
ENDCLASS.
