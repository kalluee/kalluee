report 50144 "Course List Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Course List Report';
    DefaultLayout = RDLC;
    RDLCLayout = './CourseListReport.rdl';
    // WordLayout = './CourseListReport.docx';

    dataset
    {
        dataitem(Course; "TK Course")
        {
            RequestFilterFields = "Course Code";
            RequestFilterHeading = '';
            PrintOnlyIfDetail = true;
            DataItemTableView = sorting("Starting date");

            column(CourseCode_Course; "Course Code")
            {
            }
            column(Name_Course; Name)
            {
            }
            column(Description_Course; Description)
            {
            }
            column(Location_Course; Location)
            {
            }
            column(Locationdetails_Course; "Location details")
            {
            }
            column(Startingdate_Course; "Starting date")
            {
            }
            column(Enddate_Course; "End date")
            {
            }
            column(Price_Course; Price)
            {
            }
            column(MaxNoofParticipants_Course; "Max No. of Participants")
            {
            }
            column(RegisteredParticipants_Course; "Registered Participants")
            {
            }
            column(AvailableSlots_Course; "Available Slots")
            {
            }
            column(HeaderTxt; HeaderTxt) { }
            column(FromDate; FromDate) { }
            column(ToDate; ToDate) { }

            dataitem("TK Course Participants"; "TK Course Participants")
            {
                DataItemLinkReference = Course;
                DataItemLink = "Course Code" = field("Course Code");

                column(ParticipantCode_TKCourseParticipants; "Participant Code")
                {
                }
                column(FirstName_TKCourseParticipants; "First Name")
                {
                }
                column(LastName_TKCourseParticipants; "Last Name")
                {
                }
            }
            trigger OnAfterGetRecord();
            begin
                SetRange("Starting date", FromDate, ToDate);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Filter: Time")
                {
                    field("From Date"; FromDate)
                    {
                        ApplicationArea = All;
                    }
                    field("To Date"; ToDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    var
        HeaderTxt: Label 'Course List Report';
        FromDate: Date;
        ToDate: Date;
}