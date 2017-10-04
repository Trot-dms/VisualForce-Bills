/**
 * Created by Craftware on 2017-10-04.
 */

public with sharing class BillsMainPageController {

    public Contact LoggedUser { get; set; }
    public String ContactId { get; set; }

    public BillsMainPageController() {
        ContactId = ApexPages.currentPage().getParameters().get('contact');
        LoggedUser = [SELECT Id, Name, Email FROM Contact WHERE Id = :ContactId];
    }
}