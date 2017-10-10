/**
 * Created by Craftware on 2017-10-10.
 */

public with sharing class BillsKeyTimeoutSetup {

    public static void initialize() {
        if (!checkIfJobsRunning()) {
            System.debug('Running jobs.');
            try {
                System.schedule('Key timeout Job 1', '0 0 * * * ?', new ScheduleBillsKeyTimeout());
                System.schedule('Key timeout Job 2', '0 10 * * * ?', new ScheduleBillsKeyTimeout());
                System.schedule('Key timeout Job 3', '0 20 * * * ?', new ScheduleBillsKeyTimeout());
                System.schedule('Key timeout Job 4', '0 30 * * * ?', new ScheduleBillsKeyTimeout());
                System.schedule('Key timeout Job 5', '0 40 * * * ?', new ScheduleBillsKeyTimeout());
                System.schedule('Key timeout Job 6', '0 50 * * * ?', new ScheduleBillsKeyTimeout());
            } catch (AsyncException e) {
                System.debug('Cannot run - ' + e.getMessage());
            }
        } else {
            System.debug('Jobs are already running. No action needed.');
        }
    }

    @TestVisible
    private static Boolean checkIfJobsRunning() {
        List<CronTrigger> jobs = getJobs();

        Integer numberOfJobs = 0;
        for (CronTrigger cronTrigger : jobs) {
            if (Pattern.matches('Key timeout Job .', cronTrigger.CronJobDetail.Name)) {
                numberOfJobs++;
            }
        }
        if (numberOfJobs == 6) return true;
        return false;
    }

    @TestVisible
    private static List<CronTrigger> getJobs() {
        return [
                SELECT Id,
                        CronJobDetail.Name,
                        CronJobDetail.Id,
                        State
                FROM CronTrigger
        ];
    }
}