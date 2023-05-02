public with sharing class GetContact {
    @AuraEnabled
    public static Map<String, List<String>> getContactFields(Id recordId, String fieldSetName){

        Schema.SObjectType objectType = recordId.getSobjectType();
        Schema.DescribeSObjectResult objectDescribe = objectType.getDescribe();
        Map<String, Schema.FieldSet> fieldSetMap = objectDescribe.fieldSets.getMap();

        Schema.FieldSet fieldSet = fieldSetMap.get(fieldSetName);
        List<Schema.FieldSetMember> members = fieldSet.getFields();
        Map<String, List<String>> objectTypeToFieldsMap = new Map<String, List<String>>();
        List<String> sObjectFieldsList = new List<String>();


        for(Schema.FieldSetMember fsm : members){
            sObjectFieldsList.add(''+fsm.getSObjectField());
        }

        objectTypeToFieldsMap.put('' + objectType, sObjectFieldsList);
        
        return objectTypeToFieldsMap;
    }
}