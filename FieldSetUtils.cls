/**
 * Utility methods dealing with fieldsets.
 */
public class FieldSetUtils {
    /**
     * Add all the member fields to the query.
     * If includeNames is true, also add the corresponding name fields for the reference fields.
     */
    public static String addFieldSetToQuery(String query, Schema.FieldSet fieldSet, Boolean includeNames) {
        for(Schema.FieldSetMember f: fieldSet.getFields()){
			if(!query.contains(', ' + f.getFieldPath()))
				query += ', ' + f.getFieldPath(); 
            if(includeNames && f.getType() == Schema.DisplayType.REFERENCE) {
                query += ', ' + getReferencedNameField(f);
            }
		}
        return query;
    }
    
    /**
     * Format the field's value for display.
     */
    public static String formatFieldValue(SObject parent, Schema.FieldSetMember field) {
        Object val = parent.get(field.getFieldPath());
        Schema.DisplayType fieldType = field.getType();
        if(val == null) {
            return '';
        }
        if(fieldType == Schema.DisplayType.DATE) {
            return formatDate((Date) val);
        } else if (fieldType == Schema.DisplayType.STRING || fieldType == Schema.DisplayType.PICKLIST) {
            return (String) val;
        } else if (fieldType == Schema.DisplayType.REFERENCE) {
            SObject ref = parent.getSObject(getReferencedRelationship(field));
            if(ref == null) {
                return '';
            }
            return (String)ref.get('Name');
        } else {
            throw new CronofyException('Not a handled field type: ' + fieldType);
        }
    }
    
    private static String formatDate(Date d) {
        return DateTime.newInstance(d, Time.newInstance(0, 0, 0, 0)).format('d/M/yyyy');
    }    
    
    /**
     * what is the path to the name in the referenced object, given a reference field?
     * eg OwnerId -> Owner.Name
     */
    private static String getReferencedNameField(Schema.FieldSetMember f) {        
        return getReferencedRelationship(f) + '.Name';        
    }
    
    /**
     *  what is the field that will point to the relationship object, given a reference field?
     * eg OwnerId -> Owner
     */
    private static String getReferencedRelationship(Schema.FieldSetMember f) {
        return f.getFieldPath()
            	.replaceFirst('__c$', '__r')
            	.replaceFirst('Id$', '');
    }
}
