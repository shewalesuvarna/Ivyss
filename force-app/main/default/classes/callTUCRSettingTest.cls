@isTest
Public class callTUCRSettingTest {
    @isTest
    static void callTUCRSetting () {
        // Create test data
        TU_CR_Settings__c settings = new TU_CR_Settings__c();  
        	settings.TU_Industry_Code__c = 'T';
            settings.TU_Certificate_Name__c='tucr';	
            settings.TU_Inquiry_Subscriber_Prefix_Code__c = '0522';
            settings.TU_Member_Code__c = '1234567';
            settings.TU_Password__c = 'L1Y2';
            settings.TU_Vendor_Id__c = '1234';
        	settings.TU_SystemID__c='Dynamisch';
        	settings.TU_System_Password__c='Dynamisch123';
        	insert settings;
        
        
        	settings.TU_Industry_Code__c = 'I';
        	update settings;
        
        	List<String> inputList = new List<String>{'Industrycode-I, Inquiry-0522, Member-1234567, Password-L1Y2, vendor-1234,SystemID-123,SystemPassword-Dyna123,Certificate-Dynamisch'};
        
        	Test.startTest();
        	// Call the method
       		callTUCRSetting.callTransUnionTLO(inputList);
        Test.stopTest();
  }
}