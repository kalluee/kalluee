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
        // See ei tööta
        // modify("No.")
        // {
        //     TableRelation = if (Type = const(Job)) Job."No.";
        //     trigger OnAfterValidate()
        //     var
        //         Job: Record Job;
        //     begin
        //         if Type = Type::Job then begin
        //             Job.get("No.");
        //             Rec.Validate(Description, Job.Description);
        //         end;
        //     end;
        // }
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