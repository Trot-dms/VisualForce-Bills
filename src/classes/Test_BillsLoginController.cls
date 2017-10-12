/**
 * Created by Craftware on 2017-10-11.
 */

@IsTest
private class Test_BillsLoginController {

    @IsTest
    static void test_ObtainKey() {
        BillsLoginController controller = setup();
        System.assert(controller != null);

        Contact contact = getContact();
        System.assert(contact != null);

        controller.Email = contact.Email;
        controller.obtainKey();
        System.assert(controller.Key != null);
    }

    @IsTest
    static void test_LoginWithKey() {
        BillsLoginController controller = setup();
        System.assert(controller != null);

        Contact contact = getContact();
        System.assert(contact != null);

        controller.Email = contact.Email;

    }

    static BillsLoginController setup() {
        PageReference pageReference = Page.BillsLogin;
        Test.setCurrentPageReference(pageReference);
        BillsLoginController controller = new BillsLoginController();
        return controller;
    }

    static Contact getContact() {
        return [SELECT Id, Name, Email, Key_Refresh_Time__c, Key__c, IsLoggedOn__c FROM Contact WHERE Email = 'trot.dms@gmail.com' LIMIT 1];
    }

    @TestSetup
    static void setupTests() {
        //Create dummy contact
        Contact contact = new Contact();
        contact.Email = 'trot.dms@gmail.com';
        contact.FirstName = 'Kamil';
        contact.LastName = 'Golis';
        insert contact;
    }
}