tableextension 50103 "TK Jobs Setup" extends "Jobs Setup"
{
    fields
    {
        field(50105; "TK Job Def. Dim. Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
        }
        field(50106; "TK Bonus Level Def. Dim. Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Dimension;
        }
    }
}