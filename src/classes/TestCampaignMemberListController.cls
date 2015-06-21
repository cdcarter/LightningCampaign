@isTest
public class TestCampaignMemberListController {
    @testSetup static void setup() {
        
        Campaign c = new Campaign(Type='Event',Name='Test Campaign',IsActive=True);
        insert c;
        
        List<CampaignMemberStatus> statuses = new List<CampaignMemberStatus>();
        statuses.add(new CampaignMemberStatus(
    		CampaignID=c.id,
    		Label='RSVPd',
    		IsDefault=false,
    		HasResponded=true,
    		SortOrder=3
		));
		statuses.add(new CampaignMemberStatus(
    		CampaignID=c.id,
    		Label='Invited',
    		IsDefault=true,
    		HasResponded=false,
    		SortOrder=4
		));
        
        statuses.add(new CampaignMemberStatus(
    		CampaignID=c.id,
    		Label='Attended',
    		IsDefault=false,
    		HasResponded=true,
    		SortOrder=5
		));
        
        insert statuses;
        
        List<Contact> ccs = new List<Contact>();
        Contact cc1 = new Contact(FirstName='Bill',LastName='Billiam');
        ccs.add(cc1);
        Contact cc2 = new Contact(FirstName='Mary',LastName='Marysville');
        ccs.add(cc2);
        Contact cc3 = new Contact(FirstName='Sara',LastName='Sarafina');
        ccs.add(cc3);
        
        insert ccs;
        
        List<CampaignMember> members = new List<CampaignMember>();
        members.add(new CampaignMember(CampaignId=c.Id,ContactId=cc1.Id,Status='RSVPd',RSVP_Status__c='Yes'));
        members.add(new CampaignMember(CampaignId=c.Id,ContactId=cc2.Id,Status='Attended',RSVP_Status__c='Yes'));
        members.add(new CampaignMember(CampaignId=c.Id,ContactId=cc3.Id,Status='Invited'));
        
        insert members;
        
    }
    @isTest static void testGetCampaignMembers() {
        Campaign c = [Select Name,Id FROM Campaign][0];

        List<CampaignMember> result = CampaignMemberListController.getCampaignMembers(c.Id);
        System.assertEquals(2, result.size());
    }
}