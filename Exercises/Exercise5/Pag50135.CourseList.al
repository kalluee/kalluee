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
                field("Available Spots"; Rec."Available Slots")
                {
                    ApplicationArea = All;
                }
            }
        }

        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

            }
        }
    }
}