page 88800 RedAfAzureFunctions
{
    PageType = List;
    SourceTable = RedAfAzureFunction;
    Caption = 'Azure Functions Setup';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(List)
            {
                field(Code;Code)
                {
                    ApplicationArea = All;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                }
                field(Url;Url)
                {
                    ApplicationArea = All;
                }
                field("Parameter String";"Parameter String")
                {
                    ApplicationArea = All;
                }
                field("Key";"Key")
                {
                    ApplicationArea = All;
                }
                field(Secret;Secret)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CheckUrl)
            {
                Caption = 'Check Url';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    CheckUrl();
                end;
            }
        }
    }
}