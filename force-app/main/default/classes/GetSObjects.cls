public with sharing class GetSObjects {
    public static List<String> getAllCustomSObjects(){
    List<String> sObjectList = new List<String>();
    for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values())
    {
        Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
        if(describeSObjectResultObj.isCustom())
        {
            String name = objTyp.getDescribe().getName();
            // Exclude all the unwanted Sobjects e.g. History, Share etc..
            if(!name.containsignorecase('history') && !name.containsignorecase('tag')&&
             !name.containsignorecase('share') && !name.containsignorecase('feed'))
            {
                SobjectList.add(name);
            }
        }
    }
    system.debug('SObjectList : ' + SObjectList);
    return sObjectList;
    }

}