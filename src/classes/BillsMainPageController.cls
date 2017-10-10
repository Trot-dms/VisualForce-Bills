/**
 * Created by Craftware on 2017-10-04.
 */

public with sharing class BillsMainPageController {

    public Contact LoggedUser { get; set; }
    public String ContactId { get; set; }
    public String Menu { get; set; }
    public String Key { get; set; }
    public Boolean IsError { get; set; }

    public BillsMainPageController() {
        IsError = false;
        getParams();
        LoggedUser = getLoggedUser();
        checkForLoginErrors();
    }

    public PageReference logoutUser() {
        try {
            LoggedUser.IsLoggedOn__c = false;
            LoggedUser.Key_Refresh_Time__c = null;
            update LoggedUser;
        } catch (DmlException e) {
            System.debug(e.getMessage());
        }
        PageReference loginPage = Page.BillsLogin;
        loginPage.getParameters().put('message', 'Logout completed.');
        return loginPage.setRedirect(true);
    }

    public PageReference setMenu() {
        PageReference menuPageReference = Page.BillsMainPage;
        return setParams(menuPageReference).setRedirect(true);
    }

    public void refreshKeyTime() {
        BillsHelper.refreshKeyTime(LoggedUser);
    }

    private PageReference setParams(PageReference pageReference) {
        try {
            pageReference.getParameters().put('contact', LoggedUser.Id);
            pageReference.getParameters().put('menu', Menu);
            pageReference.getParameters().put('key', Key);
        } catch (Exception e) {
            IsError = true;
        }
        return pageReference;
    }

    private void getParams() {
        ContactId = ApexPages.currentPage().getParameters().get('contact');
        Menu = ApexPages.currentPage().getParameters().get('menu');
        Key = ApexPages.currentPage().getParameters().get('key');
    }

    private Contact getLoggedUser() {
        if (!IsError) {
            List<Contact> contacts = [SELECT Id, Name, Email, Key__c, IsLoggedOn__c, Key_Refresh_Time__c FROM Contact WHERE Id = :ContactId];
            if (contacts.size() == 0) {
                return null;
            } else return contacts[0];
        }
        return null;
    }

    private void checkForLoginErrors() {
        IsError = false;
        if (ContactId != null) {
            if (ContactId.length() != 18) {
                IsError = true;
            }
        }
        if (LoggedUser == null) {
            IsError = true;
        }
        if (LoggedUser.Key__c == null) {
            System.debug('Key is null');
            IsError = true;
        } else if (LoggedUser.Key__c.length() != 5) {
            System.debug('Key is not 5 chars long');
            IsError = true;
        }
    }
}