public class callTUCRSetting {
    @InvocableMethod
    public static void callTransUnionTLO(List<String> inputList) {

        system.debug('InputList==>'+inputList);
        
        //List<TU_CR_Settings__c> settings = [SELECT Id, TU_SystemID__c, TU_System_Password__c, TU_Certificate_Name__c, TU_Industry_Code__c, TU_Inquiry_Subscriber_Prefix_Code__c, TU_Member_Code__c, TU_Password__c, TU_Vendor_Id__c FROM TU_CR_Settings__c];
        
        TU_CR_Settings__c settings = TU_CR_Settings__c.getOrgDefaults();
        
        List<TU_CR_Settings__c> settingsToUpdate = new List<TU_CR_Settings__c>();

        for (String input : inputList) 
        {   
            Map<String, String> keyValuePairs = parseInput(input);
            String industryCode = keyValuePairs.get('Industrycode');
            String inquiry = keyValuePairs.get('Inquiry');
            String Member = keyValuePairs.get('Member');
            String Password = keyValuePairs.get('Password');
            String vendor = keyValuePairs.get('vendor');
            String SystemPassword = keyValuePairs.get('SystemPassword');
            String SystemID = keyValuePairs.get('SystemID');
            String Certificate = keyValuePairs.get('Certificate');
            System.debug('Certificate: '+Certificate);
            
                settings.TU_Industry_Code__c = industryCode;
                settings.TU_Inquiry_Subscriber_Prefix_Code__c = inquiry;
                settings.TU_Member_Code__c = Member;
                settings.TU_Password__c = Password;
                settings.TU_Vendor_Id__c = vendor;
                settings.TU_System_Password__c = SystemPassword;
                settings.TU_Certificate_Name__c = Certificate;
                settings.TU_SystemID__c=SystemID;
       
        // Update all settings in one DML operation
        update settingsToUpdate;
    }
    }

    private static Map<String, String> parseInput(String input) 
    {
        Map<String, String> keyValuePairs = new Map<String, String>();
        List<String> pairs = input.split(',');
        System.debug('pairs:'+pairs);
		for (String pair : pairs) {
            List<String> keyValue = pair.split('-');
            if (keyValue.size() == 2) {
                keyValuePairs.put(keyValue[0].trim(), keyValue[1].trim());
            }
        }
        System.debug('keyValuePairs:'+keyValuePairs);

        return keyValuePairs;
    }
}
