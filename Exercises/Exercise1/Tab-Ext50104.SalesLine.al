tableextension 50104 "TK Sales Line" extends "Sales Line"
{
    fields
    {

        modify(Quantity)
        {
            trigger OnAfterValidate()

            begin
                AddDiscountToSalesLine();
            end;
        }

    }

    procedure AddDiscountToSalesLine()
    var
        SalesHeaderDiscount: Record "Sales Header";

    begin
        SalesHeaderDiscount.Get(rec."Document Type", Rec."Document No.");

        "Line Discount %" := SalesHeaderDiscount."TK Discount %";

        Message('Lisati soodustus ' + Format(SalesHeaderDiscount."TK Discount %") + '%');

    end;
}