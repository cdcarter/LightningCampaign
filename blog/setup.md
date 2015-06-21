# Let's Get Started with Lightning Components

This post is the first part in a multi-part tutorial where we'll write our first Lightning Component. Lightning is, for lack of a better term, the future of the Salesforce platform. Lightning technology powers:

* Process Builder, every point-and-click admin's new best friend
* Lightning Connect, the easiest way to integrate with external data sources in Salesforce
* the Lighning App Builder, a new tool with a lot of power coming down the line
* and... Lightning Components!

## What are they?

Lightning Components are a new framework and system for creating reusable "components" or chunks of code and interface. They are probably the eventual replacement for Visualforce, but even when Visualforce is still kicking around -- Lightning Components are the absolute best way to develop new interface for the Salesforce1 Mobile App, and mobile devices in general.

## What are we going to build?

In the not-for-profit community, one of the big uses of the Campaign object and Campaign Memberships is to track attendance at events. Be they fundraising parties, client workshops, or classes for your community, Campaigns are the standard way for not-for-profits to determine if someone was somewhere. 

In this tutorial, we are going to integrate a set of Lightning Components of our own development into the Salesforce1 Mobile App that lets us take attendance or check-in attendees at an event. 

Your event staff will open up the mobile app on their phone or tablet, see a list of RSVPs, and mark Contacts as attended when they arrive. They'll be able to click on each Contact to see more details, and they'll be able to alert other members of the staff when key Contacts arrive.

## I'm only an admin!

This tutorial is going to expect a basic level of HTML, Javascript, and Apex knowledge. You'll probably be able to get away with copying and pasting, but the more you know about the technology that drives what we're doing, the easier it will be for you to create your own Lightning Components in the future. If you're just an admin, give it a try to follow along and feel free to ask questions on the Hub or by twitter when you get stuck. If you feel in over your head, that's okay. Once the tutorial is all written, you'll be able to install this component as a package without any coding.

## A note on wireframes

Throughout the tutorial, we'll start by looking at UI mockups of what we want to see. Our final product isn't guaranteed to match these mockups, instead we use them as a jumping off point for what our interface needs to provide our users.

The first Component we will tackle (and the most important one) is the Campaign Attendees screen:

![Campaign Attendees Screen](http://i.imgur.com/RILD4Uu.png)

The this component is hosted in the mobile app, so the standard navigation header is at the top. We then follow the Salesforce1 Style Guide for a design that fits in with the rest of the app. We display the name of the event, how many people we are expecting, and then a card for each Contact. The card displays their name, their RSVP status, their total giving in the current fiscal year, and a checkbox to mark them as attended.

## Our data model

In order to keep things simple, we're going to assume you are on stock NPSP 3.0 with the Household Account Model. In fact, I just spun up a new Developer Organization for myself and installed NPSP in an otherwise clean slate. If you want to follow along exactly, you can do the same. You can also start a new Developer Sandbox from your own organization, but be aware that you may need to tweak field names here and there. Particularly if you are not on the Household model, keep in mind where your donation rollups live.

![Class Diagram for Contact, Campaign, and Campaign Membership](http://i.imgur.com/v4vrlKv.png)

For this app, we're going to use the standard Campaign and Campaign Member objects, in addition to Contact. We're using one standard rollup from the NPSP, and we are creating one custom field on Campaign Member called `RSVP_Status__c`. We'll use this field to store if a Contact RSVP'd Yes, Maybe, or No. This is in addition to the CampaignMember Status. CampaignMember `Status` will have the options of "To Invite, Invited, RSVPd, Attended". The combination of the two fields will let us know how many of our people respond to our invites, how many people attended the party in total, how many of our "Maybe" RSVPers attended, and how many of our "Yes" RSVPers didn't attend. These are all useful metrics that your events manager will love.

We're also going to create a picklist option for `Type` on Campaign called "Event". We'll use this to display the active event campaigns for which our staff might be checking people in.

## That was a lot of words, what do I need to have done to get started?

1. You'll need a Developer sandbox or Org with NPSP 3.0 installed. 
2. You need to create a custom picklist on CampaignMember called `RSVP_Status__c` with options "Yes, Maybe, No"
3. Add "Event" to the `Type` picklist on Campaign
4. Create a new Campaign called "Pre-Show Dinner" of type "Event" and used "Advanced Setup" to give it the Member Status options of "To Invite, Invited, RSVPd, Attended".

![Campaign Member Status setup](http://i.imgur.com/TScIBqq.png)

5. Create a few contacts and some donations for them, so that we have some data to work with! You can use [this CSV file](https://www.dropbox.com/s/k21sd170ghk43qv/NPSP%20Data%20Contacts.csv?dl=0) with the NPSP data importer to add a pile of fake contacts.
6. Add some of those contacts to the "Pre-Show Dinner" Campaign
7. Enable Lightning Components for your organization. This is found in Setup -> Develop -> Lightning Components. Check "Enable Lightning Components in Salesforce1 (BETA)", accept the pop-up, and then hit save.
8. Wait for the next installment!
