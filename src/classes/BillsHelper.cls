/**
 * Created by Craftware on 2017-10-06.
 */

public with sharing class BillsHelper {

    /**
     * Generates GUID string key (len=5).
     *
     * @return
     */
    public static String generateKey() {
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0, 5);
        return guid;
    }

    /**
     * Find contact by email or return null.
     *
     * @param email (String)
     *
     * @return Contact or null
     */
    public static Contact findContactByEmail(String email) {
        Contact[] contact = [SELECT Id, Email, Name, Key__c, IsLoggedOn__c FROM Contact WHERE Email = :email];
        if (contact.size() > 0) {
            if (contact.size() > 1) {
                return null;
            }
            return contact[0];
        }
        return null;
    }

    public static List<Bill__c> getAllBills() {
        return [
                SELECT
                        Bill_Owner__c,
                        Id,
                        Loan_Holder__c,
                        Loan_Holder__r.Name,
                        Name,
                        OwnerId,
                        Pay_Date__c,
                        Payed_Date__c,
                        Price__c,
                        Status__c,
                        Title__c,
                        Type__c
                FROM Bill__c
        ];
    }

    public static List<Bill__c> getBillsByDay(String day) {
        List<Bill__c> bills = new List<Bill__c>();
        bills = [
                SELECT
                        Bill_Owner__c,
                        Id,
                        Loan_Holder__c,
                        Loan_Holder__r.Name,
                        Name,
                        OwnerId,
                        Pay_Date__c,
                        Payed_Date__c,
                        Price__c,
                        Status__c,
                        Title__c,
                        Type__c
                FROM Bill__c
                WHERE Pay_Date__c = :formatDate(day)
        ];
        return bills;
    }

    public static Bill__c getBillById(String id) {
        return [
                SELECT
                        Bill_Owner__c,
                        Id,
                        Loan_Holder__c,
                        Loan_Holder__r.Name,
                        Name,
                        OwnerId,
                        Pay_Date__c,
                        Payed_Date__c,
                        Price__c,
                        Status__c,
                        Title__c,
                        Type__c
                FROM Bill__c
                WHERE Id = :id
        ];
    }

    public static Date formatDate(String unformatedDate) {
        String[] d = unformatedDate.split('/');
        Date newDate = Date.today();
        if (d.size() <> 3) {
            return newDate;
        }
        try {
            newDate = Date.newInstance(Integer.valueOf(d[2]), Integer.valueOf(d[1]), Integer.valueOf(d[0]));
        } catch (TypeException e) {
            System.debug('Error parsing date from view : ' + unformatedDate);
        }
        return newDate;
    }
}