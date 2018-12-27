codeunit 88805 RedAfAzureFunctionCalls
{
    procedure CallCheckEmailAddress(Variant: Variant; xVariant: Variant; FieldNo: Integer);
    var
        REDAfAzureFunction: Record REDAfAzureFunction;
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        StreamIn: InStream;
        RequestBuilder: TextBuilder;
        EmailAddress: Text;
        xEmailAddress: Text;
        Result: Text;
    begin
        EmailAddress := GetEmailFromVariant(Variant, FieldNo);
        if EmailAddress = '' then
            exit;

        xEmailAddress := GetEmailFromVariant(xVariant, FieldNo);
        if EmailAddress = xEmailAddress then
            exit;

        REDAfAzureFunction.Get('EMAIL');

        RequestBuilder.Append(REDAfAzureFunction.Url);
        RequestBuilder.Append(StrSubstNo(REDAfAzureFunction."Parameter String", EmailAddress));
        if not Client.Get(RequestBuilder.ToText, ResponseMessage) then begin
            Message(EndpointNotAvaiableMsg, REDAfAzureFunction.Url);
            exit;
        end;

        if ResponseMessage.Content.ReadAs(StreamIn) then begin
            StreamIn.Read(Result);
            case ResponseMessage.HttpStatusCode of
                200:
                    Message(
                        ExpectedResultMsg,
                        ResponseMessage.HttpStatusCode,
                        ResponseMessage.ReasonPhrase,
                        Result);
                400:
                    Error(
                        InvalidEmailAddressErr,
                        EmailAddress,
                        ResponseMessage.HttpStatusCode,
                        ResponseMessage.ReasonPhrase,
                        Result);
                else
                    Message(
                        UnexpectedResultMsg,
                        ResponseMessage.HttpStatusCode,
                        ResponseMessage.ReasonPhrase,
                        Result);
            end;
        end;
    end;

    local procedure GetEmailFromVariant(Variant: Variant; FieldNo: Integer): Text;
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.GetTable(Variant);
        FieldRef := RecRef.Field(FieldNo);
        exit(FieldRef.Value);
    end;

    var
        EndpointNotAvaiableMsg: Label 'Endpoint %1 is not available. Cannot check email address';
        InvalidEmailAddressErr: Label '%1 is not a valid email address. Resp Code %2, Message %3, Content %4';
        UnexpectedResultMsg: Label 'The result was unexpected. Resp Code %1, Message %2, Content %3';
        ExpectedResultMsg: Label 'The result was expected. Resp Code %1, Message %2, Content %3';
}