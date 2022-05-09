report 50101 "Report for Multiple Tables"
{
    //Make the report searchable from Tell me under the Administration category.
    UsageCategory = Administration;
    ApplicationArea = All;
    // Use an RDL layout.
    DefaultLayout = RDLC;
    // Specify the name of the file that the report will use for the layout.
    RDLCLayout = 'MyRDLReport.rdl';

    dataset
    {

        dataitem(Customer; Customer)
        {
            // Sort the table view based on the "No." field.
            DataItemTableView = Sorting("No.");
            // Include the "No." field on the filter tab of the request page.
            RequestFilterFields = "No.";
            // Print data only if at least one of the CustLedgerEntry and SalesHeader data items generates output.
            PrintOnlyIfDetail = True;

            // For each field that you want to display you add a column control.
            column(No_Customer; "No.")
            {
                // Include the caption of the "No." field in the dataset of the report.
                IncludeCaption = true;
            }

            column(Name_Customer; Name)
            {
                IncludeCaption = true;

            }

            column(Phone_Customer; "Phone No.")
            {
                IncludeCaption = true;

            }

            column(Address_Customer; Address)
            {
                IncludeCaption = true;

            }

            column(EMail_Customer; "E-Mail")
            {
                IncludeCaption = true;

            }
            dataitem(CustLedger; "Cust. Ledger Entry")
            {

                DataItemTableView = sorting("Entry no.");
                // Set a filter on the child data item, **CustLedgerEntry** to select only the records where the 
                // value of `Customer."No."` field and the `"Customer Ledger Entry"."Customer No."` field matches.
                DataItemLink = "Customer No." = field("No.");

                column(EntryNo_CustLedgerEntry; "Entry No.")
                {
                    IncludeCaption = true;

                }
                column(CustomerNo_CustLedgerEntry; "Customer No.")
                {
                    IncludeCaption = true;

                }
                column(PostingDate_CustLedgerEntry; "Posting Date")
                {
                    IncludeCaption = true;

                }
                column(DocumentType_CustLedgerEntry; "Document Type")
                {
                    IncludeCaption = true;

                }

                column(DocumentNo_CustLedgerEntry; "Document No.")
                {
                    IncludeCaption = true;

                }

                column(Description_CustLedgerEntry; Description)
                {
                    IncludeCaption = true;

                }

                column(CurrencyCode_CustLedgerEntry; "Currency Code")
                {
                    IncludeCaption = true;

                }

                column(Amount_CustLedgerEntry; Amount)
                {
                    IncludeCaption = true;

                }

                column(OriginalAmtLCY_CustLedgerEntry; "Original Amt. (LCY)")
                {
                    IncludeCaption = true;

                }

                column(RemainingAmtLCY_CustLedgEntry; "Remaining Amt. (LCY)")
                {
                    IncludeCaption = true;

                }


                dataitem(DetCustLedger; "Detailed Cust. Ledg. Entry")
                {

                    DataItemTableView = sorting("entry no.");
                    DataItemLink = "Cust. Ledger Entry No." = field("Entry No."), "Customer No." = field("Customer No.");

                    column(EntryNo_DetailedCustLedgEntry; "Entry No.")
                    {
                        IncludeCaption = true;

                    }

                    column(EntryType_DetailedCustLedgEntry; "Entry Type")
                    {
                        IncludeCaption = true;

                    }

                    column(PostingDate_DetailedCustLedgEntry; "Posting Date")
                    {
                        IncludeCaption = true;

                    }

                    column(DocumentType_DetailedCustLedgEntry; "Document Type")
                    {
                        IncludeCaption = true;

                    }

                    column(DocumentNo_DetailedCustLedgEntry; "Document No.")
                    {
                        IncludeCaption = true;

                    }

                    column(AmountLCY_DetailedCustLedgEntry; "Amount (LCY)")
                    {
                        IncludeCaption = true;

                    }

                    column(TransactionNo_DetailedCustLedgEntry; "Transaction No.")
                    {
                        IncludeCaption = true;

                    }

                    column(JournalBatchName_DetailedCustLedgEntry; "Journal Batch Name")
                    {
                        IncludeCaption = true;

                    }

                    column(DebitAmountLCY_DetailedCustLedgEntry; "Debit Amount (LCY)")
                    {
                        IncludeCaption = true;

                    }

                    column(CreditAmountLCY_DetailedCustLedgEntry; "Credit Amount (LCY)")
                    {
                        IncludeCaption = true;

                    }

                }
            }

            dataitem(SalesHeader; "Sales Header")
            {
                DataItemTableView = sorting("Document Type", "No.");
                DataItemLink = "Sell-to Customer No." = field("No.");

                column(DocumentType_SalesHeader; "Document Type")
                {
                    IncludeCaption = true;

                }

                column(No_SalesHeader; "No.")
                {
                    IncludeCaption = true;

                }

                column(PostingDate_SalesHeader; "Posting Date")
                {
                    IncludeCaption = true;

                }

                column(PricesIncludingVAT_SalesHeader; "Prices Including VAT")
                {
                    IncludeCaption = true;

                }

                column(Amount_SalesHeader; Amount)
                {
                    IncludeCaption = true;

                }
            }

        }
    }

    // These labels will be used later as captions in the report layout.  
    labels
    {
        Sales_Document_Caption = 'Sales Documents';
        Total_Caption = 'Total';
    }
}