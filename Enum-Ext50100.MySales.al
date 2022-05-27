enumextension 50100 "TK MySales" extends "Sales Line Type"
{
    value(50100; Job)
    {
        Caption = 'Job';
    }
}
codeunit 50105 "Our Subscriber"
{
    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnBeforeIncludeOption', '', true, true)]
    local procedure OnBeforeIncludeOption(LookupType: Option; Option: Integer;
                                            OptionLookupBuffer: Record "Option Lookup Buffer";
                                            RecRef: RecordRef;
                                            var Handled: Boolean;
                                            var Result: Boolean)
    begin
        if (LookupType = 0) and (Option = 50100) and (RecRef.Number = 37) then begin
            Handled := true;
            Result := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateNo', '', true, true)]
    local procedure SalesLine_OnBeforeValidateNo(CurrentFieldNo: Integer; var IsHandled: Boolean; var SalesLine: Record "Sales Line")
    begin
        if SalesLine.Type = SalesLine.Type::Job then
            IsHandled := true;
    end;
}
