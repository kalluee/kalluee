table 50132 "TK Course"
{
    Caption = 'Employee Course';
    DataClassification = CustomerContent;
    LookupPageId = "TK Course List";
    DrillDownPageId = "TK Course List";


    fields
    {
        field(10; "Course Code"; Code[20])
        {
            Caption = 'Course Code';
            DataClassification = CustomerContent;
        }
        field(20; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(40; Location; Enum "TK Course Location Enum")
        {
            Caption = 'Location';
            DataClassification = CustomerContent;
        }
        field(41; "Location details"; Text[100])
        {
            Caption = 'Location Details';
            DataClassification = ToBeClassified;
        }
        field(50; "Starting date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(60; "End date"; Date)
        {
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(70; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = CustomerContent;
        }
        field(80; "Max No. of Participants"; Integer)
        {
            Caption = 'Max No. of Participants';
            DataClassification = CustomerContent;
        }
        field(90; "Registered Participants"; Integer)
        {
            Caption = 'Registered Participants';
            FieldClass = FlowField;
            CalcFormula = count("TK Course Participants" where("Course Code" = field("Course Code")));
        }
        field(100; "Available Slots"; Integer)
        {
            Caption = 'Available Slots';
            DataClassification = CustomerContent;


        }
        field(110; Details; Blob)
        {
            Caption = 'Details';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Course Code")
        {
            Clustered = true;
        }
        key(MyKey; "Starting date")
        {

        }
    }

    procedure SetCourseInformationToField(TextToBlob: Text)
    var
        OutS: OutStream;
    begin
        Clear("Details");
        Modify();
        if TextToBlob = '' then
            exit;

        "Details".CreateOutStream(OutS);
        OutS.WriteText(TextToBlob);
        Modify();
    end;

    procedure GetCourseInformationFromField(var TextToBlob: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        InS: InStream;
    begin
        CalcFields("Details");
        if not "Details".HasValue() then begin
            TextToBlob := '';
            exit;
        end;
        TempBlob.FromRecord(Rec, fieldNo("Details"));
        TempBlob.CreateInStream(InS);
        InS.Read(TextToBlob);

    end;

    procedure FilterByEmployee(Employee: Record Employee; var tempCourse: Record "TK Course" temporary)
    var
        CourseParticipants: Record "TK Course Participants";
        Course: Record "TK Course";

    begin
        tempCourse.Reset();
        tempCourse.DeleteAll();
        CourseParticipants.Reset();
        CourseParticipants.SetRange("Participant Code", Employee."No.");
        if CourseParticipants.FindSet() then
            repeat
                if not tempCourse.Get(CourseParticipants."Course Code")
                then begin
                    if Course.Get(CourseParticipants."Course Code") then begin
                        tempCourse := Course;
                        tempCourse.Insert();
                    end;
                end;
            until CourseParticipants.Next() = 0;
    end;


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}