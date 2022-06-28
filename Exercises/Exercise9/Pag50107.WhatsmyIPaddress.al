page 50107 "TK What's my IP address"
{
    PageType = Card;
    Caption = 'What is my IP address';
    Editable = false;
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(Content)
        {
            field(IP; GetIp())
            {
                Caption = 'Current IP address of BC Server';
                ApplicationArea = all;
            }
        }
    }
    procedure GetIp(): Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        J: JsonObject;
        ResponseTxt: Text;
    begin
        // https://api.ipify.org?format=json
        if Client.Get('https://api.ipify.org?format=json', Response) then
            if Response.IsSuccessStatusCode() then begin
                Response.Content().ReadAs(ResponseTxt);
                J.ReadFrom(ResponseTxt);
                exit(GetJsonTextField(J, 'ip'));
            end;
    end;

    procedure GetJsonTextField(O: JsonObject; Member: Text): Text
    var
        Result: JsonToken;
    begin
        if O.Get(Member, Result) then
            exit(Result.AsValue().AsText())
    end;
}