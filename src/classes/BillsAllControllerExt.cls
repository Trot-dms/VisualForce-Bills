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
}