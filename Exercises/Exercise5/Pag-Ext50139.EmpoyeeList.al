pageextension 50139 "TK Empoyee List" extends "Employee List"
{
    actions
    {
        addbefore("Absence Registration")
        {
            action("TK Participants Course List")
            {
                Caption = 'Participants Course List';
                ApplicationArea = All;

                trigger OnAction()
                var
                    Courses: Record "TK Course" temporary;
                begin
                    Courses.FilterByEmployee(Rec, Courses);
                    Page.Run(0, Courses);
                end;
            }
        }
    }
}