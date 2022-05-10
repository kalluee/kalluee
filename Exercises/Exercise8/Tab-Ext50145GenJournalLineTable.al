tableextension 50145 "TK Gen. Journal Line" extends "Gen. Journal Line"
{
    fields
    {
        modify(Description)
        {
            trigger OnAfterValidate()
            begin
                AddClientNameToDescription();
            end;
        }
    }

    procedure AddClientNameToDescription()
    var
        CustomerNameTxt: Text[100];
        DescriptionFieldTxt: Text[100];
        GenJournalLine: Record "Gen. Journal Line";
        Customer: Record Customer;
    begin

        if Customer.get(Rec."Bill-to/Pay-to No.") then begin
            CustomerNameTxt := CopyStr(Customer.Name, 1, MaxStrLen(CustomerNameTxt));
            DescriptionFieldTxt := CopyStr(rec.Description, 1, MaxStrLen(DescriptionFieldTxt));
            Description := CopyStr(CustomerNameTxt + '; Invoice No: ' + DescriptionFieldTxt, 1, MaxStrLen(Description));
        end;

    end;
}