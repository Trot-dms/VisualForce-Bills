/**
 * Created by Craftware on 2017-10-04.
 */

public with sharing class BillsLoginController {

    public String Email { get; set; }
    public String Key { get; set; }
    public Boolean HasUserLogIn { get; set; }
    private Contact contact;

    public BillsLoginController() {
        HasUserLogIn = false;
        Email = null;
        Key = null;
    }

    public PageReference obtainKey() {
        contact = findUserInContacts(Email);
        if (contact == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No such user found or multiple users with this email.'));
            Email = null;
        }
        return null;
    }

    public PageReference loginWithKey() {
        if (Key.equals(Email)) {
            HasUserLogIn = true;
            PageReference nextPage = Page.BillsMainPage;
            nextPage.getParameters().put('contact', contact.Id);
            return nextPage.setRedirect(true);
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Wrong key.'));
        return null;
    }

    private Contact findUserInContacts(String email) {
        Contact[] contact = [SELECT Id, Email, Name FROM Contact WHERE Email = :email];
        if (contact.size() > 0) {
            if (contact.size() > 1) {
                return null;
            }
            return contact[0];
        }
        return null;
    }
}