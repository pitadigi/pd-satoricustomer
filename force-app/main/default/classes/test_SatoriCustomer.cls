@isTest
class test_SatoriCustomer {
    @isTest
    static void test_doPost_NotExistsLead() {
        System.JSONGenerator j = JSON.createGenerator(false);
        j.writeStartObject();
        j.writeStringField('FirstName', 'Koji');
        j.writeStringField('LastName', 'Matae');
        j.writeStringField('Email', 'kmatae@pitadigi.jp');
        j.writeStringField('Company', 'ぴたデジ株式会社');
        j.writeStringField('Tags', 'お問い合わせ,見積が欲しい');
        j.writeStringField('Satori', 'https://satr.jp/action_events?customer_id=16600234');
        j.writeEndObject();

        TestParam param = new TestParam();
        param.customer = j.getAsString();

        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/satoricustomer';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(param));

        RestContext.request = req;
        RestContext.response = res;

        String ret = SatoriCustomer.doPost(param.customer);

        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(ret);
        Boolean result = (Boolean)m.get('result');
        System.assertEquals(result, true, '結果がtrueではありません');
        String message = (String)m.get('message');
        System.assertEquals(message, '', 'メッセージが空ではありません');

        Test.stopTest();
    }

    @isTest
    static void test_doPost_ExistsLead() {
        System.JSONGenerator j = JSON.createGenerator(false);
        j.writeStartObject();
        j.writeStringField('FirstName', 'Koji');
        j.writeStringField('LastName', 'Matae');
        j.writeStringField('Email', 'kmatae@pitadigi.jp');
        j.writeStringField('Company', 'ぴたデジ株式会社');
        j.writeStringField('Tags', 'お問い合わせ,見積が欲しい');
        j.writeStringField('Satori', 'https://satr.jp/action_events?customer_id=16600234');
        j.writeEndObject();

        Lead l = new Lead();
        l.FirstName = 'Koji';
        l.LastName = 'Matae';
        l.Email = 'kmatae@pitadigi.jp';
        l.Company = 'ぴたデジ株式会社';
        insert l;

        TestParam param = new TestParam();
        param.customer = j.getAsString();

        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/satoricustomer';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(param));

        RestContext.request = req;
        RestContext.response = res;

        String ret = SatoriCustomer.doPost(param.customer);

        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(ret);
        Boolean result = (Boolean)m.get('result');
        System.assertEquals(result, true, '結果がtrueではありません');
        String message = (String)m.get('message');
        System.assertEquals(message, '', 'メッセージが空ではありません');

        Test.stopTest();
    }

    @isTest
    static void test_doPost_ExistsContact() {
        System.JSONGenerator j = JSON.createGenerator(false);
        j.writeStartObject();
        j.writeStringField('FirstName', 'Koji');
        j.writeStringField('LastName', 'Matae');
        j.writeStringField('Email', 'kmatae@pitadigi.jp');
        j.writeStringField('Company', 'ぴたデジ株式会社');
        j.writeStringField('Tags', 'お問い合わせ,見積が欲しい');
        j.writeStringField('Satori', 'https://satr.jp/action_events?customer_id=16600234');
        j.writeEndObject();

        Contact c = new Contact();
        c.FirstName = 'Koji';
        c.LastName = 'Matae';
        c.Email = 'kmatae@pitadigi.jp';
        insert c;

        TestParam param = new TestParam();
        param.customer = j.getAsString();

        Test.startTest();

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/satoricustomer';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(param));

        RestContext.request = req;
        RestContext.response = res;

        String ret = SatoriCustomer.doPost(param.customer);

        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(ret);
        Boolean result = (Boolean)m.get('result');
        System.assertEquals(result, true, '結果がtrueではありません');
        String message = (String)m.get('message');
        System.assertEquals(message, '', 'メッセージが空ではありません');

        Test.stopTest();
    }

    class TestParam {
        public String customer;
    }
}
