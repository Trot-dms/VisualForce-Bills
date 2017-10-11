/**
 * Created by Craftware on 2017-10-09.
 */

public with sharing class BillsAllControllerExt {

    public Bill__c BillSelected { get; set; }
    public String DateSelected { get; set; }
    public String IdBillSelected { get; set; }
    public List<Bill__c> Bills { get; set; }
    public List<Bill__c> AllBills { get; set; }
    public Contact LoggedUser { get; set; }
    public Id LoggedUserId { get; set; }

    //Form fields
    public String selectedStatus { get; set; }
    public String selectedType { get; set; }
    public String selectedLoanHolder { get; set; }
    public String price { get; set; }
    public String payDate { get; set; }
    public String payedDate { get; set; }
    public String title { get; set; }
    public String billId { get; set; }

    public BillsAllControllerExt() {
        AllBills = BillsHelper.getAllBills();
        Bills = AllBills;
        LoggedUserId = ApexPages.currentPage().getParameters().get('contact');
        if (LoggedUserId != null) {
            LoggedUser = BillsHelper.findContactById(LoggedUserId);
        }
    }

    public PageReference showAll() {
        AllBills = BillsHelper.getAllBills();
        Bills = AllBills;
        refreshKeyTime();
        return null;
    }

    public PageReference showByDay() {
        Bills = BillsHelper.getBillsByDay(DateSelected);
        refreshKeyTime();
        return null;
    }

    public void getBill() {
        IdBillSelected = ApexPages.currentPage().getParameters().get('billId');
        BillSelected = BillsHelper.getBillById(IdBillSelected);
        refreshKeyTime();
    }

    public void refreshKeyTime() {
        BillsHelper.refreshKeyTime(LoggedUser);
    }

    public List<SelectOption> getStatuses() {
        Bill__c bill = new Bill__c();
        return BillsHelper.getFromPickList(bill, 'Status__c');
    }

    public List<SelectOption> getTypes() {
        Bill__c bill = new Bill__c();
        return BillsHelper.getFromPickList(bill, 'Type__c');
    }

    public List<SelectOption> getLoanHolders() {
        List<SelectOption> options = new List<SelectOption>();
        List<Account> loanHolders = new List<Account>();
        loanHolders = [SELECT Id, Name FROM Account];
        if (loanHolders.size() > 0) {
            for (Account account : loanHolders) {
                options.add(new SelectOption(account.Name, account.Name));
            }
        }
        return options;
    }

    public PageReference getFormData() {
        System.debug('### Title :' + title);
        System.debug('### Loan :' + selectedLoanHolder);
        System.debug('### Status :' + selectedStatus);
        System.debug('### Type :' + selectedType);
        System.debug('### Pay :' + payDate);
        System.debug('### Payed :' + payedDate);
        System.debug('### Price :' + price);
        System.debug('### ID :' + billId);
        Bill__c bill = [
                SELECT
                        Bill_Owner__c,
                        Id,
                        Loan_Holder__c,
                        Name,
                        OwnerId,
                        Pay_Date__c,
                        Payed_Date__c,
                        Price__c,
                        Status__c,
                        Title__c,
                        Type__c
                FROM Bill__c
                WHERE Id = :billId
                LIMIT 1
        ];
        Account account = [SELECT Id, Name FROM Account WHERE Name = :selectedLoanHolder];
        try {
            bill.Name = title;
            bill.Loan_Holder__c = account.Id;
            bill.Status__c = selectedStatus;
            bill.Type__c = selectedType;
            update bill;
        } catch (DmlException e) {
            System.debug(e.getMessage());
        }
        PageReference pageReference = Page.BillsMainPage;
        pageReference.getParameters().put('contact', LoggedUser.Id);
        pageReference.getParameters().put('menu', 'all');
        return pageReference.setRedirect(true);
    }
}