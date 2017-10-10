/**
 * Created by Craftware on 2017-10-10.
 */

global with sharing class ScheduleBillsKeyTimeout implements Schedulable {

    public void execute(SchedulableContext ct) {
        BillsKeyTimeout.runLogout();
    }
}