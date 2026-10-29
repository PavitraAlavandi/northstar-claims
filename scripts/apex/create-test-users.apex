String DOMAIN = '@claimsconnect.northstar.dev';

Id adjusterPermSetId = [SELECT Id FROM PermissionSet WHERE Name = 'Claims_Adjuster' LIMIT 1].Id;

Map<String, Id> profileIds = new Map<String, Id>();
for (Profile p : [SELECT Id, Name FROM Profile WHERE Name IN ('Standard User', 'Standard Platform User')]) {
    profileIds.put(p.Name, p.Id);
}

Map<String, Id> roleIds = new Map<String, Id>();
for (UserRole r : [SELECT Id, DeveloperName FROM UserRole
                   WHERE DeveloperName IN ('Claims_Operations', 'North_Manager', 'North_Adjuster', 'South_Adjuster')]) {
    roleIds.put(r.DeveloperName, r.Id);
}

// firstName, lastName, alias (max 8 chars), username prefix, role, profile
List<List<String>> specs = new List<List<String>>{
    new List<String>{'Dan', 'Whitfield', 'dwhitfie', 'dan.whitfield', 'Claims_Operations', 'Standard User'},
    new List<String>{'Nora', 'Fields', 'nfields', 'nora.fields', 'North_Manager', 'Standard Platform User'},
    new List<String>{'Priya', 'Nair', 'pnair', 'priya.nair', 'North_Adjuster', 'Standard Platform User'},
    new List<String>{'Sam', 'Torres', 'storres', 'sam.torres', 'South_Adjuster', 'Standard Platform User'}
};

Set<String> wanted = new Set<String>();
for (List<String> s : specs) { wanted.add(s[3] + DOMAIN); }
Set<String> existing = new Set<String>();
for (User u : [SELECT Username FROM User WHERE Username IN :wanted]) { existing.add(u.Username); }

List<User> newUsers = new List<User>();
for (List<String> s : specs) {
    String uname = s[3] + DOMAIN;
    if (existing.contains(uname)) { continue; }
    newUsers.add(new User(
        FirstName = s[0], LastName = s[1], Alias = s[2],
        Username = uname, Email = uname,
        UserRoleId = roleIds.get(s[4]),
        ProfileId = profileIds.get(s[5]),
        TimeZoneSidKey = 'America/New_York',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8'
    ));
}
insert newUsers;

List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
for (User u : newUsers) {
    assignments.add(new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = adjusterPermSetId));
}
insert assignments;

System.debug('RESULT: created ' + newUsers.size() + ' users and ' + assignments.size() + ' assignments');