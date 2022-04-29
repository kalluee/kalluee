page 50136 "TK Course Participants List"
{
    SourceTable = "TK Course Participants";
    Caption = 'Course Participant List';
    PageType = ListPart;
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Course Code"; Rec."Course Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Participant Code"; Rec."Participant Code")
                {
                    ApplicationArea = All;
                }
                field("First Name"; Rec."First Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}