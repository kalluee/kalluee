table 50133 "TK Course Participants"
{
    Caption = 'Course Participants';
    DataClassification = CustomerContent;
    LookupPageId = "TK Course Participants List";
    DrillDownPageId = "TK Course Participants List";

    fields
    {
        field(11; "Course Code"; Code[20])
        {
            Caption = 'Course Code';
            TableRelation = "TK Course";
        }
        field(12; "Course Name"; Text[50])
        {
            Caption = 'Course Name';
            FieldClass = FlowField;
            CalcFormula = lookup("TK Course".Name where("Course Code" = field("Course Code")));
        }
        field(13; "Course Location"; Enum "TK Course Location Enum")
        {
            Caption = 'Course Location';
            FieldClass = FlowField;
            CalcFormula = lookup("TK Course".Location where("Course Code" = field("Course Code")));
        }
        field(50; "Starting date"; Date)
        {
            Caption = 'Starting Date';
            FieldClass = FlowField;
            CalcFormula = lookup("TK Course"."Starting date" where("Course Code" = field("Course Code")));
        }
        field(60; "End date"; Date)
        {
            Caption = 'End Date';
            FieldClass = FlowField;
            CalcFormula = lookup("TK Course"."End date" where("Course Code" = field("Course Code")));
        }
        field(20; "Participant Code"; Code[20])
        {
            Caption = 'Participant Code';
            DataClassification = CustomerContent;
            TableRelation = Employee;
            NotBlank = true;
        }
        field(30; "First Name"; Text[30])
        {
            Caption = 'First Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" where("No." = field("Participant Code")));
        }
        field(40; "Last Name"; Text[30])
        {
            Caption = 'Last Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Last Name" where("No." = field("Participant Code")));
        }
    }

    keys
    {
        key(PK; "Course Code", "Participant Code")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        AvailableSpots(false);
    end;

    trigger OnModify()
    begin
        AvailableSpots(false);
    end;

    trigger OnDelete()
    begin
        AvailableSpots(true);
    end;

    trigger OnRename()
    begin

    end;

    local procedure AvailableSpots(IsDeleted: Boolean)
    var
        RegAtt: Integer;
        MaxAtt: Integer;
        CourseList: Record "TK Course";
    begin

        CourseList.Get(Rec."Course Code");
        CourseList.CalcFields("Registered Participants");

        RegAtt := CourseList."Registered Participants";
        MaxAtt := CourseList."Max No. of Participants";
        CourseList."Available Slots" := MaxAtt - RegAtt;

        if not IsDeleted then
            if RegAtt >= MaxAtt then begin
                Error('');
            end;
        CourseList.Modify();
    end;
}