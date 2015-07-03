# Let's Get Lightning!

We're out of the Apex woods for a little bit, and can focus on Lightning. In this module, we're going to create two Components. The first will represent a single campaign member, and the second will call our Apex controller using the first to display the list of members.

Wait? What?

We have one component that represents the list of all our campaign members. This component will execute our server-side Apex and get a the collection of members. For each member in that collection, we're going to "instantiate" (or create an instance of) our row component to display the details for that member.

![Layers of components](http://yuml.me/diagram/plain;dir:LR/class/,%20%5BCampaignMemberList%7CCampaignMemberRow%20--%20Will;CampaignMemberRow%20--%20Bob;CampaignMemberRow%20--%20Jane%5D.png)

This should help illustrate a very important fact about Lightning. If you know about Visualforce components, it's time to forget your preconcieved notions of what a "component" is. In Lightning a component is a resuable piece of UI, which could represent just a single letter or an entire app. Components can contain other components, and can be entire pages. Salesforce1 is itself a full Lightning app, and the components we are creating will exist inside SF1. Inside of our main component will be our row components, but those will be composed of more components to output text and UI. If you want to read more about the framework, check out the [Lightning Component Developer's Guide](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/intro_components.htm).

## That's enough theory, I want to build something!

Okay okay, let's start building. There are a lot of tools for developers on the Salesforce platform, but right now, the best way to build Lightning Components is with the developer console. You'll remember it from part two. 

We'll go to create our `CampaignMemberListRow` component first.

![Creating a component](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/86350e7e-631f-47b5-b650-78bf924f288b.png)

![Describe it](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/forcecom-developer-console.png)

We're dropped right into the component definition!

![Components have parts](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/forcecom-developer-console-1.png)

Now we're faced with a fact about components. They have parts! Your most basic component consists only of the component defintion. More complex components can have controllers, helpers, styles and more.

Our list component is going to have a controller, but we'll get there in part 3. Right now, we just want to focus on its markup. Let's dive into the component.

	<aura:component>
	<aura:attribute name="cmember" type="CampaignMember"/>
	<aura:attribute name="attended" type="Boolean" default="false"/>
		<article>
			<h1>
        		<ui:outputText value="{!v.cmember.Contact.Name}" click="{!c.gotoRecord}"/>
    		</h1>
			<ul>
				<li>RSVP <ui:outputText value="{!v.cmember.RSVP_Status__c}"/></li>
        		<li><ui:outputCurrency value="{!v.cmember.Contact.npo02__OppAmountThisYear__c}"/> in Current Fiscal Year</li>
        		<li><ui:inputcheckbox value="{!v.attended}"></ui:inputcheckbox></li>
  			</ul>
		</article>
	</aura:component>

That's fourteen lines of powerful Lightning. Some of this looks like normal old HTML, other parts look like nonsense. The most important things are happening right at the top.

`<aura:attribute>` is used to define "attributes", they're like "member variables" in Apex but put more simply, they hold the data that our component is working with. For each time our component is displayed, it will have specific values in the attributes that our component can then display. When we reference the component somewhere else, we have the ability to set its attributes.

Our first attribute is `cmember` which, unsurprisingly, contains the Campaign Member record that this row is going to display. 

The next attribute is `attended` which will power a checkbox controlling that members attendence at the event. Though attributes of type `Boolean` default to being false, we're also explicitly setting a default of false. Sometimes it can pay off big-time to just be explicit in your code.

After setting up the attributes, we create an HTML structure to render our data. In a later moment, we'll style this up to make it look like Salesforce1, but for now we just want to show it. We then use some [standard components](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/aura_compref.htm) from the UI library to show data from our campaign member. 

`<ui:outputText>` is a very handy component, that displays information from an SObject. To pass our data to it, we have to use a [Lightning expression](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/expr_overview.htm) for the value. Expressions take data from "value providers" (in this case, the letter v, which contains all of our components attributes) and allow other components to access them. `v.cmember.Contact.Name` roughly translates to "The name of the contact that the campaign member I am displaying is related to".

We also set a `click` handler on the `ui:outputText` component. With it set, when a user clicks or taps on the Contact Name, we'll trigger the `gotoRecord` event. That event isn't built yet, but we do know that we want our name to be clickable, so we're just going to think ahead.

## Okay, okay, we have a row, but how do we DISPLAY IT?!

Alright, you're gonna have to trust me on that previous component as working, because there's no easy way to just give it a test drive. The next step is to build the component that holds it. 

It's time to create another new component, this one is called `CampaignMemberList` and you can write your own description for it.

The component definition is going to load,  but let's jump into the controller first.

![Where to get the controller](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/forcecom-developer-console.png)

Double clicking controller in the sidebar will open up the controller!

	({
		doInit : function(cmp, event, helper) {
			var action = cmp.get("c.getCampaignMembers");
	        action.setParams({campaignid: 'YOUR CAMPAIGN ID HERE'});
	        action.setCallback(this, function(response) {
	            var state = response.getState();
	            if (cmp.isValid() && state === "SUCCESS") {
	                cmp.set("v.cmembers", response.getReturnValue());
	            }
	
	            // Display toast message to indicate load status
	            var toastEvent = $A.get("e.force:showToast");
	            if (state === 'SUCCESS'){
	                toastEvent.setParams({
	                    "title": "Success!",
	                    "message": " Your contacts have been loaded successfully."
	                });
	            }
	            else {
	                toastEvent.setParams({
	                        "title": "Error!",
	                        "message": " Something has gone wrong."
	                });
	            }
	            toastEvent.fire();
	        });
	      	$A.enqueueAction(action);
		}
	})	

This is the controller we want to use.

We are going to create a function in javascript called `doInit` which will run on the initizilation (or first load) of the component.

The function is fairly simple, though we have a few callbacks to show state. The important parts are at the top.

`cmp.get` is going to get the reference to our Apex controller method. In the component definition, we'll wire our component to the Apex controller, and here we are calling it. Well, we are creating an "action" of it. The next line sets a parameter (specifically, `campaignid`) on that action. Take the Salesforce ID of your test campaign and paste it in. In another part we'll start campaign selection, but until then we'll just hard code the ID.

We then start setting callbacks. The key line
	cmp.set("v.cmembers", response.getReturnValue());
takes the result of the action (in this case, a list of CampaignMembers) and sets the `cmembers` attribute on the component to that list.

Now, let's move back to the component definition:

	<aura:component implements="force:appHostable" controller="CampaignMemberListController">
	<aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
	<aura:attribute name="cmembers" type="CampaignMember[]"/>
		
	<header label="Campaign Members" title="Campaign Members">
		<h1>
			<span>Campaign Members</span>
	   		<span>
				<ui:outputText value="{!v.cmembers.length}"/> Campaign Members
	     	</span>
		</h1>
	</header>
	    
	<aura:iteration var="cmember" items="{!v.cmembers}">
		<c:CampaignMemberListRow cmember="{!cmember}"/>
	</aura:iteration>
	    
	</aura:component>

At the top of this definition, we have a lot going on. First of all, you'll see that our component `implements` the interface `force:appHostable`. This tells Salesforce that we intend for this component to be mounted as a tab in Salesforce1. We also set the Apex controller of this component to `CampaignMemberListController`, our Apex controller.

The next line sets a handler for the `init` event. The Lightning framework will issue an `init` event once the component is ready to be initialized. We're going to handle that event with our `doInit` controller method.

We have a normal attribute defintion, this time set for a List of CampaignMembers. After that, we define a little header, and then get into an `<aura:iteration`> loop. This special component is going to loop through a collection and output the body thing for each loop. In this case, we are looping through our `cmembers` attribute (as set by `doInit`), and for each member, storing that data in `cmember`. Then, we're rendering our Row component and setting it's `cmember` attribute to the member we are currently looking at.

Blam. This component is going to work!

## But...how do we use it?

In the last section, I noted that the component implements `force:appHostable` which lets it be mounted in SF1. So, let's try that out!

In Setup -> Create -> Tabs, scroll down to the Lightning Component Tabs section.

![Tabs](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/custom-tabs-~-salesforcecom---developer-edition.png)

Create a new Lightning Component Tab, and select our List component.

![Create Tab](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/new-lightning-component-tab-~-salesforcecom---developer-edition.png)

We ca accept the default profile settings.

Next, in Setup, on the sidebar there's a link for Salesforce1 Setup. Click that, and start the Quick Start Wizard.

As you click through the wizard, you'll get to a screen that lets you select your tabs.

![Tab selection screen](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/salesforce1-quick-start-wizard.png)

Add your new tab to the top of the list, and then finish out the wizard.

![Added Tab](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/salesforce1-quick-start-wizard-1.png)

Next, next, next, next, and finish it up.

Now, go to http://your-salesforce-instance.salesforce.com/one/one.app and login! Since your tab was at the top of the list in setup, it will autoload.

It may not be pretty yet...but it's there, and so is your data!

![The data](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/salesforce1.png)