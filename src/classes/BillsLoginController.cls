/**
 * Created by Craftware on 2017-10-04.
 */

public with sharing class BillsLoginController {

    public String Email { get; set; }
    public String Key { get; set; }
    public Boolean HasUserLogIn { get; set; }
    public String Message { get; set; }
    private Contact contact;

    public BillsLoginController() {
        HasUserLogIn = false;
        Email = null;
        Key = null;
        Message = null;
        Message = ApexPages.currentPage().getParameters().get('message');
        if (Message != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Message));
        }
    }

    public PageReference obtainKey() {
        contact = BillsHelper.findContactByEmail(Email);
        if (contact == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No such user found or multiple users with this email.'));
            Email = null;
        }
        try {
            Key = BillsHelper.generateKey();
            contact.Key__c = Key;
            update contact;
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Got error generating your key.'));
        }
        return null;
    }

    public PageReference loginWithKey() {
        if (contact.IsLoggedOn__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'User is already logged on.'));
            return null;
        }
        if (Key.equals(contact.Key__c)) {
            HasUserLogIn = true;
            try {
                contact.IsLoggedOn__c = true;
                update contact;
            } catch (DmlException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'DB error.'));
            }
            PageReference nextPage = Page.BillsMainPage;
            nextPage.getParameters().put('contact', contact.Id);
            nextPage.getParameters().put('menu', 'home');
            nextPage.getParameters().put('key', Key);
            return nextPage.setRedirect(true);
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Wrong key.'));
        return null;
    }

    //TODO only for testing, remove when scheduled apex will set flag to false after 5 min of inactivity.
    public PageReference forceLogOut() {
        PageReference firstPage = Page.BillsLogin;
        if (contact.IsLoggedOn__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'User logged out by force.'));
            try {
                contact.IsLoggedOn__c = false;
                update contact;
            } catch (DmlException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            }
        }
        return firstPage.setRedirect(true);
    }
}