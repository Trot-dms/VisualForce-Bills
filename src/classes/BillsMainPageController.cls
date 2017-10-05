/**
 * Created by Craftware on 2017-10-04.
 */

public with sharing class BillsMainPageController {

    public Contact LoggedUser { get; set; }
    public String ContactId { get; set; }
    public String Menu { get; set; }
    public Boolean IsError { get; set; }

    public BillsMainPageController() {
        IsError = false;
        getParams();
        checkForLoginErrors();
        LoggedUser = getLoggedUser();
    }

    public PageReference logoutUser() {
        PageReference loginPage = Page.BillsLogin;
        loginPage.getParameters().put('message', 'Logout completed.');
        return loginPage.setRedirect(true);
    }

    public PageReference setMenu() {
        PageReference menuPageReference = Page.BillsMainPage;
        menuPageReference.getParameters().put('contact', LoggedUser.Id);
        menuPageReference.getParameters().put('menu', Menu);
        return menuPageReference.setRedirect(true);
    }

    private void getParams() {
        ContactId = ApexPages.currentPage().getParameters().get('contact');
        Menu = ApexPages.currentPage().getParameters().get('menu');
    }

    private Contact getLoggedUser() {
        List<Contact> contacts = [SELECT Id, Name, Email FROM Contact WHERE Id = :ContactId];
        if (contacts.size() == 0) {
            return null;
        } else return contacts[0];
    }

    private void checkForLoginErrors() {
        if (ContactId.length() != 18) {
            if (LoggedUser == null) {
                IsError = true;
            }
        }
    }
}