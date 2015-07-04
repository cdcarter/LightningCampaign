public with sharing class CampaignMemberListController {
    @AuraEnabled
    public static List<CampaignMember> getCampaignMembers(String campaignid) {
        return [SELECT Contact.Name, 
                Contact.npo02__OppAmountThisYear__c,
                ContactId,
                Status,
                RSVP_Status__c 
                FROM CampaignMember 
                WHERE CampaignId =: campaignid 
                  AND ContactId != null 
                  AND (Status = 'RSVPd' OR Status = 'Attended')
               ];
    }
}