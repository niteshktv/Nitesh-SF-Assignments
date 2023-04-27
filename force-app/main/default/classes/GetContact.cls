public with sharing class GetContact {
    @AuraEnabled
    public static Map<String, List<String>> getFormFields(Id recordId, String fieldSetName){

        Schema.SObjectType objectType = recordId.getSobjectType();
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();

        Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
        List<Schema.FieldSetMember> members = fieldSet.getFields();
        Map<String, List<String>> m = new Map<String, List<String>>();
        List<String> temp = new List<String>();


        for(Schema.FieldSetMember fsm : members){
            temp.add(''+ fsm.getSObjectField());
        }

        m.put('' + objectType, temp);
        
        return m;
    }
}