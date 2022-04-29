page 50134 "TK Course Card"
{
    Caption = 'Course Card';
    PageType = Document;
    UsageCategory = Documents;
    SourceTable = "TK Course";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Course Information';
                field("Course Code"; Rec."Course Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        LocationDetails();
                        CurrPage.Update();
                    end;
                }
                field("Location details"; Rec."Location details")
                {
                    ApplicationArea = All;
                    Editable = LocationEditable;
                }
            }
            group("Course Details")
            {
                Caption = 'Details';

                field("Starting date"; Rec."Starting date")
                {
                    ApplicationArea = All;
                }
                field("End date"; Rec."End date")
                {
                    ApplicationArea = All;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }
                field("Max No. of Attendees"; Rec."Max No. of Participants")
                {
                    ApplicationArea = All;
                }
                field("Registered Attendees"; Rec."Registered Participants")
                {
                    ApplicationArea = All;
                }
                field("Available Spots"; AvailableSpots())
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Details; TextToBlob)
                {
                    Caption = 'Details';
                    ApplicationArea = All;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        rec.SetCourseInformationToField(TextToBlob);
                        CurrPage.Update();
                    end;
                }
            }
            part(Participants; "TK Course Participants List")
            {
                Caption = 'Participant list';
                SubPageLink = "Course Code" = field("Course Code");
                UpdatePropagation = SubPart;
            }
        }
        area(FactBoxes)
        {
            part("Employee Picture"; "Employee Picture")
            {
                Provider = Participants;
                SubPageLink = "No." = field("Participant Code");
            }
            part("Employee Information"; "TK Employee Details FactBox")
            {
                Provider = Participants;
                SubPageLink = "No." = field("Participant Code");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        [InDataSet]
        LocationEditable: Boolean;
        TextToBlob: Text;



    trigger OnAfterGetRecord()
    begin
        Rec.GetCourseInformationFromField(TextToBlob);
    end;


    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        if true then;
    end;

    procedure LocationDetails()
    begin
        case rec.Location of
            "TK Course Location Enum"::"Office - Tallinn", "TK Course Location Enum"::"Office - Tartu":
                begin
                    LocationEditable := false;
                    rec."Location details" := '';
                end;

            "TK Course Location Enum"::Other, "TK Course Location Enum"::"On-Line":
                begin
                    LocationEditable := True;
                end;

        end;
    end;


    local procedure AvailableSpots(): Integer
    begin
        exit(rec."Max No. of Participants" - rec."Registered Participants");
    end;



}