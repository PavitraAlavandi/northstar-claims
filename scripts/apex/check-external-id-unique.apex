Account holder = [SELECT Id FROM Account WHERE IsPersonAccount = true LIMIT 1];
Claim__c dup = new Claim__c(
    Claim_Number__c = '1001',
    Region__c = 'North',
    Policyholder__c = holder.Id,
    External_Id__c = 'North-1001'
);
try {
    insert dup;
    System.debug('RESULT: SAVED - duplicate was NOT blocked');
} catch (DmlException e) {
    System.debug('RESULT: BLOCKED - ' + e.getDmlStatusCode(0) + ' - ' + e.getDmlMessage(0));
}