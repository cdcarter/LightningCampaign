# Let's make it usable.

Now, we have our data displaying in a component. It just doesn't look great. Thankfully, the folks at Salesforce created a [style guide for Salesforce1](http://sfdc-styleguide.herokuapp.com/). We're going to use their CSS and all. First step is to upload [this file](https://raw.githubusercontent.com/cdcarter/LightningCampaign/master/sf1style.css) as a static resource called `sf1guide` with Cache Control set to public.

This is a version of the SFDC Styleguide CSS that's namespaced as `sf1guide`, to stop our component styles doing anything weird to SF1.

Now, the CSS for the Sf1 styleguide is pretty gnarly, so instead of diving into it, I'm just going to have you paste in new component definitions for each component. All we'll be doing is adding the classes needed to style this up, and I'm going to ask you to trust me on the class names.

### CampaignMemberListRow.cmp
	<aura:component >
	<aura:attribute name="cmember" type="CampaignMember"/>
	<aura:attribute name="attended" type="Boolean" default="false"/>
	<article class="mtn mam bg-1 border border--3 pam brm">
		<h1 class="man f3 text-color-1 fw-semibold">
	        <ui:outputText value="{!v.cmember.Contact.Name}" click="{!c.gotoRecord}"/>
	    </h1>
		<ul class="clear list-plain man pan">
			<li class="mbs f5 text-color-2">RSVP <ui:outputText value="{!v.cmember.RSVP_Status__c}"/></li>
	        <li class="fl f3 text-color-1"><ui:outputCurrency value="{!v.cmember.Contact.	npo02__OppAmountThisYear__c}"/> in Current Fiscal Year</li>
	        <li class="fr f3 text-color-1"><ui:inputCheckbox value="{!v.attended}"></ui:inputCheckbox></li>
	  	</ul>
	</article>
	</aura:component>

### CampaignMemberList.cmp
	<aura:component implements="force:appHostable,flexipage:availableForAllPageTypes" controller="	CampaignMemberListController">
	<ltng:require styles="/resource/sf1guide"/>
	<aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
	<aura:attribute name="cmembers" type="CampaignMember[]"/>
	
	<div class="sf1guide">
	
	<header class="bg-2" label="Campaign Members" title="Campaign Members" icon="campaign-members">
		<div class="icon icon--campaign-members brs bgs-100 a-mid mhm sq-30"></div>
		<h1 class="dib thin a-mid">
			<span class="db f3 text-color-1">Campaign Members</span>
	   		<span class="db f6 lower">
				<ui:outputText value="{!v.cmembers.length}"/> Campaign Members
	     	</span>
		</h1>
	</header>
	    
	<aura:iteration var="cmember" items="{!v.cmembers}">
		<c:CampaignMemberListRow cmember="{!cmember}"/>
	</aura:iteration>
	    
	</div>
	</aura:component>

The only thing we've done here is add CSS classes, and the `<ltng:require>` which references our static resource.

Now, go on over to SF1 and take a look at your app now!

![CSS is here](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-21h19m/images/docs/untitled/forcecom-developer-console.png)

Sure looks a heckuva lot better doesn't it? Now we have something worth showing off. But it needs some real features. Remember, we want to be able to click the contact to go to their contact record, and of course, we want to mark people as actually attended. We haven't been away from Apex for long enough, so let's start by making contacts clickable.

### The `gotoRecord` function

Right now, when you click a contacts name, you're going to get an error. This is because in our component definition, we set a handler for the click event, but that handler doesn't exist yet. We tell the component to call `gotoRecord` when we click, but without writing that function it just fails!

So, let's write that function. Open up `CampaignMemberListRow` in the developer console, and double click Controller to create the controller. Here's the very simple controller we're going to need.

	({
		gotoRecord : function(component, event, helper) {
	        var action = $A.get("e.force:navigateToSObject");
	        action.setParams({
	            "recordId": component.get("v.cmember.ContactId")
	        });
	        action.fire();
		}
	})

Now, the syntax might look similar to when we called an action in our `init` handler. In this case, we're going to get the standard Salesforce1 event `force:navigateToSObject` which navigates the SF1 to the details page of a given record. We then set a parameter of `recordId` to the `ContactId` of the campaign member this component is rendering.

Save it up, and hop on back to SF1. Refresh, and then try clicking a name! Instead of an error, we get successful navigation. The back button even works as expected. All that is built in.

Now let's move on to [part 4]() where we start adding more Apex to edit data.