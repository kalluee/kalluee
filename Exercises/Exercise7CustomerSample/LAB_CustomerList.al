report 50191 LAB_CustomerList
{
    Caption = 'LAB_CustomerList';
    RDLCLayout = 'layouts/LAB_CustomerList.rdl';
    WordLayout = 'layouts/LAB_CustomerList.docx';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    AdditionalSearchTerms = 'Customer and Ledger Report';

    PreviewMode = Normal;
    WordMergeDataItem = Customer;
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            column(No_; "No.")
            {
            }
            column(Name; Name)
            {
            }
            dataitem(CustomerLedgers; "Cust. Ledger Entry")
            {
                DataItemLinkReference = Customer;
                DataItemLink = "Customer No." = field("No.");
                DataItemTableView = sorting("Customer No.");
                column(CustomerLedgersCustomerNo; "Customer No.")
                {
                }
                column(CustomerLedgersAmountLCY; "Amount (LCY)")
                {
                }
            }
        }
    }











}

