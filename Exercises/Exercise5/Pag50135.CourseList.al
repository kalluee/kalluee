page 50135 "TK Course List"
{
    SourceTable = "TK Course";
    Caption = 'Course List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    CardPageId = "TK Course Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'Courses';

                field("Course No."; Rec."Course Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }
                field("Available Spots"; AvailableSpots())
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        AvailableSpots()
    end;

    local procedure AvailableSpots(): Integer
    begin
        if (rec."Max No. of Participants" - rec."Registered Participants") < 0 then
            Error('Too many participants already registered');
        exit(rec."Max No. of Participants" - rec."Registered Participants");
    end;
}