pageextension 50101 "TK Sales Quote" extends "Sales Quote"
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