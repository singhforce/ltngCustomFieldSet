public class CustomFieldSet {
    // Fetches the field set for the given sObject and the field set name
	private static List<FieldSetWrapper> getFieldSet(String sObj, String fSetName){
    	Schema.FieldSet sObjFset = Schema.getGlobalDescribe().get(sObj).getDescribe().fieldSets.getMap().get(fSetName);
    	
        List<Schema.FieldSetMember> fieldSet = sObjFset.getFields();
        List<FieldSetWrapper> fMaplist = new List<FieldSetWrapper>();
        for (Schema.FieldSetMember fmem: fieldSet) {            
            fMaplist.add(new FieldSetWrapper(fmem.getLabel(), fmem.getFieldPath(), fmem));
        }
		return fMaplist;        
    }
    
    // fetches the sObjRecords for the passed sObject and the Field Set Name
    @AuraEnabled
    public static Map<String, List<FieldSetWrapper>> getsObjRecords(String sObj, String fSetName){
    	List<FieldSetWrapper> fSetlist = getFieldSet(sObj, fSetName);
        String fAPIname = '';
        for(FieldSetWrapper fName : fSetlist){
            fAPIname += fName.fAPIName + ',';
        }
        fAPIname += ' Id ';
        String soqlQuery = 'Select ' + fAPIname + ' from ' + sObj + ' Limit 10';
        List<sObject> sObjRecs = Database.query(soqlQuery);
        
        List<FieldSetWrapper> fSetWrapperlist = new List<FieldSetWrapper>();
        for(sObject sObjRec : sObjRecs){
            fSetWrapperlist.add(new FieldSetWrapper(sObjRec));
        }
        Map<String, List<FieldSetWrapper>> fSetWrapperMap = new Map<String, List<FieldSetWrapper>>();
        fSetWrapperMap.put('sObjlist', fSetWrapperlist);
        fSetWrapperMap.put('fieldSetlist', fSetlist);
        
        return fSetWrapperMap;        
    }
    
    /*
     * Wrapper Class to hold
     * Field Labels, their APIName, FieldSetMember and
     * sObject Record
     */
    public class FieldSetWrapper {
        @AuraEnabled public String fLabel;
        @AuraEnabled public String fAPIName;    
        @AuraEnabled public String fSetMember;
        @AuraEnabled public sObject sObjRecord;
        
        public FieldSetWrapper(String fieldlabel, String fieldAPIName, FieldSetMember fSetMem){
            fLabel = fieldlabel;
            fAPIName = fieldAPIName;
            fSetMember = JSON.serialize(fSetMem);
        }
        public FieldSetWrapper(sObject sObjRec){
            sObjRecord = sObjRec;
        }
    }
}