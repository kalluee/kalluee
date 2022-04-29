pageextension 50104 "TK Sales Invoice Subform" extends "Sales Invoice Subform"
{
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin

        rec."Line Discount %" := SalesHeader."TK Discount %";

    end;


}