codeunit 50100 "TK Helper Functions"
{
    trigger OnRun()
    begin

    end;

    procedure CreateDimensionIfMissing(JobRecord: Record Job) DimValue: Record "Dimension Value"
    var
        "Jobs Setup": Record "Jobs Setup";
    begin
        // muuda kirje või loo uus kui pole olemas

        // Get.() funktsiooniga saad kätte kogu objekti, antud juhul "Jobs Setup" tabeli väljad
        "Jobs Setup".Get();
        // Kontrollin, kas Dimensioon on projectile on loodud läbi enda loodud "TK Job Def. Dim. Code" välja
        if "Jobs Setup"."TK Job Def. Dim. Code" = '' then begin
            Error('Dimensiooni pole loodud');
        end;
        // teine võimalus kontrollida tühja välja:
        // "Jobs Setup".TestField("TK Job Def. Dim. Code");

        // Kontrollime, kas "Jobs Setup"."TK Job Def. Dim. Code" ja JobRecord."No." väljad on täidetud
        if DimValue.Get("Jobs Setup"."TK Job Def. Dim. Code", JobRecord."No.") then begin

            // Anname DimValue muutujale sama nime, mis on JobRecord.Description väljal max pikkusega, mis on määratud DimValue.Name väljale
            DimValue.Name := CopyStr(JobRecord.Description, 1, MaxStrLen(DimValue.Name));
            // Sisestame muudatused
            DimValue.Modify();

        end else begin
            // tühjendame DimValue objekti väljad ja anname uued väärtusd
            Clear(DimValue);
            DimValue."Dimension Code" := "Jobs Setup"."TK Job Def. Dim. Code";
            DimValue.Code := JobRecord."No.";
            DimValue.Name := CopyStr(JobRecord.Description, 1, MaxStrLen(DimValue.Name));
            DimValue.Insert();
        end;
    end;

    procedure InsertDimensionToDefDimTable(DimValue: Record "Dimension Value")
    var
        DefDim: Record "Default Dimension";
    begin
        // Kontrollin, kas DefDim objektis on kandeid
        if not DefDim.Get() then begin
            Clear(DefDim);
            // anname väärtuse otse Database'st, et vältida erroreid
            DefDim."Table ID" := Database::Job;
            DefDim."No." := DimValue.Code;
            DefDim."Dimension Code" := DimValue."Dimension Code";
            DefDim."Value Posting" := DefDim."Value Posting"::"Same Code";
            DefDim.Insert();
        end;
    end;

    procedure ApplyBonusLevelDimension(BonusLevel: Option "Bronze","Silver","Gold"; Var SalesHeader: Record "Sales Header")
    var
        DimVal: Record "Dimension Value";
        DimMGT: Codeunit DimensionManagement;
        tempDimSetEntry: Record "Dimension Set Entry" temporary;
        oldDimSetID: Integer;
        JobSetup: Record "Jobs Setup";
        newDimSetId: Integer;
    begin
        tempDimSetEntry.Reset();
        tempDimSetEntry.DeleteAll();
        oldDimSetID := SalesHeader."Dimension Set ID";
        DimMGT.GetDimensionSet(tempDimSetEntry, oldDimSetID);

        JobSetup.Get();
        if JobSetup."TK Bonus Level Def. Dim. Code" = '' then begin
            exit;
        end;

        if DimVal.get(JobSetup."TK Bonus Level Def. Dim. Code", format(BonusLevel)) then begin
            if tempDimSetEntry.Get(oldDimSetID, JobSetup."TK Bonus Level Def. Dim. Code") then
                if not (tempDimSetEntry."Dimension Value ID" = DimVal."Dimension Value ID") then
                    tempDimSetEntry.Delete()
                else
                    exit;
            tempDimSetEntry.Init();
            tempDimSetEntry."Dimension Set ID" := oldDimSetID;
            tempDimSetEntry."Dimension Code" := JobSetup."TK Bonus Level Def. Dim. Code";
            tempDimSetEntry."Dimension Value Code" := DimVal.Code;
            tempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
            tempDimSetEntry.Insert();

            newDimSetId := DimMGT.GetDimensionSetID(tempDimSetEntry);
            if newDimSetId <> oldDimSetID then begin
                SalesHeader."Dimension Set ID" := newDimSetId;
                SalesHeader.Modify()
            end;



        end;
    end;

}