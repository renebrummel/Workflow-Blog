codeunit 88900 RedAfWorkflowEventHandling
{
    procedure CreateEventsLibrary();
    var
        WorkflowEventHandling : Codeunit "Workflow Event Handling";
    begin
        WorkflowEventHandling.AddEventToLibrary(
            RedOnValidateJobQueueEntryEmailAddressCode, Database::"Job Queue Entry", RedOnValidateJobQueueEntryEmailAddressTxt, 0, true);
    end;

    procedure DeleteEventsLibrary();
    var
        WorkflowEvent : Record "Workflow Event";
    begin
        with WorkflowEvent do begin
            if Get(RedOnValidateJobQueueEntryEmailAddressCode) then
                delete(true);
        end;
    end;
    
    [EventSubscriber(ObjectType::CodeUnit, CodeUnit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary();
    begin
        CreateEventsLibrary();
    end;

    procedure RedOnValidateJobQueueEntryEmailAddressCode() : Code[128];
    begin
        exit(UpperCase('RedOnValidateJobQueueEntryEmailAddressCode'));        
    end;

    var
        RedOnValidateJobQueueEntryEmailAddressTxt : Label 'An email address has been entered on the Job Queue Entry';

    [EventSubscriber(ObjectType::Table , DataBase::"Job Queue Entry", 'OnAfterValidateEvent', 'E-Mail RED', false, false)]
    local procedure CustomerOnBeforeValidateEmail(var Rec : Record "Job Queue Entry"; var xRec : Record "Job Queue Entry");
    var
        WorkflowManagement : Codeunit "Workflow Management";
    begin
        WorkflowManagement.HandleEventWithxRec(RedOnValidateJobQueueEntryEmailAddressCode, Rec, xRec);
    end;
}