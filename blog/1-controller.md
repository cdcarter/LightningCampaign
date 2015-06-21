# Creating an Apex Controller

Now, this tutorial may be about Lightning, but we do still have to use Apex to get some of the heavy lifting done. Lightning makes it very easy to work with data, but Apex (and SOQL) are how we get to that data in the first place.

## Open the Developer Console

We're going to spend this module (and much of the tutorial) in the Developer Console. This is a web based IDE (or Integrated Development Environment) that is directly connected to your Salesforce instance. In it we can write code, check it for errors, test out our queries, and more.

![Drop down menu to launch Developer Console](http://i.imgur.com/xmvAzoH.png)

Once you're in, we're going to create a new Apex class called `CampaignMemberListController`

![New Apex Class menu](http://i.imgur.com/GqX2dAA.png)
*New Apex Class menu*

![Name your class](http://i.imgur.com/UERr8Je.png)
*Name your class*

![We're ready to code](http://i.imgur.com/oBdAE0Q.png)
*We're ready to code*

## What does it need to do?

The Apex Controller's role is to act as a liason between the UI and the database. You can learn more about the [Model-View-Controller pattern](http://blog.codinghorror.com/understanding-model-view-controller/) if you'd like, but that's more heady than you really need. In this case we'll be using the controller a few times, but we have a simple need to start off:

### Find the members of a given campaign that we want to display in our component.

We're going to accomplish this with a SOQL query. Sometimes creating a SOQL query to get everything you want can take a few tries. I've found a few hints to make it go faster:

* Know some of the records you are hoping to find. Sometimes you might be writing a query and you don't actually have any data that matches what you want to get back! Make sure that you have records that match the criteria you want to search for, and know what a few of them are.
* Use the developer console! It has a tab for a query editor, which will save you a lot of time.
* Use Schema Builder! Schema Builder shows a graphical representation of your data. This way, you can quickly look at an object and see the fields you might want or need.

## The controller

    public with sharing class CampaignMemberListController {
        @AuraEnabled
        public static List<CampaignMember> getCampaignMembers(Id campaignId) {
            return [SELECT Contact.Name, 
                    Contact.npo02__OppAmountThisYear__c,
                    Status,
                    RSVP_Status__c 
                    FROM CampaignMember 
                    WHERE CampaignId =: campaignId 
                      AND ContactId != null 
                      AND (Status = 'RSVPd' OR Status = 'Attended')
                   ];
        }
    }

Our controller consists of exactly one method. The method has `@AuraEnabled` immediately above its declaration, which makes it accessible from Lightning Components. The method itself is defined as "public static" which is necessary for us to get at it from the UI as well. We declare that it will return a `List` of `CampaignMember` objects, we give it the name `getCampaignMembers`, and we declare that it will have one parameter called `campaignId`. As you can guess, that will be the Id of the Campaign we are working with.

The method then goes on to execute one SOQL query and return the results. SOQL can be a confusing language, but this one isn't too bad. We're going to `SELECT` (or get) the columns listed (the contact name, the contact giving this year, the membership status, and the RSVP status) `FROM` the CampaignMember table. 

We then get a little more specific with our `WHERE` clause. We want to only get members who are a part of the campaign that we passes as a parameter. We want to only get members that are Contacts (not Leads), and we want to only get members who have RSVPd or Attended the event.

## The test

If you know much about Apex, you know that for every class we must have a test! The test makes sure that our code is doing what we want it to do, and is playing nicely with the rest of our instance. Without good tests, little changes in your software or your org might ruin your code in ways you wouldn't notice until too far down the line.

Tests aren't strictly necessary in your development organization, but we do need them if we ever wanted to deploy the code. I've included a test below and some description of it, but you don't need to fully understand this to keep moving. In fact, at this time you can move on to [Module 2: The CampaignMemberList Component]() if you'd like.

We're going to do a very simple test that makes sure our method is pulling the right records. In the test, we'll create a test campaign, a few contacts, and a few campaign memberships. We'll run our controller method, and make sure it collected the right number of contacts.

    @isTest
    public class TestCampaignMemberListController {
        @testSetup static void setup() {
            
            Campaign c = new Campaign(Type='Event',Name='Test Campaign',IsActive=True);
            insert c;
            
            List<CampaignMemberStatus> statuses = new List<CampaignMemberStatus>();
            statuses.add(new CampaignMemberStatus(CampaignID=c.id,Label='RSVPd',IsDefault=false,HasResponded=true, SortOrder=3));
    		statuses.add(new CampaignMemberStatus(CampaignID=c.id,Label='Invited',IsDefault=true,HasResponded=false,SortOrder=4));
            statuses.add(new CampaignMemberStatus(CampaignID=c.id,Label='Attended',IsDefault=false,HasResponded=true,SortOrder=5));
            
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
            members.add(new CampaignMember(CampaignId=c.Id,ContactId=cc1.Id,Status='RSVPd',    RSVP_Status__c='Yes'));
            members.add(new CampaignMember(CampaignId=c.Id,ContactId=cc2.Id,Status='Attended',    RSVP_Status__c='Yes'));
            members.add(new CampaignMember(CampaignId=c.Id,ContactId=cc3.Id,Status='Invited'));
            
            insert members;
            
        }
        @isTest static void testGetCampaignMembers() {
            Campaign c = [Select Name,Id FROM Campaign][0];
    
            List<CampaignMember> result = CampaignMemberListController.getCampaignMembers(c.Id);
            System.assertEquals(2, result.size());
        }
    }

WHEW! That's a long test. The first method here is actually just creating a bunch of data for us. Our tests don't have access to any of the data in our organization (stopping your tests from accidentally deleting or changing real data) so we have to create a structure first.

The second method is our actual test. It runs our controller method, and makes sure the result is what we expected. 
