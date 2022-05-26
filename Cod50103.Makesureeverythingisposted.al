codeunit 50103 "Make sure everything is posted"
{
    [EventSubscriber(ObjectType::Table, Database::"Invoice Post. Buffer", 'OnAfterInvPostBufferPrepareSales', '', true, true)]
    local procedure MyProcedure(var InvoicePostBuffer: Record "Invoice Post. Buffer"; var SalesLine: Record "Sales Line")
    begin
        InvoicePostBuffer."Additional Grouping Identifier" := Format(SalesLine."Line No.", 0, 2)
    end;
}
