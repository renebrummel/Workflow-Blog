pageextension 88900 RedJobQueueEntryCard extends "Job Queue Entry Card"
{
    layout
    {
        addafter(Recurrence)
        {
            group(Notification)
            {
                field("E-mail RED"; "E-mail RED")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}