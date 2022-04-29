page 50137 "TK Participants Course List"
{
    SourceTable = "TK Course Participants";
    Caption = 'Participants Course List';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Participant Code"; Rec."Participant Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Course Code"; Rec."Course Code")
                {
                    ApplicationArea = All;

                }
                field("Course Name"; Rec."Course Name")
                {
                    ApplicationArea = All;
                }
                field(Location; Rec."Course Location")
                {
                    ApplicationArea = All;
                }
                field("Starting date"; Rec."Starting date")
                {
                    ApplicationArea = All;
                }
                field("End date"; Rec."End date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}