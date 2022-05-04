page 50138 "TK Employee Details FactBox"
{
    Caption = 'Employee Details';
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                Caption = 'Employee Number';
            }
            field("First Name"; Rec."First Name")
            {
                ApplicationArea = All;
            }
            field("Middle Name"; Rec."Middle Name")
            {
                ApplicationArea = All;
            }
            field("Last Name"; Rec."Last Name")
            {
                ApplicationArea = All;
            }
            field("Phone No."; Rec."Phone No.")
            {
                ApplicationArea = All;
            }
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                ApplicationArea = All;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
            }
        }
    }
    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Employee Card", Rec);
    end;

}
