@RestResource(urlMapping='/satoricustomer/*')
global with sharing class SatoriCustomer {
    /**
     * SATORIのカスタマー情報をSalesforceのリード、取引先責任者に登録する
     * メールアドレスで取引先責任者を検索し、ヒットしたらSatori__cにSATORIカスタマーURLを設定する
     * 取引先責任者がヒットしなければリードを検索し、存在したらSatori__cにSATORIカスタマーURLを設定する
     * リードに存在しなければリードを作成する
     * @param customer
     * SATORIカスタマー情報はJSON文字列で以下のデータが受け渡される
     * {
     *   FirstName: 名
     *   LastName: 姓
     *   Email: メールアドレス
     *   Company: 会社名
     *   Tags: SATORIタグ
     *   Satori: SATORI URL
     * }
     * @returns 登録結果を以下のJSON文字列で返す
     * {
     *   result: true / false
     *   message: エラーメッセージ
     * }
     */
    @HttpPost
    global static String doPost(String customer) {
        Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(customer);

        System.JSONGenerator j = JSON.createGenerator(false);
        j.writeStartObject();

        Boolean result = true;
        String message = '';
        String firstName = (String)m.get('FirstName');
        String lastName = (String)m.get('LastName');
        String email = (String)m.get('Email');
        String company = (String)m.get('Company');
        String tags = (String)m.get('Tags');
        String satori = (String)m.get('Satori');

        // 取引先責任者をメールアドレスで検索する
        List<Contact> lstc = [SELECT Id,Satori__c,Tags__c FROM Contact WHERE Email=:email ORDER BY SystemModStamp DESC];
        if (lstc.size() != 0) {
            lstc[0].Satori__c = satori;
            lstc[0].Tags__c = tags;
            try {
                update lstc[0];
            }
            catch(DmlException e) {
                result = false;
                message = e.getMessage();
            }
        }
        // リードをメールアドレスで検索する
        else {
            List<Lead> lstl = [SELECT Id,Satori__c,Tags__c FROM Lead WHERE Email=:email ORDER BY SystemModStamp DESC];
            if (lstl.size() != 0) {
                lstl[0].Satori__c = satori;
                lstl[0].Tags__c = tags;

                try {
                    update lstl[0];
                }
                catch(DmlException e) {
                    result = false;
                    message = e.getMessage();
                }
            }
            else {
                Lead l = new Lead();
                l.FirstName = firstName;
                l.LastName = lastName;
                l.Email = email;
                l.Company = company;
                l.Tags__c = tags;
                l.Satori__c = satori;

                try {
                    insert l;
                }
                catch(DmlException e) {
                    result = false;
                    message = e.getMessage();
                }
            }
        }

        j.writeBooleanField('result', result);
        j.writeStringField('message', message);
        j.writeEndObject();
        return j.getAsString();
    }
}
