codeunit 88800 RedAfWorkflowRespHandling
{
    procedure CreateResponsesLibrary();
    var
        WorkflowResponseHandling : Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(CheckEmailAddressCode, 0 , CheckEmailAddressTxt, 'GROUP 6');
    end;

    local procedure CheckEmailAddressCode() : Code[128];
    begin
        exit(UpperCase('CheckEmailAddressCode')); 
    end;

    [EventSubscriber(ObjectType::CodeUnit, CodeUnit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsesToLibrary();
    begin
        CreateResponsesLibrary();
    end;

    procedure DeleteResponsesLibrary();
    var
        WorkflowResponse : Record "Workflow Response";
    begin
        with WorkflowResponse do begin
            if Get(CheckEmailAddressCode) then
                Delete(true);
        end;
    end;

    var
        CheckEmailAddressTxt : Label 'Check the email address';

    [EventSubscriber(ObjectType::Codeunit , Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure OnExecuteWorkflowResponse(var ResponseExecuted : Boolean; Variant : Variant; xVariant : Variant; ResponseWorkflowStepInstance : Record "Workflow Step Instance");
    var
        WorkflowResponse : Record "Workflow Response";
        WorkflowStepArgument : Record "Workflow Step Argument";
        RedAfAzureFunctionCalls : Codeunit RedAfAzureFunctionCalls;
    begin
        if not WorkflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
            exit;
        if WorkflowStepArgument.Get(ResponseWorkflowStepInstance.Argument) then;

        case WorkflowResponse."Function Name" of
            CheckEmailAddressCode:
                RedAfAzureFunctionCalls.CallCheckEmailAddress(Variant, xVariant, WorkflowStepArgument."Field No.");
            else
                exit;
        end;

        ResponseExecuted := true;
    end;
}