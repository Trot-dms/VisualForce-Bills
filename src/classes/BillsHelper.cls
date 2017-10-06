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
}