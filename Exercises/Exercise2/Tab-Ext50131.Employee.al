tableextension 50131 "TK Employee" extends "Employee"
{
    fields
    {
        field(50100; "TK Personal ID"; Text[11])
        {
            Caption = 'Personal ID', comment = 'et-EE=Isikukood';
        }
        field(50101; "TK Age"; Text[50])
        {
            Caption = 'Age', comment = 'et-EE=Vanus';
        }
    }
}