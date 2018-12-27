codeunit 88810 RedAfInstall
{
    Subtype = Install;

    trigger OnInstallAppPerCompany();
    begin
        SetupRedAzureFunctionCalls();
    end;

    local procedure SetupRedAzureFunctionCalls();
    var
        REDAfAzureFunction: Record REDAfAzureFunction;
    begin
        with REDAfAzureFunction do begin
            Init();
            Code := 'EMAIL';
            Description := EmailDescriptionMsg;
            "Parameter String" := '?email=%1';
            If Insert() then;
        end;
    end;

    var
        EmailDescriptionMsg: Label 'Checks if an email address is valid';
}