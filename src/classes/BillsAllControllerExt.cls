/**
 * Created by Craftware on 2017-10-09.
 */

public with sharing class BillsAllControllerExt {

    public Bill__c BillSelected { get; set; }
    public Bill__c NewBill { get; set; }
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
        NewBill = new Bill__c();
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
        Account account = BillsHelper.getAccountByName(selectedLoanHolder);
        Bill__c bill;
        try {
            if (billId == null || billId.equals('')) {
                bill = new Bill__c();
                bill.Name = title;
                bill.Bill_Owner__c = LoggedUser.Id;
                bill.Loan_Holder__c = account.Id;
                bill.Status__c = selectedStatus;
                bill.Type__c = selectedType;
                bill.Pay_Date__c = BillsHelper.formatDate(payDate);
                bill.Payed_Date__c = BillsHelper.formatDate(payedDate);
                bill.Price__c = BillsHelper.getCurrencyFromString(price);
                insert bill;
            } else {
                bill = BillsHelper.getBillById(billId);
                bill.Name = title;
                bill.Loan_Holder__c = account.Id;
                bill.Status__c = selectedStatus;
                bill.Type__c = selectedType;
                bill.Pay_Date__c = BillsHelper.formatDate(payDate);
                bill.Payed_Date__c = BillsHelper.formatDate(payedDate);
                bill.Price__c = BillsHelper.getCurrencyFromString(price);
                update bill;
            }
        } catch (DmlException e) {
            System.debug(e.getMessage());
        }
        return reloadPage().setRedirect(true);
    }

    private PageReference reloadPage() {
        PageReference pageReference = Page.BillsMainPage;
        pageReference.getParameters().put('contact', LoggedUser.Id);
        pageReference.getParameters().put('menu', 'all');
        return pageReference;
    }
}