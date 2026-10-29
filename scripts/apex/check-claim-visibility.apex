// Who SHOULD be able to read each claim (by username prefix)
Map<String, Set<String>> expected = new Map<String, Set<String>>{
    'North-3001' => new Set<String>{'dan.whitfield', 'nora.fields', 'priya.nair'},
    'North-3002' => new Set<String>{'dan.whitfield', 'nora.fields'},
    'South-3001' => new Set<String>{'dan.whitfield', 'sam.torres'}
};

Set<String> keys = expected.keySet();
Map<Id, Claim__c> claimsById = new Map<Id, Claim__c>(
    [SELECT Id, External_Id__c FROM Claim__c WHERE External_Id__c IN :keys]
);
Set<Id> claimIds = claimsById.keySet();
List<User> testUsers = [SELECT Id, Name, Username FROM User
                        WHERE Username LIKE '%@claimsconnect.northstar.dev' ORDER BY Name];

Integer checks = 0;
Integer failures = 0;
for (User u : testUsers) {
    String prefix = u.Username.substringBefore('@');
    Map<Id, Boolean> canRead = new Map<Id, Boolean>();
    for (UserRecordAccess a : [SELECT RecordId, HasReadAccess FROM UserRecordAccess
                               WHERE UserId = :u.Id AND RecordId IN :claimIds]) {
        canRead.put(a.RecordId, a.HasReadAccess);
    }
    for (Claim__c c : claimsById.values()) {
        Boolean actual = canRead.get(c.Id) == true;
        Boolean should = expected.get(c.External_Id__c).contains(prefix);
        checks++;
        if (actual != should) { failures++; }
        System.debug('ACCESS|' + (actual == should ? 'PASS' : 'FAIL') + '|' + u.Name + '|'
            + c.External_Id__c + '|canRead=' + actual + '|expected=' + should);
    }
}
System.debug('RESULT: ' + checks + ' checks, ' + failures + ' failures');