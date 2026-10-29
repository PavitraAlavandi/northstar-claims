Id holderId = [SELECT Id FROM Account WHERE IsPersonAccount = true LIMIT 1].Id;

Map<String, User> users = new Map<String, User>();
for (User u : [SELECT Id, Username FROM User WHERE Username LIKE '%@claimsconnect.northstar.dev']) {
    users.put(u.Username.substringBefore('@'), u);
}

// region, claim number, owner username prefix, amount
List<List<String>> specs = new List<List<String>>{
    new List<String>{'North', '3001', 'priya.nair', '1200.00'},
    new List<String>{'North', '3002', 'nora.fields', '8000.00'},
    new List<String>{'South', '3001', 'sam.torres', '2500.00'}
};

Set<String> extIds = new Set<String>();
for (List<String> s : specs) { extIds.add(s[0] + '-' + s[1]); }
Set<String> existing = new Set<String>();
for (Claim__c c : [SELECT External_Id__c FROM Claim__c WHERE External_Id__c IN :extIds]) {
    existing.add(c.External_Id__c);
}

List<Claim__c> claims = new List<Claim__c>();
for (List<String> s : specs) {
    String ext = s[0] + '-' + s[1];
    if (existing.contains(ext)) { continue; }
    User owner = users.get(s[2]);
    if (owner == null) { System.debug('RESULT: missing user ' + s[2]); continue; }
    claims.add(new Claim__c(
        Claim_Number__c = s[1],
        Region__c = s[0],
        External_Id__c = ext,
        Policyholder__c = holderId,
        OwnerId = owner.Id,
        Claim_Amount__c = Decimal.valueOf(s[3])
    ));
}
insert claims;
System.debug('RESULT: seeded ' + claims.size() + ' claims');