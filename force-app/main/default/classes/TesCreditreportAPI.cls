public class TesCreditreportAPI {
    
  @InvocableMethod(label='Hard Pull call Ajit' description='xxx' category='TransUnion for Salesforce')
    public static List<String> TestSoapCallout(List<String> CreditOutput) 
    {
         System.debug('Apex class Input:'+CreditOutput);
        TU_CR_Settings__c ivytekSettings = TU_CR_Settings__c.getInstance();
        String ssnNumber = '';
        String firstName = '';
        String MiddelName = '';
        String lastName = '';
        String apartmentNumber = '';
        Integer apartnum ;
        String street = '';
        String city = '';
        String state = '';
        String country = 'us';
        String postalCode = '';
        String recordId = '';
        
        List<String> creditScores = new List<String>();
        List<String>ErrorMsgs=new List<String>();
        for(String output : CreditOutput) 
        
        {   
           Map<String, String> keyValuePairs = parseOutput(output);
           ssnNumber = keyValuePairs.get('SSNNumber');
           firstName = keyValuePairs.get('FirstName');
           lastName = keyValuePairs.get('LastName');
           apartmentNumber = keyValuePairs.get('Apartmentnumber');
           street = keyValuePairs.get('Street');
           city = keyValuePairs.get('City');
           state = keyValuePairs.get('State');
           postalCode = keyValuePairs.get('PostalCode');
           recordId = keyValuePairs.get('RecordId');
        }
        String ApartStreet = apartmentNumber + ' ' + street;
        System.debug('ssnNumber is:'+ ssnNumber);
        System.debug('firstName is:'+ firstName);
        System.debug('Middalname is:'+ MiddelName);
        System.debug('lastName is:'+ lastName);
        System.debug('apartmentNumber is:'+ apartmentNumber);
        System.debug('street is:'+ street);
        System.debug('ApartStreet is:'+ ApartStreet);
        System.debug('city is:'+ city);
        System.debug('state is:'+ state);
        System.debug('country is:'+ country);
        System.debug('postalCode is:'+ postalCode);
        
        
        String soapRequestBody = generateSoapRequest(ssnNumber, firstName, MiddelName, lastName, ApartStreet, city, state,country,postalCode, ivytekSettings);
        HttpResponse response = sendSoapRequest(soapRequestBody);
        
        if (response.getStatusCode() == 200)
        {
                      String responseBody = response.getBody();
                      list<String> responseToReturn=parseResponse(responseBody, creditScores, errorMsgs, recordId, firstName, lastName);
                      return responseToReturn;
         } 
        else 
        {
            String errorMessage = 'SOAP Callout Failed: ' + response.getStatusCode() + ' ' + response.getStatus();
            system.debug('Error Message==>'+ response.getBody());
            system.debug('Response Header==>'+ response.getHeaderKeys());
            System.debug(errorMessage);
          //  ErrorMsgs.add(errorMessage);
           // return ErrorMsgs;
          
           XmlStreamReader errorReader = new XmlStreamReader(response.getBody()); 
    while(errorReader.hasNext()) 
    {
        if(errorReader.getEventType() == XmlTag.START_ELEMENT && 'error' == errorReader.getLocalName())
        {
            while (errorReader.hasNext() && !(errorReader.getEventType() == XmlTag.END_ELEMENT && errorReader.getLocalName() == 'error'))
            {
                if (errorReader.getEventType() == XmlTag.START_ELEMENT && errorReader.getLocalName() == 'errormessage') 
                {
                    errorReader.next();
                    ErrorMsgs.add('SOAP Callout Failed: ' + response.getStatusCode() + '  ' + response.getStatus()+ '.' + errorReader.getText());
                }
                errorReader.next();
            }
            System.debug('Error Message is ==== '+ErrorMsgs);
            break;
        }
        errorReader.next();
    }
    
    return ErrorMsgs;
        }

    }
   
   
     private static Map<String, String> parseOutput(String output) 
     {
        Map<String, String> keyValuePairs = new Map<String, String>();
        List<String> pairs = output.split('&#&#&');
        for (String pair : pairs) {
            List<String> keyValue = pair.split('%%%');
            if (keyValue.size() == 2) 
            {
                keyValuePairs.put(keyValue[0].trim(), keyValue[1].trim());
            }
        }
        return keyValuePairs;
     }
    
    private static String generateSoapRequest(String ssnNumber, String firstName,String MiddelName, String lastName, String ApartStreet, String city, String state,String country, String postalCode, TU_CR_Settings__c ivytekSettings)
    {
        String soapRequestBody = '<?xml version="1.0" encoding="utf-8" ?> ' +
                                 '<xmlrequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' +
                                 'xmlns:soap="http://schemas.xmlsoap.org/soap/envelope"' +
                                 'xmlns=http://www.netaccess.transunion.com/namespace">' +  
                                //'<systemId>IVYTEKIN</systemId>' +
                                '<systemId>IVYTEKI1</systemId>' +
                                //'<systemPassword>Dynamisch123</systemPassword>' +
                               '<systemPassword>Transunion123</systemPassword>' +
                                '<productrequest>' +
                                '<creditBureau xmlns="http://www.transunion.com/namespace">' +
                                '<document>request</document>' +
                                '<version>2.26</version>' +
                                '<transactionControl>' +
                                //'<userRefNumber>XYZ_123_APPLICATION_328</userRefNumber>' +
                                '<subscriber>' +
                                '<industryCode>B</industryCode>' +
                                '<memberCode>3901536</memberCode>' +
                                '<inquirySubscriberPrefixCode>0622</inquirySubscriberPrefixCode>' +
                                '<password>L1Y5</password>' +
                                '</subscriber>' +
                                '<options>' +
                                '<processingEnvironment>standardTest</processingEnvironment>' +
                                '<country>' + country + '</country>' +
                                '<language>en</language>' +
                                '<contractualRelationship>individual</contractualRelationship>' +
                                '<pointOfSaleIndicator>none</pointOfSaleIndicator>' +
                                '</options>' +
                                '</transactionControl>' +
                                '<product>'+
                                '<code>07000</code>'+
                                '<subject>'+
                                '<number>1</number>'+
                                '<subjectRecord>'+
                                '<indicative>'+
                                '<name>'+
                                '<person>'+
                                '<first>'+ firstName + '</first>'+
                                '<middle>'+ MiddelName +'</middle>'+
                                '<last>' + lastName +'</last>'+
                                '</person>'+
                                '</name>'+
                                '<address>'+
                                '<status>current</status>'+
                                '<street>'+
                                '<unparsed> '+ApartStreet+' </unparsed>'+
                                '</street>'+
                                '<location>'+
                                '<city>' +city+ ' </city>'+
                                '<state>'+state+'</state>'+
                                '<zipCode>'+postalCode+'</zipCode>'+
                                '</location>'+
                                '</address>'+
                                '<socialSecurity>'+
                                '<number>'+ssnNumber+'</number>'+
                                '</socialSecurity>'+
                                '</indicative>'+
                                '<custom>'+
                                '<credit>'+
                                '<creditSummary>'+
                                '<returnAccountRating>false</returnAccountRating>'+
                                '</creditSummary>'+
                                '</credit>'+
                                '</custom>'+
                                '</subjectRecord>'+
                                '</subject>'+   
                                '<responseInstructions>'+
                                '<returnErrorText>true</returnErrorText>'+
                                '<embeddedData>pdf</embeddedData>'+
                                '<document></document>'+
                                '</responseInstructions>'+
                                '</product>'+
                                '</creditBureau>' +
                                '</productrequest>' +
                                '</xmlrequest>';
        return soapRequestBody;
    }
    
    private static HttpResponse sendSoapRequest(String soapRequestBody) 
    {
        HttpRequest request = new HttpRequest();
        request.setMethod('POST'); 
        request.setEndpoint('https://nacam-test.transunion.com:443');
        //request.setClientCertificateName('mycertificatealias123');
        request.setClientCertificateName('tucrcertsf2');
        request.setHeader('Content-Type', 'text/xml'); 
        request.setBody(soapRequestBody);
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('response:'+ response);
        return response;
    }
    
    private static list<String> parseResponse(String responseBody, List<String> creditScores, List<String> errorMsgs, String recordId, String firstName, String lastName)
    {
                String embeddedData;
                integer EmbeddedDataLoopcount=0;
                String CreditScore = 'Null'; 
                String transactionTimeStamp = null;
                Id contentVersionId;
                String Status;
                String StatusreportResult;
                String errorMessagess;
               List<String> addressList = new List<String>();
             
                System.debug('responseBody:'+ responseBody);
                XmlStreamReader reader = new XmlStreamReader(responseBody); 
                Boolean firstResultsFound = false; 
                while(reader.hasNext()) 
                      {
                              if(reader.getEventType() == XmlTag.START_ELEMENT && 'error' == reader.getLocalName())
                              {
                                   system.debug('===Inside error block===');
                                   while (reader.hasNext() && !(reader.getEventType() == XmlTag.END_ELEMENT && reader.getLocalName() == 'error'))
                                   {
                                       system.debug('===Inside error block111===');
                                       if (reader.getEventType() == XmlTag.START_ELEMENT && reader.getLocalName() == 'description') 
                                       {
                                            // Fetch the error description
                                            reader.next();
                                            errorMsgs.add('%%%'+ reader.getText());
                                            system.debug('===Inside error block222===');
                                       }
                                       reader.next();
                                 }
                                  System.debug('error message is:'+errorMsgs);
                                  break;
                              }
                          
                                //11-4 Chnages Thusrday
                             else if (reader.getEventType() == XmlTag.START_ELEMENT && 'fileHitIndicator' == reader.getLocalName() )
                              {
                                  system.debug('===Inside results block===');
                                    while(reader.hasNext()) 
                                    {
                                        if (reader.getEventType() == XmlTag.END_ELEMENT) 
                                        {
                                            break;
                                        } 
                                        else if (reader.getEventType() == XmlTag.CHARACTERS) 
                                        {
                                            Status = reader.getText().toLowerCase();
                                            System.debug('Status Value is :'+status);
                                             if (Status.equalsIgnoreCase('regularhit')) {
                                                     StatusreportResult = 'Hit';
                                                } else if (Status.equalsIgnoreCase('regularnohit')) {
                                                  StatusreportResult = 'No Hit';
                                                }
                                                else if (Status.equalsIgnoreCase('error')) {
                                                  StatusreportResult = 'Error';
                                                }
                                                else  {
                                                  StatusreportResult = 'Other';
                                                }
                                            System.debug('Status Report result is ='+StatusreportResult);
                                           
                                        }
                                        reader.next();
                                    }
                                }                          
                          
                          
                          
                             else if (reader.getEventType() == XmlTag.START_ELEMENT && 'results' == reader.getLocalName() && !firstResultsFound)
                              {
                                  system.debug('===Inside results block===');
                                    while(reader.hasNext()) 
                                    {
                                        if (reader.getEventType() == XmlTag.END_ELEMENT) 
                                        {
                                            break;
                                        } 
                                        else if (reader.getEventType() == XmlTag.CHARACTERS) 
                                        {
                                            CreditScore = reader.getText();
                                            System.debug('Credit Score is :'+CreditScore);
                                            firstResultsFound = true; 
                                        }
                                        reader.next();
                                    }
                                }
                                else if (reader.getEventType() == XmlTag.START_ELEMENT && 'transactionTimeStamp' == reader.getLocalName() && transactionTimeStamp == null)
                                {
                                system.debug('===Inside transactionTimeStamp if block===');
                                while(reader.hasNext()) 
                                {
                                    system.debug('===Inside transactionTimeStamp block===');
                                    if (reader.getEventType() == XmlTag.END_ELEMENT) 
                                    {
                                        system.debug('===Inside transactionTimeStamp end block===');
                                        break;
                                    } 
                                    else if (reader.getEventType() == XmlTag.CHARACTERS) 
                                    {
                                        system.debug('===Inside transactionTimeStamp character block===');
                                        transactionTimeStamp = reader.getText();
                                        System.debug('Transaction Time Stamp is :'+transactionTimeStamp);
                                    }
                                    reader.next();
                                }
                             }
                         
                          //monaday Changes 
                         else if (reader.getEventType() == XmlTag.START_ELEMENT && 'address' == reader.getLocalName()) {
            String address = '';
            Boolean isAddressContent = false;
            while (reader.hasNext()) {
                reader.next();
                if (reader.getEventType() == XmlTag.END_ELEMENT && 'address' == reader.getLocalName()) {
                    addressList.add(address);
                    break;
                } else if (reader.getEventType() == XmlTag.START_ELEMENT && ('street' == reader.getLocalName() || 'location' == reader.getLocalName())) {
                    isAddressContent = true;
                } else if (reader.getEventType() == XmlTag.END_ELEMENT && ('street' == reader.getLocalName() || 'location' == reader.getLocalName())) {
                    isAddressContent = false;
                } else if (reader.getEventType() == XmlTag.CHARACTERS && isAddressContent) {
                    address += reader.getText().trim() + ' ';
                }
            }
              //  System.debug('address is :'+address);
                   
        }
       //===========
           else if (reader.getEventType() == XmlTag.START_ELEMENT && 'embeddedData' == reader.getLocalName() && embeddedData== null) 
             {
             system.debug('===Inside embedded data if block===');
               while(reader.hasNext())
                 {
                   if (reader.getEventType() == XmlTag.END_ELEMENT)
                   {
                   system.debug('===Inside embeddedData end block===');
                         break;
                   } 
                   else if (reader.getEventType() == XmlTag.CHARACTERS)
                   {
                    EmbeddedDataLoopcount =EmbeddedDataLoopcount+1;
                      system.debug('===Inside embeddedData character block===');
                      if(EmbeddedDataLoopcount == 1)
                       {
                         embeddedData=reader.getText();
                            }
                               else
                                   {
                                embeddedData  = embeddedData + reader.getText();
                                    }
                                     system.debug('Embedded Data==>'+embeddedData);
                                       system.debug('Count==>'+EmbeddedDataLoopcount);
                                    }
                                    reader.next();
                                }
                            }
                           
                            reader.next();
            } 
        
         String address1 = '';
                    String address2 = '';
                    String address3 = '';
                
                   if (!addressList.isEmpty()) {
                   address1 = addressList[0];
                      System.debug('Current Address is :'+address1);    
                    }
                    if (addressList.size() >= 2) {
                     address2 = addressList[1];
                          System.debug('Previous address1 is :'+address2);
                    }
                    if (addressList.size() >= 3) {
                   address3 = addressList[2];
                          System.debug('Previous address2 is :'+address3);
                    }
        
                if(embeddedData !=null && recordId !=null && CreditScore !='Null')
                {
                   contentVersionId = savePDF(embeddedData,recordId,FirstName,LastName);
                }
                If(transactionTimeStamp != null)
                {  
                    Datetime utcDatetime = (Datetime)JSON.deserialize('"' + transactionTimeStamp + '"', Datetime.class);
                    System.debug('utcDatetime: ' + utcDatetime);
                    Datetime gmtDatetime = utcDatetime;
                    System.debug('GMT Datetime: ' + gmtDatetime);
                    String TU_Response ='errormessage='+errorMsgs+ 'Status='+Status+  'StatusreportResult='+StatusreportResult+'###'+CreditScore  +','+ gmtDatetime+',,'+contentVersionId+'CurrentAddress='+address1+'previousAddress1='+address2+'PreviousAddress2='+address3;
                    System.debug('TU_Response: ' + TU_Response);
                    System.debug('both TU_Response is:'+TU_Response); 
                    creditScores.add(TU_Response); 
                    System.debug('Credit score value is='+creditScores );
                    return creditScores;
                }
        
                else
                {
                    System.debug('Error Msgs==>'+ErrorMsgs);
                     return ErrorMsgs;//This is used to display error screen on flow.
              
                    
              }
    }
    public static Id savePDF(String base64Data , String recordId,String FirstName,String LastName) 
   {
        system.debug('===savePDF called===');
        System.debug('base64Data===>'+base64Data);
        Blob pdfBlob = EncodingUtil.base64Decode(base64Data);
        ContentVersion content = new ContentVersion();
        content.VersionData = pdfBlob;
        content.FirstPublishLocationId = recordId;
        content.Title = 'Credit_Report_'+FirstName+'_'+LastName; // Set a title for your PDF file
        content.PathOnClient = 'Credit_Report_'+FirstName+'_'+LastName+'.pdf'; // Set the filename with extension
 
        try 
        {
            insert content;
            System.debug('PDF file saved successfully with ContentVersion Id: ' + content.Id);
        } 
       catch(Exception e) 
       {
            System.debug('Error occurred while saving PDF file: ' + e.getMessage());
       }
         return content.Id;
    }
}