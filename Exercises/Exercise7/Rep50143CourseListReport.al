report 50143 CourseListReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Course Card Report';
    DefaultLayout = RDLC;
    RDLCLayout = './CourseCardReport.rdl';
    // WordLayout = './CourseCardReport.docx';

    dataset
    {
        dataitem(Course; "TK Course")
        {

            RequestFilterFields = "Course Code";
            column(CourseCode_Course; "Course Code")
            {
                IncludeCaption = true;
            }
            column(Name_Course; Name)
            {
                IncludeCaption = true;
            }
            column(Description_Course; Description)
            {
                IncludeCaption = true;
            }
            column(Location_Course; Location)
            {
                IncludeCaption = true;
            }
            column(Locationdetails_Course; "Location details")
            {
                IncludeCaption = true;
            }
            column(Startingdate_Course; "Starting date")
            {
                IncludeCaption = true;
            }
            column(Enddate_Course; "End date")
            {
                IncludeCaption = true;
            }
            column(Price_Course; Price)
            {
                IncludeCaption = true;
            }
            column(MaxNoofParticipants_Course; "Max No. of Participants")
            {
                IncludeCaption = true;
            }
            column(RegisteredParticipants_Course; "Registered Participants")
            {
                IncludeCaption = true;
            }
            column(AvailableSlots_Course; "Available Slots")
            {
                IncludeCaption = true;
            }
            column(HeaderTxt; HeaderTxt) { }
            dataitem("TK Course Participants"; "TK Course Participants")
            {
                DataItemLinkReference = Course;
                DataItemLink = "Course Code" = field("Course Code");

                column(Participant_Code; "Participant Code")
                {
                    IncludeCaption = true;
                }
                column(First_Name; "First Name")
                {
                    IncludeCaption = true;
                }
                column(Last_Name; "Last Name")
                {
                    IncludeCaption = true;
                }
            }
        }
    }


    var
        HeaderTxt: Label 'Course Card Report';
}