/**
 * Created by Craftware on 2017-10-10.
 */

public with sharing class BillsKeyTimeout {

    public static Boolean checkIf5MinOld(Time t1, Time t2, Integer min) {
        if (Math.abs(t1.minute() - t2.minute()) > min) {
            return true;
        }
        return false;
    }

    public static void runLogout() {
        List<Contact> loggedUsers = new List<Contact>();
        List<Contact> usersToLogout = new List<Contact>();
        loggedUsers = [SELECT Id, Name, Key_Refresh_Time__c, Email, IsLoggedOn__c FROM Contact WHERE IsLoggedOn__c = true];
        if (loggedUsers.size() > 0) {
            Datetime dt = Datetime.now();
            for (Contact contact : loggedUsers) {
                if (checkIf5MinOld(dt.time(), contact.Key_Refresh_Time__c.time(), 5)) {
                    contact.Key_Refresh_Time__c = null;
                    contact.IsLoggedOn__c = false;
                    usersToLogout.add(contact);
                }
            }
        }
        logoutUsers(usersToLogout);
    }

    private static void logoutUsers(List<Contact> contacts) {
        if (contacts.size() > 0) {
            update contacts;
            System.debug('Logged out ' + contacts.size() + ' users.');
        }
    }
}