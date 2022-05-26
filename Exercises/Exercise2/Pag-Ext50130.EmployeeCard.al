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

    var
        FirstDigit: Integer;
        SecondDigit: Integer;
        ThirdDigit: Integer;
        FourthDigit: Integer;
        FifthDigit: Integer;
        SixthDigit: Integer;
        SeventhDigit: Integer;
        EighthDigit: Integer;
        NinthDigit: Integer;
        TenthDigit: Integer;
        LastDigit: Integer;
        FirstWeightSum: Decimal;
        SecondWeightSum: Decimal;
        PersonalId: Text[11];

    local procedure DecodePersonalId()
    var
        Employee: Record Employee;
        PersonalIdCode: BigInteger;
        DOB: Date;
        GenderInt: Integer;
        ControlInt: Integer;
    begin
        Employee := Rec;
        PersonalId := Rec."TK Personal ID";

        if StrLen(PersonalId) <> 11 then
            Error('Valesti sisestatud isikukood (liiga lühike)!');

        if not Evaluate(PersonalIdCode, PersonalId) then
            Error('Valesti sisestatud isikukood! Sisesta ainult numbrid!');

        if not IsValidIdCode(PersonalId) then
            Error('Sisestatud isikukood ei vasta standardile!');

        GenderFromPersonalId(CopyStr(Rec."TK Personal ID", 1, 1), GenderInt);
        DateOfBirthFromPersonalId(CopyStr(Rec."TK Personal ID", 2, 6), GenderInt);
        EmployeeAge(Rec."Birth Date");
    end;

    local procedure IsValidIdCode(PersonalId: Text) IsValidIdCode: Boolean
    begin
        Evaluate(LastDigit, CopyStr(PersonalId, 11));

        if GetFirstCheckNumber(PersonalId) < 10 then begin
            if GetFirstCheckNumber(PersonalId) = LastDigit then begin
                IsValidIdCode := true;
            end else
                if GetSecondCheckNumber(PersonalId) < 10 then begin
                    if GetSecondCheckNumber(PersonalId) = LastDigit then
                        IsValidIdCode := true;
                end else
                    IsValidIdCode := false;
        end;
    end;

    local procedure GetFirstCheckNumber(PersonalId: Text): Integer
    var
        FirstStage: array[10] of Integer;
        CheckFactorDivisionInt: Integer;
        CheckFactorMultiply: Integer;
        FirstCheckNumber: Integer;

    begin
        Evaluate(FirstDigit, CopyStr(PersonalId, 1, 1));
        Evaluate(SecondDigit, CopyStr(PersonalId, 2, 1));
        Evaluate(ThirdDigit, CopyStr(PersonalId, 3, 1));
        Evaluate(FourthDigit, CopyStr(PersonalId, 4, 1));
        Evaluate(FifthDigit, CopyStr(PersonalId, 5, 1));
        Evaluate(SixthDigit, CopyStr(PersonalId, 6, 1));
        Evaluate(SeventhDigit, CopyStr(PersonalId, 7, 1));
        Evaluate(EighthDigit, CopyStr(PersonalId, 8, 1));
        Evaluate(NinthDigit, CopyStr(PersonalId, 9, 1));
        Evaluate(TenthDigit, CopyStr(PersonalId, 10, 1));

        FirstStage[1] := 1;
        FirstStage[2] := 2;
        FirstStage[3] := 3;
        FirstStage[4] := 4;
        FirstStage[5] := 5;
        FirstStage[6] := 6;
        FirstStage[7] := 7;
        FirstStage[8] := 8;
        FirstStage[9] := 9;
        FirstStage[10] := 1;

        FirstWeightSum := ((FirstStage[1] * FirstDigit) +
                           (FirstStage[2] * SecondDigit) +
                           (FirstStage[3] * ThirdDigit) +
                           (FirstStage[4] * FourthDigit) +
                           (FirstStage[5] * FifthDigit) +
                           (FirstStage[6] * SixthDigit) +
                           (FirstStage[7] * SeventhDigit) +
                           (FirstStage[8] * EighthDigit) +
                           (FirstStage[9] * NinthDigit) +
                           (FirstStage[10] * TenthDigit));

        CheckFactorDivisionInt := ((FirstWeightSum / 11) div 1);
        CheckFactorMultiply := CheckFactorDivisionInt * 11;
        FirstCheckNumber := FirstWeightSum - CheckFactorMultiply;
        exit(FirstCheckNumber);
    end;

    local procedure GetSecondCheckNumber(PersonalId: Text): Integer
    var
        SecondStage: array[10] of Integer;
        CheckFactorDivisionInt: Integer;
        CheckFactorMultiply: Integer;
        SecondCheckNumber: Integer;

    begin
        Evaluate(FirstDigit, CopyStr(PersonalId, 1, 1));
        Evaluate(SecondDigit, CopyStr(PersonalId, 2, 1));
        Evaluate(ThirdDigit, CopyStr(PersonalId, 3, 1));
        Evaluate(FourthDigit, CopyStr(PersonalId, 4, 1));
        Evaluate(FifthDigit, CopyStr(PersonalId, 5, 1));
        Evaluate(SixthDigit, CopyStr(PersonalId, 6, 1));
        Evaluate(SeventhDigit, CopyStr(PersonalId, 7, 1));
        Evaluate(EighthDigit, CopyStr(PersonalId, 8, 1));
        Evaluate(NinthDigit, CopyStr(PersonalId, 9, 1));
        Evaluate(TenthDigit, CopyStr(PersonalId, 10, 1));

        SecondStage[1] := 3;
        SecondStage[2] := 4;
        SecondStage[3] := 5;
        SecondStage[4] := 6;
        SecondStage[5] := 7;
        SecondStage[6] := 8;
        SecondStage[7] := 9;
        SecondStage[8] := 1;
        SecondStage[9] := 2;
        SecondStage[10] := 3;

        SecondWeightSum := ((SecondStage[1] * FirstDigit) +
                            (SecondStage[2] * SecondDigit) +
                            (SecondStage[3] * ThirdDigit) +
                            (SecondStage[4] * FourthDigit) +
                            (SecondStage[5] * FifthDigit) +
                            (SecondStage[6] * SixthDigit) +
                            (SecondStage[7] * SeventhDigit) +
                            (SecondStage[8] * EighthDigit) +
                            (SecondStage[9] * NinthDigit) +
                            (SecondStage[10] * TenthDigit));

        CheckFactorDivisionInt := ((SecondWeightSum / 11) div 1);
        CheckFactorMultiply := CheckFactorDivisionInt * 11;
        SecondCheckNumber := SecondWeightSum - CheckFactorMultiply;
        exit(SecondCheckNumber);
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
        AgeDay, AgeMonth, AgeYear : Integer;
        BirthdayCurrentYear, BirthdayLastYear : Date;
    begin
        BirthdayCurrentYear := DMY2Date(Date2DMY("Birth Date", 1), Date2DMY("Birth Date", 2), Date2DMY(Today, 3));

        if BirthdayCurrentYear < Today then begin
            if Date2DMY("Birth Date", 1) < Date2DMY(Today, 1) then begin
                AgeDay := Date2DMY(Today, 1) - Date2DMY("Birth Date", 1);
                AgeMonth := Date2DMY(Today, 2) - Date2DMY("Birth Date", 2);
                AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3);
            end;
            if Date2DMY("Birth Date", 1) = Date2DMY(Today, 1) then begin
                AgeDay := 0;
                AgeMonth := Date2DMY(Today, 2) - Date2DMY("Birth Date", 2);
                AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3);
            end;
            if Date2DMY("Birth Date", 1) > Date2DMY(Today, 1) then begin
                if Date2DMY("Birth Date", 2) = 2 then begin
                    AgeDay := DaysInMonth(Date2DMY("Birth Date", 2), Date2DMY("Birth Date", 3)) + ((Date2DMY(Today, 1) - Date2DMY("Birth Date", 1) + 1));
                    AgeMonth := Date2DMY(Today, 2) - Date2DMY("Birth Date", 2) - 1;
                    AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3);
                end else begin
                    AgeDay := DaysInMonth(Date2DMY("Birth Date", 2), Date2DMY("Birth Date", 3)) + ((Date2DMY(Today, 1) - Date2DMY("Birth Date", 1)));
                    AgeMonth := Date2DMY(Today, 2) - Date2DMY("Birth Date", 2) - 1;
                    AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3);
                end;
            end;
        end;

        if BirthdayCurrentYear = Today then begin
            AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3);
            AgeMonth := Date2DMY(Today, 2) - Date2DMY("Birth Date", 2);
            AgeDay := Date2DMY(Today, 1) - Date2DMY("Birth Date", 1);
            Message('Happy Birthday!');
        end;

        if BirthdayCurrentYear > Today then begin
            if Date2DMY("Birth Date", 1) < Date2DMY(Today, 1) then begin
                AgeDay := Date2DMY(Today, 1) - Date2DMY("Birth Date", 1);
                AgeMonth := (12 - Date2DMY("Birth Date", 2)) + Date2DMY(Today, 2);
                AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3) - 1;
            end;
            if Date2DMY("Birth Date", 1) = Date2DMY(Today, 1) then begin
                AgeDay := 0;
                AgeMonth := (12 - Date2DMY("Birth Date", 2)) + Date2DMY(Today, 2);
                AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3) - 1;
            end;
            if Date2DMY("Birth Date", 1) > Date2DMY(Today, 1) then begin
                AgeDay := DaysInMonth(Date2DMY("Birth Date", 2), Date2DMY("Birth Date", 3)) + ((Date2DMY(Today, 1) - Date2DMY("Birth Date", 1)));
                AgeMonth := (11 - Date2DMY("Birth Date", 2)) + Date2DMY(Today, 2);
                AgeYear := Date2DMY(Today, 3) - Date2DMY("Birth Date", 3) - 1;
            end;
        end;

        Rec."TK Age" := Format(AgeYear) + ' years ' + Format(AgeMonth) + ' months ' + Format(AgeDay) + ' days.';
    end;

    local procedure DaysInMonth(Month: Integer; Year: Integer) DaysInMonth: Integer
    begin
        case Month of
            1:
                DaysInMonth := 31;
            2:
                if IsLeapYear(Year) then begin
                    DaysInMonth := 28;
                end
                else begin
                    DaysInMonth := 29;
                end;
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

}
