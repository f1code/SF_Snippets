

    public class SearchQuery {
        public String[] tags;
        public SearchQueryField[] fields;
        public String groupNameFilter;
    }
    public class SearchQueryField {
        public SearchQueryFieldDefinition field;
        public String value;
        public String operator;
        
        public String getWhere() {
            if(value == null || value == '')
                return null;
            return field.name + ' ' + selectOperator(field.type, operator) + ' ' + formatValue(field.type, operator, String.escapeSingleQuotes(value));
        }
        
        private String selectOperator(String fieldType, String operator) {
            if(fieldType == 'multipicklist') {
                if(operator == 'contains')
                    return 'includes';
                if(operator == 'does_not_contain')
                    return 'excludes';
            } else {
                if(operator == 'contains' || operator == 'starts_with' || operator == 'ends_with')
                    return 'like';
                if(operator == 'does_not_contain')
                    return 'not like';
            }
            return operator;            
        }
        
        private String formatValue(String fieldType, String operator, String value) {
            if(fieldType == 'multipicklist') {
                // note the value is already escaped
                return '(\'' + value + '\')';
            }
            if(fieldType == 'boolean') {
                return value == 'true' ? 'TRUE' : 'FALSE';
            }
            if((fieldType == 'date' || fieldType == 'datetime') && Pattern.matches('^[-:0-9T]+Z?$', value)) {
                return value;   // we format it in JS already, the regex is just there for validation
            }
            // don't know about that field type (or invalid date format)
            System.debug('default handling for ' + value + ' (' + fieldType + ')');
            return '\'' + value + '\'';
        }
    }
    // metadata about field being searched
    public class SearchQueryFieldDefinition {
        public String name;
        public String type;
    }



    // search on the add contacts page (for adding contacts to an existing group)
    public void searchContacts() {
        String groupId = g.Id;
        String baseQuery = 'SELECT Id, Name, Account.Name, Role__c, Email, (SELECT Group__r.Name FROM Group_Contact_Members__r) FROM Contact ';
        baseQuery += 'WHERE Id != null ';
        String orderBy = 'order by LastName, FirstName LIMIT 1000';
        String[] tags;
        if(queryJson != null && queryJson != '') {
            SearchQuery search = (SearchQuery)JSON.deserialize(queryJson, SearchQuery.class);
            for(SearchQueryField field: search.fields) {
                String w = field.getWhere();
                if(w != null)
                	baseQuery += 'and ' + w + ' ';
            }
            
            if (search.groupNameFilter != null && search.groupNameFilter != '') {
                this.groupNameFilter = '%' + search.groupNameFilter + '%';
                baseQuery += 'AND Id IN (SELECT Contact__c FROM Group_Contact_Member__c WHERE Group__r.Name LIKE :groupNameFilter) ';
            }
            
            if(search.tags != null && search.tags.size() > 0) {
                tags = search.tags;
                baseQuery += 'AND Id in (SELECT Contact__c from Tags__c where Tag__c in :tags) ';
            }
        }
        		
        System.Debug(baseQuery + orderBy);
        contacts = Database.query(baseQuery + orderBy);
        contactCount = contacts.size();
        
        contactsToSelect = new List<contactSelect>{};
        for (Contact c : contacts) {
            contactSelect cs = new contactSelect();
            cs.contact = c;
            cs.selected = false;
            contactsToSelect.add(cs);
            for (Group_Contact_Member__c gcm : c.Group_Contact_Members__r) {
                if (cs.groups == null)
                    cs.groups = gcm.Group__r.Name;
                else
                    cs.groups += ', ' + gcm.Group__r.Name;
            }
        }
        if (contactCount >= 1000) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'More than 1000 Contacts were found.  Please enter search criteria to limit the results.'));
        }
    }

