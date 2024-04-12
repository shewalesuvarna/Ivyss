@isTest
global class Test_callTransUnionCRAction {
       @isTest
    static void testSoapCallout_Success() {
        List<String> CreditOutput = new List<String>{'SSNNumber%%%123456789',
                                                     'FirstName%%%John',
                                                     'LastName%%%Doe',
                                                     'Apartmentnumber%%%Apt 123',
                                                     'Street%%%Main St',
                                                     'City%%%Springfield',
                                                     'State%%%IL',
                                                     'PostalCode%%%12345',
                                                     'country%%%us',
                                                     'RecordId%%%003an000001LvIrAAK'};

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
          

        Test.startTest();
        List<String> result = callTransUnionCRAction.callTransUnionCR(CreditOutput);
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Expected only one result');
         
    }

  @isTest
    static void testSoapCallout_Error() {
        List<String> CreditOutput = new List<String>{'SSNNumber%%%123456789',
                                                     'FirstName%%%John',
                                                     'LastName%%%Doe',
                                                     'Apartmentnumber%%%Apt 123',
                                                     'Street%%%Main St',
                                                     'City%%%Springfield',
                                                     'State%%%IL',
                                                     'PostalCode%%%12345',
                                                     'country%%%us',
                                                     'RecordId%%%003an000001LvIrAAK'};

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorError());

        Test.startTest();
        List<String> result = callTransUnionCRAction.callTransUnionCR(CreditOutput);
        Test.stopTest();

        // Assert that ErrorMsgs list is returned
        System.assertNotEquals(null, result, 'Error should be returned');
        System.assert(result.size() > 0, 'Error should be added to ErrorMsgs');
    } 

  public class MockHttpResponseGenerator implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'text/xml');
        res.setBody('<response><results>+750</results><transactionTimeStamp>2024-04-05T12:00:00Z</transactionTimeStamp><embeddedData>fake embedded data</embeddedData><error>null</error><description>Error message</description></response>');
        res.setStatusCode(200);
        return res;
    }
 }

    public class MockHttpResponseGeneratorError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            List<String> ErrorMsgs = new List<String>();
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'text/xml');
            res.setBody('<error><description>Error occurred</description></error>');
            res.setStatusCode(500);
            res.setStatus('500 Internal Server Error'); 
            ErrorMsgs.add('%%%Error occurred');
            return res;
        }
    }
 

}