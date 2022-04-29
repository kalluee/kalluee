tableextension 50102 "TK Sales Header" extends "Sales Header"
{
    fields
    {
        field(50000; "TK Discount %"; Decimal)
        {
            Caption = 'Discount', comment = 'et-EE=Allahindlus';
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                AddDiscount();
            end;
        }
    }

    procedure AddDiscount()
    var
        CustBonusLevel: Record Customer;
        HelperFuntion: Codeunit "TK Helper Functions";

    begin
        CustBonusLevel.Get(rec."Bill-to Customer No.");

        case CustBonusLevel."TK Bonus Level" of
            CustBonusLevel."TK Bonus Level"::Bronze:
                begin
                    Rec."TK Discount %" := 5;
                end;
            CustBonusLevel."TK Bonus Level"::Silver:
                begin
                    Rec."TK Discount %" := 10;
                end;
            CustBonusLevel."TK Bonus Level"::Gold:
                begin
                    Rec."TK Discount %" := 15;
                end;
        end;

        HelperFuntion.ApplyBonusLevelDimension(CustBonusLevel."TK Bonus Level", Rec);

    end;



}