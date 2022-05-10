codeunit 50146 "TK Events"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostInvPostBuffer', '', true, true)]
    local procedure "Sales-Post_OnBeforePostInvPostBuffer"
    (
        var GenJnlLine: Record "Gen. Journal Line";
        var InvoicePostBuffer: Record "Invoice Post. Buffer";
        var SalesHeader: Record "Sales Header";
        CommitIsSuppressed: Boolean;
        var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        PreviewMode: Boolean
    )
    begin
        // GenJnlLine.AddClientNameToDescription();
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGLAcc', '', true, true)]
    local procedure "Gen. Jnl.-Post Line_OnBeforePostGLAcc"
    (
        GenJournalLine: Record "Gen. Journal Line";
        var GLEntry: Record "G/L Entry";
        var GLEntryNo: Integer;
        var IsHandled: Boolean
    )

    begin
        if true then
            exit;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeStartOrContinuePosting', '', true, true)]
    local procedure "Gen. Jnl.-Post Line_OnBeforeStartOrContinuePosting"
    (
        var GenJnlLine: Record "Gen. Journal Line";
        LastDocType: Option;
        LastDocNo: Code[20];
        LastDate: Date;
        var NextEntryNo: Integer
    )

    begin
        GenJnlLine.AddClientNameToDescription();
    end;


}