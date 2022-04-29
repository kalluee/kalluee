pageextension 50130 "TK Employee Card" extends "Employee Card"
{
    layout
    {
        addafter("Last Name")
        {
            field("TK Personal ID"; Rec."TK Personal ID")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    DecodePersonalId();
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
        }
        addafter("Birth Date")
        {
            field("TK Age"; Rec."TK Age")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        addafter(Personal)
        {
            group("TK Courses")
            {
                Caption = 'Listed Courses';
                part("Participants Course List"; "TK Participants Course List")
                {
                    SubPageLink = "Participant Code" = field("No.");
                    UpdatePropagation = SubPart;
                    ApplicationArea = all;
                }
            }
        }
    }


    local procedure DecodePersonalId()
    var
        Employee: Record Employee;
        PersonalId: Text[11];
        PersonalIdNumber: BigInteger;
        DOB: Date;
        GenderInt: Integer;
    begin
        Employee := Rec;
        PersonalId := Rec."TK Personal ID";
        if StrLen(PersonalId) <> 11 then begin
            Error('Valesti sisestatud isikukood (liiga lühike)!');
            exit;
        end;
        if not Evaluate(PersonalIdNumber, PersonalId) then begin
            Error('Valesti sisestatud isikukood! Sisesta ainult numbrid');
            exit;
        end;
        GenderFromPersonalId(CopyStr(Rec."TK Personal ID", 1, 1), GenderInt);
        DateOfBirthFromPersonalId(CopyStr(Rec."TK Personal ID", 2, 6), GenderInt);
        EmployeeAge(Rec."Birth Date");
    end;


    local procedure GenderFromPersonalId(Gender: Text; var GenderInt: Integer)
    var
        re: Codeunit Regex;
        temp: text;
        _Matches: Record Matches;

    begin
        temp := Gender;

        re.Match(temp, '(\d{1})(\d{2})(\d{2})(\d{2})(\d{3})(\d{1})', _Matches);
        if _Matches.FindSet() then
            repeat
                temp := _Matches.ReadValue();
            until _Matches.Next() = 0;

        Evaluate(GenderInt, Gender);
        case GenderInt of
            1, 3, 5:
                begin
                    Rec.Gender := enum::"Employee Gender"::Male;
                end;
            2, 4, 6:
                begin
                    Rec.Gender := enum::"Employee Gender"::Female;
                end;
            else begin
                    Error('Valesti sisestatud isikukood!');
                    exit;
                end;
        end;
    end;

    local procedure DateOfBirthFromPersonalId(DOB: Text; GenderInt: Integer)
    var
        DOBInt, YearOBInt, MonthOBInt, DayOBInt : Integer;
    begin
        Evaluate(DOBInt, DOB);

        YearOBInt := DOBInt div 10000;
        MonthOBInt := (DOBInt - YearOBInt * 10000) div 100;
        DayOBInt := DOBInt - YearOBInt * 10000 - MonthOBInt * 100;

        case GenderInt of
            1, 2:
                YearOBInt := YearOBInt + 1800;
            3, 4:
                YearOBInt := YearOBInt + 1900;
            5, 6:
                YearOBInt := YearOBInt + 2000;
            else
                Error('Valesti sisestatud isikukood!');
        end;

        if DMY2Date(DayOBInt, MonthOBInt, YearOBInt) >= Today then Error('Viga Isikukoodi sisestamisel, kuupäev tulevikus!');
        Rec.Validate("Birth Date", DMY2Date(DayOBInt, MonthOBInt, YearOBInt));
    end;

    local procedure EmployeeAge("Birth Date": Date)
    var
        AgeInDays, AgeDaysCountdown, CurrentYear, CurrentMonth, CurrentDay, BirthYear, BirthMonth, BirthDay, AgeDay, AgeMonth, AgeYear, LeapYears, LastYearNumber : Integer;
        AgeInTextDay, AgeInTextMonth, AgeInTextYear, AgeText : Text;
        TestDate, LeapDay, BirthdayCurrentYear, BirthdayLastYear : Date;

    begin

        AgeDaysCountdown := Today - "Birth Date";


        BirthDay := Date2DMY("Birth Date", 1);
        BirthMonth := Date2DMY("Birth Date", 2);
        BirthYear := Date2DMY("Birth Date", 3);

        CurrentDay := Date2DMY(Today, 1);
        CurrentMonth := Date2DMY(Today, 2);
        CurrentYear := Date2DMY(Today, 3);

        BirthdayCurrentYear := DMY2Date(BirthDay, BirthMonth, CurrentYear);
        BirthdayLastYear := DMY2Date(BirthDay, BirthMonth, (CurrentYear - 1));

        // Aasta
        If BirthdayCurrentYear < Today then begin
            AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3);
            AgeMonth := (DATE2DMY(Today, 2) - DATE2DMY("Birth Date", 2) + 12 * (DATE2DMY(Today, 3) - DATE2DMY("Birth Date", 3))) MOD (AgeYear * 12);
            AgeDay := Date2DMY(Today, 1) - DATE2DMY("Birth Date", 1);
            if AgeDay < 0 then begin
                rec."TK Age" := Format(AgeYear) + ' years ' + Format(AgeMonth) + 'months ' + Format(AgeDay) + ' days';
            end

            else
                rec."TK Age" := Format(AgeYear) + ' years ' + Format(AgeMonth) + ' months ' + Format(AgeDay) + ' days';

        end else begin

            AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3) - 1;
            AgeMonth := (DATE2DMY(Today, 2) - DATE2DMY("Birth Date", 2) + 12 * (DATE2DMY(Today, 3) - DATE2DMY("Birth Date", 3))) MOD (AgeYear * 12) - 1;
            AgeDay := Date2DMY(Today, 1) - DATE2DMY("Birth Date", 1);
            if AgeDay < 0 then begin
                rec."TK Age" := Format(AgeYear) + ' years ' + Format(AgeMonth) + ' months ' + Format(AgeDay) + ' days';
            end

            else begin
                rec."TK Age" := Format(AgeYear) + ' years ' + Format(AgeMonth) + ' months ' + Format(AgeDay) + ' days';

            end;
        end;
    end;


    local procedure IsLeapYear(Year: Integer) IsLeapYear: Boolean
    begin
        if (((Year MOD 4 = 0) and (Year MOD 100 <> 0)) or (Year MOD 400 = 0)) then IsLeapYear := true
    end;

    local procedure LeapYearCount(BirthYear: Integer; DueYear: Integer) DaysInTotalYears: Integer
    var
        Year, LeapYearsCounter : Integer;
    begin
        Year := BirthYear;
        LeapYearsCounter := 0;
        while Year < DueYear do begin
            if IsLeapYear(Year) then begin
                LeapYearsCounter := LeapYearsCounter + 1;
            end;
            Year := Year + 1;
        end;
        DaysInTotalYears := (DueYear - BirthYear) * 365 + LeapYearsCounter;
    end;

    local procedure CountDaysInMonth(Month: Integer) DaysInMonth: Integer
    begin
        case Month of
            1:
                DaysInMonth := 31;
            2:
                DaysInMonth := 28;
            3:
                DaysInMonth := 31;
            4:
                DaysInMonth := 30;
            5:
                DaysInMonth := 31;
            6:
                DaysInMonth := 30;
            7:
                DaysInMonth := 31;
            8:
                DaysInMonth := 31;
            9:
                DaysInMonth := 30;
            10:
                DaysInMonth := 31;
            11:
                DaysInMonth := 30;
            12:
                DaysInMonth := 31;
        end;
    end;

}
