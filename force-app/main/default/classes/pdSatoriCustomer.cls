@RestResource(urlMapping='/macustomer/*')
global with sharing class pdSatoriCustomer {
    /**
     * SATORIのカスタマー情報をSalesforceのリードに登録する
     * 同じメールアドレスのリード、取引先責任者が存在する場合は、該当リード、取引先責任者を重複リード、重複取引先責任者として登録する
     * @param customer
     * SATORIカスタマー情報はJSON文字列で以下のデータが受け渡される
     * {
     *   FirstName: 名
     *   LastName: 姓
     *   Email: メールアドレス
     *   Company: 会社名
     *   Memo: お問い合わせ内容
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
        String memo = (String)m.get('Memo');
        String tags = (String)m.get('Tags');
        String satori = (String)m.get('Satori');
        
        // 取引先責任者をメールアドレスで検索する
        List<Contact> lstc = [SELECT Id FROM Contact WHERE Email=:email ORDER BY SystemModStamp DESC];
        // リードをメールアドレスで検索する
        List<Lead> lstl = [SELECT Id FROM Lead WHERE Email=:email ORDER BY SystemModStamp DESC];

        Lead l = new Lead();
        l.FirstName = firstName;
        l.LastName = lastName;
        l.Email = email;
        l.Company = company;
        l.Description = memo;
        l.SatoriUrl__c = satori;
        l.SatoriTags__c = tags;
        l.LeadSource = 'Webサイト';
        if (lstc.size() != 0) {
            l.DuplicatedContact__c = lstc[0].Id;
        }
        if (lstl.size() != 0) {
            l.DuplicatedLead__c = lstl[0].Id;
        }

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        l.setOptions(dmo);

        try {
            insert l;
        }
        catch(DmlException e) {
            result = false;
            message = e.getMessage();
        }

        j.writeBooleanField('result', result);
        j.writeStringField('message', message);
        j.writeEndObject();
        return j.getAsString();
    }
}
