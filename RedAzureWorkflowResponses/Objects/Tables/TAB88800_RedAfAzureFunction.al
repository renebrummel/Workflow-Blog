table 88800 REDAfAzureFunction
{
    Caption = 'Azure Function';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(20; Url; Text[250])
        {
            Caption = 'Url';
            DataClassification = ToBeClassified;

            trigger OnValidate();
            begin
                CheckUrl();
            end;
        }
        field(30; "Parameter String"; Text[50])
        {
            Caption = 'Parameter String';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(40; "Key"; Text[50])
        {
            Caption = 'Key';
            DataClassification = ToBeClassified;
        }
        field(50; "Secret"; Text[50])
        {
            Caption = 'Secret';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; Code)
        {
            ClusteRED = true;
        }
    }

    trigger OnInsert();
    begin
        Error(CannotInsertErr);
    end;

    trigger OnDelete();
    begin
        Error(CannotDeleteErr);
    end;

    procedure CheckUrl();
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
    begin
        if Url = '' then
            exit;
        if not Client.Get(Url, ResponseMessage) then
            if not Confirm(StrSubstNo(UrlNotAvailableMsg, Url), true) then
                Url := '';
    end;

    var
        UrlNotAvailableMsg: Label 'Url %1 is not available. Do you want to continue?';
        CannotDeleteErr: Label 'You cannot delete this record.';
        CannotInsertErr: Label 'You cannot insert new records in this table.';
}