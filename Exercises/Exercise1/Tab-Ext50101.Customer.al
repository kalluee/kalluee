tableextension 50101 "TK Customer" extends "Customer"
{
    fields
    {
        field(50000; "TK Sales Amount"; Decimal)
        {
            Caption = 'Sales Amount', comment = 'et-EE=Müügi summa';

            FieldClass = FlowField;
            CalcFormula = Sum("Sales Invoice Line".Amount
                                WHERE("Bill-to Customer No." = FIELD("No.")));
        }
        field(50001; "TK Bonus Level"; Option)
        {
            Caption = 'Bonus level', comment = 'et-EE=Boonuse tase';
            OptionMembers = "Bronze","Silver","Gold";
        }
    }
}