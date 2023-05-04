public with sharing class GetContact {
    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getContactFields(Id varContactId, String fieldSetName){

        Schema.SObjectType objectType = varContactId.getSobjectType();
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

    @AuraEnabled(cacheable=true)
    public static Id getContactAssociateContact(String designationId){
        try {
            Id contactId;
            List<Designation__c> designationList = [SELECT Id, Name, Contact__r.Id FROM Designation__c WHERE Id= :designationId ];
            for(Designation__c designation : designationList){
                contactId = designation.Contact__r.Id;
            }
            return contactId;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}