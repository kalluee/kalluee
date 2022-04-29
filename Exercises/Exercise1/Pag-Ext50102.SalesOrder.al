pageextension 50102 "TK Sales Order" extends "Sales Order"
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