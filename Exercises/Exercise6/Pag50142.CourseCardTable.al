page 50142 "TK Course Card Table"
{
    AutoSplitKey = true;
    Caption = 'Course Card Table';
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = "TK Course";


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Course Code"; Rec."Course Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Details; Rec.Details)
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
                }
                field("Location details"; Rec."Location details")
                {
                    ApplicationArea = All;
                }
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
                field("Max No. of Participants"; Rec."Max No. of Participants")
                {
                    ApplicationArea = All;
                }
                field("Registered Participants"; Rec."Registered Participants")
                {
                    ApplicationArea = All;
                }
                field("Available Slots"; AvailableSpots())
                {
                    ApplicationArea = All;
                    Enabled = false;
                    Editable = true;

                }
            }
            part(Participants; "TK Course Participants List")
            {
                Caption = 'Participant list';
                SubPageLink = "Course Code" = field("Course Code");
                UpdatePropagation = SubPart;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("&Import")
            {
                Caption = '&Import';
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if rec."Course Code" = '' then
                        Error(CourseCodeISBlankMsg);
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }
            action("&Export")
            {
                Caption = '&Export';
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ExportToExcel();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        AvailableSpots()
    end;

    var
        FileName: Text[100];
        NewSheetName: Text[100];
        MainSheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        CourseBuffer: Record "TK Course";
        ParticipantsBuffer: Record "TK Course Participants";
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        CourseCodeISBlankMsg: Label 'Course Code field is blank';
        ExcelImportSuccess: Label 'Excel is successfully imported.';
        BookNameTxt: Label 'Export Courses';
        HeaderTxt: Label 'Export Courses';
        CurrentRow: Integer;
        CurrentCol: Integer;


    local procedure GetValueAtCell(Row: Integer; Col: Integer): Text
    begin
        TempExcelBuffer.Reset();
        if TempExcelBuffer.Get(Row, Col) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        InS: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, InS);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            NewSheetName := TempExcelBuffer.SelectSheetsNameStream(InS);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(InS, NewSheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        Row: Integer;
        Col: Integer;
        MaxRowNo: Integer;
        LineNo: Integer;
    begin
        Row := 0;
        Col := 0;
        MaxRowNo := 0;
        LineNo := 0;
        CourseBuffer.Reset();
        ParticipantsBuffer.Reset();

        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for Row := 2 to MaxRowNo do begin
            if CourseBuffer.Get(GetValueAtCell(Row, 1)) then begin
                CourseBuffer.Init();
                Evaluate(CourseBuffer."Course Code", GetValueAtCell(Row, 1));
                Evaluate(CourseBuffer.Name, GetValueAtCell(Row, 2));
                Evaluate(CourseBuffer.Description, GetValueAtCell(Row, 3));
                Evaluate(CourseBuffer.Location, GetValueAtCell(Row, 4));
                Evaluate(CourseBuffer."Location details", GetValueAtCell(Row, 5));
                Evaluate(CourseBuffer."Starting date", GetValueAtCell(Row, 6));
                Evaluate(CourseBuffer."End date", GetValueAtCell(Row, 7));
                Evaluate(CourseBuffer.Price, GetValueAtCell(Row, 8));
                Evaluate(CourseBuffer."Max No. of Participants", GetValueAtCell(Row, 9));
                CourseBuffer.Modify();
            end;
            if not CourseBuffer.Get(GetValueAtCell(Row, 1)) then begin
                CourseBuffer.Init();
                Evaluate(CourseBuffer."Course Code", GetValueAtCell(Row, 1));
                Evaluate(CourseBuffer.Name, GetValueAtCell(Row, 2));
                Evaluate(CourseBuffer.Description, GetValueAtCell(Row, 3));
                Evaluate(CourseBuffer.Location, GetValueAtCell(Row, 4));
                Evaluate(CourseBuffer."Location details", GetValueAtCell(Row, 5));
                Evaluate(CourseBuffer."Starting date", GetValueAtCell(Row, 6));
                Evaluate(CourseBuffer."End date", GetValueAtCell(Row, 7));
                Evaluate(CourseBuffer.Price, GetValueAtCell(Row, 8));
                Evaluate(CourseBuffer."Max No. of Participants", GetValueAtCell(Row, 9));
                CourseBuffer.Insert();
            end;
        end;
        Message(ExcelImportSuccess);
    end;

    local procedure ExportToExcel()
    begin
        MainSheetName := 'Courses';
        TempExcelBuffer.CreateNewBook(MainSheetName);
        TempExcelBuffer.WriteSheet(HeaderTxt, CompanyName(), UserId());

        ExportCourseTable();

        TempExcelBuffer.CloseBook();
        DownloadAndOpenExcel();
    end;

    local procedure ExportCourseTable()
    begin
        CourseBuffer.Reset();
        if CourseBuffer.FindSet() then
            ExportCourseHeader();
        repeat
            TempExcelBuffer.SelectOrAddSheet(MainSheetName);
            CourseBuffer.CalcFields("Registered Participants");
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn(CourseBuffer."Course Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CourseBuffer.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CourseBuffer.Description, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CourseBuffer.Location, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CourseBuffer."Location details", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn(CourseBuffer."Starting date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
            TempExcelBuffer.AddColumn(CourseBuffer."End date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
            TempExcelBuffer.AddColumn(CourseBuffer.Price, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(CourseBuffer."Max No. of Participants", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(CourseBuffer."Registered Participants", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            TempExcelBuffer.AddColumn(CourseBuffer."Available Slots", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

            ExportCourseParticipantTable();

        until CourseBuffer.Next() = 0;
    end;

    local procedure ExportCourseParticipantTable()
    begin
        CourseBuffer.Reset();
        ParticipantsBuffer.Reset();
        ParticipantsBuffer.SetRange("Course Code", CourseBuffer."Course Code");
        if ParticipantsBuffer.FindSet() then begin
            NewSheetName := Format(CourseBuffer."Course Code");
            TempExcelBuffer.WriteSheet(NewSheetName, CompanyName(), UserId());
            TempExcelBuffer.SelectOrAddSheet(NewSheetName);
            ExportParticipantsListHeader();
            repeat
                ParticipantsBuffer.CalcFields("First Name", "Last Name");
                TempExcelBuffer.DeleteAll();
                TempExcelBuffer.Init();
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(ParticipantsBuffer."Participant Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ParticipantsBuffer."First Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(ParticipantsBuffer."Last Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until ParticipantsBuffer.Next() = 0;
        end;

    end;

    local procedure ExportCourseHeader()
    begin
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.Init();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Course Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Description', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location details', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Starting date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('End date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Price', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Max No. of Participants', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Registered Participants', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Available Slots', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure ExportParticipantsListHeader()
    begin
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.Init();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Participant Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('First Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Last Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure DownloadAndOpenExcel()
    begin
        TempExcelBuffer.SetFriendlyFilename(BookNameTxt);
        TempExcelBuffer.OpenExcel();
    end;

    local procedure AvailableSpots(): Integer
    begin
        if (rec."Max No. of Participants" - rec."Registered Participants") < 0 then
            Error('Too many participants already registered!');
        exit(rec."Max No. of Participants" - rec."Registered Participants");
    end;

    procedure SetCurrent(NewCurrentRow: Integer; NewCurrentCol: Integer)
    begin
        CurrentRow := NewCurrentRow;
        CurrentCol := NewCurrentCol;
    end;

    procedure NewRow()
    begin
        SetCurrent(CurrentRow + 1, 0);
    end;
}