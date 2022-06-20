class ZCX_PROMISE_REJECTED definition
  public
  inheriting from CX_STATIC_CHECK
  create private

  global friends ZCL_ABAP_ASYNC
                 ZCL_ABAP_SYNC .

public section.

  data WITH type ref to DATA read-only .

  methods CONSTRUCTOR
    importing
      !TEXTID like TEXTID optional
      !PREVIOUS like PREVIOUS optional
      !WITH type ref to DATA optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_PROMISE_REJECTED IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
TEXTID = TEXTID
PREVIOUS = PREVIOUS
.
me->WITH = WITH .
  endmethod.
ENDCLASS.
