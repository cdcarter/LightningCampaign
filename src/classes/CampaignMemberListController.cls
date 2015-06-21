public with sharing class CampaignMemberListController {
    @AuraEnabled
    public static List<CampaignMember> getCampaignMembers(Id campaignid) {
        return [SELECT Contact.Name, 
                Contact.npo02__OppAmountThisYear__c,
                Status,
                RSVP_Status__c 
                FROM CampaignMember 
                WHERE CampaignId =: campaignid 
                  AND ContactId != null 
                  AND (Status = 'RSVPd' OR Status = 'Attended')
               ];
    }
}