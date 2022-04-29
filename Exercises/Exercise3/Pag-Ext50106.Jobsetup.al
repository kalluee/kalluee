pageextension 50106 "TK Job setup" extends "Jobs Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group("New Jobs")
            {

                field("TK Job Def. Dim. Code"; Rec."TK Job Def. Dim. Code")
                {
                    Caption = 'Default Dimention Code';
                    ToolTip = 'Specifies the value of the TK Job Def. Dim. Code field.';
                    ApplicationArea = All;
                }
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

}