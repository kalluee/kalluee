pageextension 50190 "Customer List" extends "Customer List"
{
    trigger OnOpenPage();
    begin
        Report.run(Report::LAB_CustomerList);
    end;
}