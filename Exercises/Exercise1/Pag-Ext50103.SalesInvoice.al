pageextension 50103 "TK Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        addbefore("Payment Discount %")
        {
            field("TK Discount %"; Rec."TK Discount %")
            {
                ToolTip = 'Specifies the value of the Discount field.',
                Comment = 'et-EE=Allahindlus';
                ApplicationArea = all;
            }
        }
    }
}