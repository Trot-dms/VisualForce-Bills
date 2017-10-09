/**
 * Created by Craftware on 2017-10-09.
 */

public with sharing class BillsAllControllerExt {

    public String DateSelected { get; set; }
    public String IdBillSelected { get; set; }
    public List<Bill__c> Bills { get; set; }
    public List<Bill__c> AllBills { get; set; }

    public BillsAllControllerExt() {
        AllBills = BillsHelper.getAllBills();
        Bills = AllBills;
    }

    public PageReference showAll() {
        AllBills = BillsHelper.getAllBills();
        Bills = AllBills;
        return null;
    }

    public PageReference showByDay() {
        Bills = BillsHelper.getBillsByDay(DateSelected);
        return null;
    }

}