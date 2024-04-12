public class CallTransUnionTLOAction {
    @InvocableMethod(label='Call TransUnion TLO' description='Process Last Name and Address' category='TransUnion for Salesforce')
    public static List<String> callTransUnionTLO(List<String> conIds){
        List<String> contactInfo = new List<String>();
        
        if (conIds != null && !conIds.isEmpty()) {
            List<Contact> queriedContacts = [SELECT Last_TU_Credit_Report_Request__c,Last_TU_Credit_Report_Request_Result__c,Last_TU_People_Search__c,
                                             Last_TU_People_Search_Result__c,TU_Address_1__c,TU_Address_2__c,TU_Address_3__c,Social_Security_Number__c, 
                                             FirstName,LastName,MailingCity,MailingState,MailingStreet,MailingCountry,MailingPostalCode, TransUnion_Report_Token__c 
                                             FROM Contact 
                                             WHERE Id = :conIds[0]];
            
            for (Contact con : queriedContacts) {
                String inputData = '';
                //inputData += 'SSN Number:'+ con.Social_Security_Number__c + ', ';
                //inputData += 'First Name:'+ con.FirstName + ', ';
                //inputData += 'Last Name:'+ con.LastName + ', ';
                  inputData += 'TranUnion Token:'+ con.TransUnion_Report_Token__c + ', ';
                //inputData += 'Apartment Number:'+ con.Apartment_Number__c + ', ';
                //inputData += 'City: ' + con.MailingCity + ', ';
                //inputData += 'State: ' + con.MailingState + ', ';
                //inputData += 'Street: ' + con.MailingStreet + ', ';
                //inputData += 'Country: ' + con.MailingCountry + ', ';
                //inputData += 'Postal Code: ' + con.MailingPostalCode + ', ';
                inputData += 'Last TU Credit Report Request: '+ con.Last_TU_Credit_Report_Request__c + ',';
                inputData += 'Last TU Credit Report Request Result: '+ con.Last_TU_Credit_Report_Request_Result__c + ',';
                inputData += 'Last TU People Search : '+ con.Last_TU_People_Search__c + ',';
                inputData += 'Last TU People Search Result : '+ con.Last_TU_People_Search_Result__c + ',';
                inputData += 'TU Address 1 : '+ con.TU_Address_1__c + ',';
                inputData += 'TU Address 2 : '+ con.TU_Address_2__c + ',';
                inputData += 'TU Address 3 : '+ con.TU_Address_3__c + ',';
                
                contactInfo.add(inputData); 
                System.debug('Input Data: ' + inputData);
            }
        }
       return contactInfo;
    }
}