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

    /**
     * Return list of all bills
     *
     * @return List of Bills objects
     */
    public static List<Bill__c> getAllBills() {
        return runGenericQuery(null, null);
    }

    /**
     * Returns all bills for selected day.
     *
     * @param day (String) correct format if dd/MM/yyyy
     *
     * @return List of Bills objects
     */
    public static List<Bill__c> getBillsByDay(String day) {
        List<Bill__c> bills = new List<Bill__c>();
        bills = runGenericQuery('Pay_Date__c', String.valueOf(formatDate(day)));
        return bills;
    }

    /**
     * Returns one bill object that match Id
     *
     * @param id (String) id of object
     *
     * @return Bill object
     */
    public static Bill__c getBillById(String id) {
        return runGenericQuery('Id', id)[0];
    }

    /**
     * Performs a generic query on Bill object.
     *
     * @param field (String) field name from Bill object ex. Name, Id.
     * @param value (String) value to include in WHERE clause
     *
     * @return List of Bill objects
     */
    public static List<Bill__c> runGenericQuery(String field, String value) {
        String q = 'SELECT Bill_Owner__c, Id, Loan_Holder__c, Loan_Holder__r.Name, Name, OwnerId, Pay_Date__c, Payed_Date__c, Price__c, Status__c, Title__c, Type__c FROM Bill__c';
        if (!String.isEmpty(field)) {
            if (field.equals('Pay_Date__c')) {
                Date d = Date.valueOf(value);
                q = q + ' WHERE ' + field + ' = :d';
            } else {
                q = q + ' WHERE ' + field + ' = :value';
            }
        }
        List<SObject> results = Database.query(q);
        return results;
    }

    /**
     * Formats input String to return Date
     *
     * @param unformatedDate (String) date in format dd/MM/yyyy
     *
     * @return (Date) from input String
     */
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