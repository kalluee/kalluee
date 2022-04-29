pageextension 50100 "TK Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("Balance (LCY)")
        {

            field("TK Bonus Level"; Rec."TK Bonus Level")
            {
                ToolTip = 'Specifies the value of the Bonus level field.',
                Comment = 'et-EE=Boonuse tase';
                ApplicationArea = All;
                StyleExpr = RowsStyle;
                Editable = false;

            }
            field("TK Sales Amount"; Rec."TK Sales Amount")
            {
                ToolTip = 'Specifies the value of the Sales Amount field.',
                Comment = 'et-EE=Müügi summa';
                ApplicationArea = All;
                StyleExpr = RowsStyle;
                Editable = false;
            }
        }

        moveafter(AdjCustProfit; "Balance Due (LCY)")
        // Add changes to page layout here
    }


    procedure RewardLevel()
    begin
        Rec.CalcFields("TK Sales Amount");
        case true of
            Rec."TK Sales Amount" < 500000:
                begin
                    Rec."TK Bonus Level" := Rec."TK Bonus Level"::Bronze;
                    Rec.Modify();
                end;
            (Rec."TK Sales Amount" >= 500000) and (Rec."TK Sales Amount" < 1000000):
                begin
                    Rec."TK Bonus Level" := Rec."TK Bonus Level"::Silver;
                    Rec.Modify();
                end;
            Rec."TK Sales Amount" >= 1000000:
                begin
                    Rec."TK Bonus Level" := Rec."TK Bonus Level"::Gold;
                    Rec.Modify();
                end;
        end;
    end;


    var
        RowsStyle: Text;

    trigger OnAfterGetRecord()
    begin
        RewardLevel();
        //Lisan värvikoodi
        case Rec."TK Bonus Level" of
            Rec."TK Bonus Level"::Bronze:
                RowsStyle := 'StrongAccent';
            Rec."TK Bonus Level"::Silver:
                RowsStyle := 'Favorable';
            Rec."TK Bonus Level"::Gold:
                RowsStyle := 'Ambiguous';
        end;
    end;
}